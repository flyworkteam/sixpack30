import 'package:flutter/foundation.dart';
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
      if (!state.hasValue) {
        state = const AsyncValue.loading();
      }
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
      debugPrint('Profile data from API: $profileData');
      
      if (profileData != null) {
        final userModel = UserModel.fromJson(profileData);
        state = AsyncValue.data(userModel);
      } else {
        
        state = AsyncValue.data(UserModel(
          id: 0,
          firebaseUid: user.uid,
          email: user.email,
          name: user.displayName ?? 'Kullanıcı',
          healthConnected: false,
          notificationsEnabled: true,
        ));
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
        debugPrint('Notifications toggle clicked: $enabled');
        
        if (state.value != null) {
          final updatedUser = state.value!.copyWith(notificationsEnabled: enabled);
          state = AsyncValue.data(updatedUser);
          debugPrint('Provider State Updated - Notifications: ${updatedUser.notificationsEnabled}');
        }
        
        if (enabled) {
          OneSignal.User.pushSubscription.optIn();
        } else {
          OneSignal.User.pushSubscription.optOut();
        }
      }

      if (data.containsKey('healthConnected')) {
        final bool enabled = data['healthConnected'];
        debugPrint('Health toggle clicked: $enabled');
        
        if (state.value != null) {
          final updatedUser = state.value!.copyWith(healthConnected: enabled);
          state = AsyncValue.data(updatedUser);
          debugPrint('Provider State Updated - Health: ${updatedUser.healthConnected}');
        }
        
        if (enabled) {
          _healthService.requestPermissions().then((granted) {
            debugPrint('Health permission status: $granted');
            if (granted) {
              _healthService.syncHealthData();
            }
          });
        }
      }

      if (data.containsKey('name') && data['name'] != null) {
        final String newName = data['name'];
        await user.updateDisplayName(newName);
        await user.reload();
      }

      if (data.containsKey('photoUrl') && data['photoUrl'] != null) {
        final String newPhoto = data['photoUrl'];
        await user.updatePhotoURL(newPhoto);
        await user.reload();
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
