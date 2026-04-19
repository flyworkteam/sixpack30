import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:six_pack_30/Core/Models/user_model.dart';
import 'package:six_pack_30/Core/Network/api_service_provider.dart';
import 'package:six_pack_30/Core/Network/api_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:six_pack_30/Core/Services/health_service.dart';

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, AsyncValue<UserModel?>>((ref) {
  return UserProfileNotifier(ref.watch(apiServiceProvider));
});

class UserProfileNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final ApiService _apiService;
  final HealthService _healthService = HealthService();

  UserProfileNotifier(this._apiService) : super(const AsyncValue.loading()) {
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      state = const AsyncValue.loading();
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        state = const AsyncValue.data(null);
        return;
      }

      final token = await user.getIdToken();
      if (token == null) {
        state = const AsyncValue.data(null);
        return;
      }

      final profileData = await _apiService.getProfile(token);
      if (profileData != null) {
        final userModel = UserModel.fromJson(profileData);
        state = AsyncValue.data(userModel);
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      final token = await user.getIdToken();
      if (token == null) return false;

      if (data.containsKey('notificationsEnabled')) {
        final bool enabled = data['notificationsEnabled'];
        if (enabled) {
          OneSignal.User.pushSubscription.optIn();
        } else {
          OneSignal.User.pushSubscription.optOut();
        }
      }

      if (data.containsKey('healthConnected') && data['healthConnected'] == true) {
        await _healthService.requestPermissions();
        _healthService.syncHealthData();
      }

      final success = await _apiService.updateProfile(token, data);
      if (success) {
        await fetchProfile();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  void clear() {
    state = const AsyncValue.data(null);
  }
}
