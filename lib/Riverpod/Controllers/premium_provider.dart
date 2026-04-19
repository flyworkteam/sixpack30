import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

final premiumProvider = StateNotifierProvider<PremiumNotifier, AsyncValue<bool>>((ref) {
  return PremiumNotifier();
});

class PremiumNotifier extends StateNotifier<AsyncValue<bool>> {
  PremiumNotifier() : super(const AsyncValue.loading()) {
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    try {
      state = const AsyncValue.loading();
      
      const String appleKey = 'appl_jyrUJntKMMUQGZnCLhPdjFGryqx';
      const String androidKey = 'goog_nIGerJpZODcxIvudTtLkrTrptev';

      await Purchases.setLogLevel(LogLevel.debug);

      PurchasesConfiguration configuration;
      if (Platform.isAndroid) {
        configuration = PurchasesConfiguration(androidKey);
      } else {
        configuration = PurchasesConfiguration(appleKey);
      }
      
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        configuration.appUserID = user.uid;
      }

      await Purchases.configure(configuration);
      
      await updatePurchaseStatus();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updatePurchaseStatus() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      final bool isPremium = customerInfo.entitlements.active.containsKey('premium');
      state = AsyncValue.data(isPremium);
    } catch (e) {
      state = AsyncValue.data(false);
    }
  }

  Future<List<Package>> getOfferings() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      
      if (offerings.current == null) {
        return [];
      }

      if (offerings.current!.availablePackages.isEmpty) {
        return [];
      }

      return offerings.current!.availablePackages;
    } catch (e) {
    }
    return [];
  }

  Future<bool> purchasePackage(Package package) async {
    try {
      state = const AsyncValue.loading();
      CustomerInfo customerInfo = await Purchases.purchasePackage(package);
      final bool isPremium = customerInfo.entitlements.active.containsKey('premium');
      state = AsyncValue.data(isPremium);
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
      final bool isPremium = customerInfo.entitlements.active.containsKey('premium');
      state = AsyncValue.data(isPremium);
    } catch (e) {
      await updatePurchaseStatus();
    }
  }
}
