import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:six_pack_30/Core/Models/workout_model.dart';
import 'package:six_pack_30/Core/Network/api_service_provider.dart';
import 'package:six_pack_30/Core/Network/api_service.dart';

  return WorkoutNotifier(ref.watch(apiServiceProvider));
});

  final ApiService _apiService;

  WorkoutNotifier(this._apiService) : super(const AsyncValue.loading()) {
    fetchWorkouts();
  }

  Future<void> fetchWorkouts() async {
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

      final data = await _apiService.getWorkouts(token);
      if (data != null) {
        final workouts = data.map((item) => WorkoutModel.fromJson(item)).toList();
        state = AsyncValue.data(workouts);
      } else {
        state = const AsyncValue.data([]);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
