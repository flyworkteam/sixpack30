import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:six_pack_30/Core/Network/api_service.dart';

final notificationProvider = StateNotifierProvider<NotificationNotifier, AsyncValue<List<dynamic>>>((ref) {
  return NotificationNotifier();
});

class NotificationNotifier extends StateNotifier<AsyncValue<List<dynamic>>> {
  final ApiService _apiService = ApiService();

  NotificationNotifier() : super(const AsyncValue.loading()) {
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      state = const AsyncValue.loading();
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        state = const AsyncValue.data([]);
        return;
      }

      final token = await user.getIdToken();
      if (token == null) {
        state = const AsyncValue.data([]);
        return;
      }

      final notifications = await _apiService.getNotifications(token);
      
      final updatedNotifications = (notifications ?? []).map((notif) {
        final notifMap = Map<String, dynamic>.from(notif as Map);
        final String title = notifMap['title']?.toString() ?? '';
        final String body = notifMap['body']?.toString() ?? '';
        
        if (title.contains('Anket') || body.contains('Anket')) {
          notifMap['title'] = 'Tebrikler! 🎉';
          notifMap['body'] = 'Profilini başarıyla oluşturduk. Hayalindeki vücuda ulaşmak için ilk antrenmanına hemen başla!';
        }
        return notifMap;
      }).toList();

      state = AsyncValue.data(updatedNotifications);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteAll() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final token = await user?.getIdToken();
      if (token != null) {
        await _apiService.deleteAllNotifications(token);
        state = const AsyncValue.data([]);
      }
    } catch (e) {
    }
  }
}
