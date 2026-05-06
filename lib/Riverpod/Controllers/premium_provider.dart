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
  final notifier = PremiumNotifier(ref);
  
  ref.listen(authControllerProvider, (previous, next) {
    next.whenData((user) {
      if (user != null) {
        notifier.logIn(user.uid);
      } else {
        notifier.logOut();
      }
    });
  });
  
  return notifier;
});

class PremiumNotifier extends StateNotifier<AsyncValue<bool>> {
  final Ref _ref;
  final ApiService _apiService = ApiService();

  PremiumNotifier(this._ref) : super(const AsyncValue.loading()) {
    initPlatformState();
  }

  bool get _isPremiumFromDb => _ref.read(userProfileProvider).value?.isPremium ?? false;

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
      await updatePurchaseStatus();
    } catch (e) {
      if (kDebugMode) print('RevenueCat LogOut Error: $e');
    }
  }

  bool _checkPremiumEntitlement(CustomerInfo customerInfo) {
    return customerInfo.entitlements.active.containsKey('premium') || 
           customerInfo.entitlements.active.containsKey('Premium') ||
           customerInfo.entitlements.active.containsKey('pro') ||
           customerInfo.entitlements.active.containsKey('SixPack30 Pro') ||
           customerInfo.entitlements.active.containsKey('all_access');
  }

  Future<void> updatePurchaseStatus() async {
    try {
      if (_isPremiumFromDb) {
        state = const AsyncValue.data(true);
        return;
      }

      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      final bool isPremiumRC = _checkPremiumEntitlement(customerInfo);
      
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
      final bool isPremium = _checkPremiumEntitlement(customerInfo);
      
      if (isPremium) {
        state = const AsyncValue.data(true); // Update immediately
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final token = await user.getIdToken();
          if (token != null) {
            await _apiService.updatePremiumStatus(token, true);
            _ref.invalidate(userProfileProvider);
          }
        }
      } else {
        state = AsyncValue.data(_isPremiumFromDb);
      }
      
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
      final bool isPremium = _checkPremiumEntitlement(customerInfo);
      
      if (isPremium) {
        state = const AsyncValue.data(true); // Update immediately
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final token = await user.getIdToken();
          if (token != null) {
            await _apiService.updatePremiumStatus(token, true);
            _ref.invalidate(userProfileProvider);
          }
        }
      } else {
        state = AsyncValue.data(_isPremiumFromDb);
      }
    } catch (e) {
      await updatePurchaseStatus();
    }
  }
}
