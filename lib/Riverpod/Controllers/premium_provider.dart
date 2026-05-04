import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:six_pack_30/Riverpod/Controllers/auth_controller.dart';
import 'package:six_pack_30/Riverpod/Controllers/user_provider.dart';
import 'package:six_pack_30/Core/Network/api_service.dart';
import 'package:six_pack_30/Core/Network/api_service_provider.dart';

final premiumProvider = StateNotifierProvider<PremiumNotifier, AsyncValue<bool>>((ref) {
  final authState = ref.watch(authControllerProvider);
  final userProfile = ref.watch(userProfileProvider).value;
  final apiService = ref.watch(apiServiceProvider);
  
  final notifier = PremiumNotifier(apiService, ref);
  
  // Listen to auth changes to log in/out of RevenueCat
  authState.whenData((user) {
    if (user != null) {
      notifier.logIn(user.uid);
    } else {
      notifier.logOut();
    }
  });
  
  // If database says user is premium, we prioritize that or combine it.
  if (userProfile?.isPremium == true) {
    notifier.setPremiumFromDb(true);
  } else {
    // If DB doesn't say premium, we still rely on RevenueCat check which happens inside notifier
  }
  
  return notifier;
});

class PremiumNotifier extends StateNotifier<AsyncValue<bool>> {
  final ApiService _apiService;
  final Ref _ref;
  bool _isPremiumFromDb = false;

  PremiumNotifier(this._apiService, this._ref) : super(const AsyncValue.loading()) {
    initPlatformState();
  }

  void setPremiumFromDb(bool value) {
    _isPremiumFromDb = value;
    // If DB is premium, immediately update state to true
    if (value && (state.value != true)) {
      state = const AsyncValue.data(true);
    }
  }

  Future<void> initPlatformState() async {
    try {
      if (!_isPremiumFromDb) {
        state = const AsyncValue.loading();
      }
      
      await updatePurchaseStatus();
    } catch (e, st) {
      if (!_isPremiumFromDb) {
        state = AsyncValue.error(e, st);
      }
    }
  }

  Future<void> logIn(String uid) async {
    try {
      await Purchases.logIn(uid);
      await updatePurchaseStatus();
    } catch (e) {
      if (kDebugMode) print('RevenueCat LogIn Error: $e');
    }
  }

  Future<void> logOut() async {
    try {
      await Purchases.logOut();
      _isPremiumFromDb = false;
      await updatePurchaseStatus();
    } catch (e) {
      if (kDebugMode) print('RevenueCat LogOut Error: $e');
    }
  }

  Future<void> updatePurchaseStatus() async {
    try {
      if (_isPremiumFromDb) {
        state = const AsyncValue.data(true);
        return;
      }

      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      final bool isPremiumRC = customerInfo.entitlements.active.containsKey('premium') || 
                               customerInfo.entitlements.active.containsKey('Premium') ||
                               customerInfo.entitlements.active.containsKey('pro') ||
                               customerInfo.entitlements.active.containsKey('all_access');
      
      // Sync with backend if RC says premium but DB is not yet aware
      if (isPremiumRC && !_isPremiumFromDb) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final token = await user.getIdToken();
          if (token != null) {
            await _apiService.updatePremiumStatus(token, true);
            // Refresh user profile to update local state
            _ref.invalidate(userProfileProvider);
          }
        }
      }

      state = AsyncValue.data(isPremiumRC || _isPremiumFromDb);
    } catch (e) {
      state = AsyncValue.data(_isPremiumFromDb);
    }
  }

  Future<List<Package>> getOfferings() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current == null) return [];
      return offerings.current!.availablePackages;
    } catch (e) {
      return [];
    }
  }

  Future<bool> purchasePackage(Package package) async {
    try {
      state = const AsyncValue.loading();
      CustomerInfo customerInfo = await Purchases.purchasePackage(package);
      final bool isPremium = customerInfo.entitlements.active.containsKey('premium') || 
                             customerInfo.entitlements.active.containsKey('Premium');
      
      if (isPremium) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final token = await user.getIdToken();
          if (token != null) {
            await _apiService.updatePremiumStatus(token, true);
            _ref.invalidate(userProfileProvider);
          }
        }
      }
      
      state = AsyncValue.data(isPremium || _isPremiumFromDb);
      return isPremium;
    } catch (e) {
      await updatePurchaseStatus();
      return false;
    }
  }

  Future<void> restorePurchases() async {
    try {
      state = const AsyncValue.loading();
      CustomerInfo customerInfo = await Purchases.restorePurchases();
      final bool isPremium = customerInfo.entitlements.active.containsKey('premium') || 
                             customerInfo.entitlements.active.containsKey('Premium');
      
      if (isPremium) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final token = await user.getIdToken();
          if (token != null) {
            await _apiService.updatePremiumStatus(token, true);
            _ref.invalidate(userProfileProvider);
          }
        }
      }
      
      state = AsyncValue.data(isPremium || _isPremiumFromDb);
    } catch (e) {
      await updatePurchaseStatus();
    }
  }
}
