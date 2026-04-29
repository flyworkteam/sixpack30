import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:six_pack_30/Core/Models/user_model.dart';
import 'package:six_pack_30/Core/Network/api_service_provider.dart';
import 'package:six_pack_30/Core/Network/api_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:six_pack_30/Core/Services/health_service.dart';
import 'package:six_pack_30/Riverpod/Controllers/stats_provider.dart';

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, AsyncValue<UserModel?>>((ref) {
  return UserProfileNotifier(ref.watch(apiServiceProvider), ref);
});

class UserProfileNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final ApiService _apiService;
  final Ref _ref;
  final HealthService _healthService = HealthService();

  UserProfileNotifier(this._apiService, this._ref) : super(const AsyncValue.loading()) {
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

      final data = await _apiService.getProfile(token);
      debugPrint('>>> FETCH PROFILE RAW DATA: $data');
      if (data != null) {
        final userModel = UserModel.fromJson(data);
        state = AsyncValue.data(userModel);
        
        if (userModel.id != 0) {
          OneSignal.login(userModel.id.toString());
          if (userModel.name != null) OneSignal.User.addTags({"name": userModel.name!});
        }
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
        debugPrint('Notifications toggle clicked: $enabled');
        
        if (state.value != null) {
          final updatedUser = state.value!.copyWith(notificationsEnabled: enabled);
          state = AsyncValue.data(updatedUser);
          debugPrint('Provider State Updated - Notifications: ${updatedUser.notificationsEnabled}');
        }
      }

      if (data.containsKey('healthConnected')) {
        final bool enabled = data['healthConnected'];
        debugPrint('Health connection toggle clicked: $enabled');
        
        if (state.value != null) {
          final updatedUser = state.value!.copyWith(healthConnected: enabled);
          state = AsyncValue.data(updatedUser);
          debugPrint('Provider State Updated - Health: ${updatedUser.healthConnected}');
        }
        
        if (enabled) {
          debugPrint('Requesting Health Permissions...');
          _healthService.requestPermissions().then((granted) async {
            debugPrint('Health permission result: $granted');
            if (granted) {
              await _healthService.syncHealthData();
            } else {
              debugPrint('Health permission denied or failed.');
              // recursive call yerine sadece durumu güncelle
              if (state.value != null) {
                state = AsyncValue.data(state.value!.copyWith(healthConnected: false));
              }
            }
          }).catchError((err) {
            debugPrint('Health permission catchError: $err');
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

      debugPrint('>>> UPDATING PROFILE WITH DATA: $data');
      final success = await _apiService.updateProfile(token, data);
      if (success) {
        await fetchProfile();
        // Profil güncellendiğinde istatistikleri (kilo, boy vb.) de yenile
        _ref.read(statsProvider.notifier).fetchStats();
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
