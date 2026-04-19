import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:six_pack_30/Core/Models/stats_model.dart';
import 'package:six_pack_30/Core/Network/api_service_provider.dart';
import 'package:six_pack_30/Core/Network/api_service.dart';

final statsProvider = StateNotifierProvider<StatsNotifier, AsyncValue<UserStats?>>((ref) {
  return StatsNotifier(ref.watch(apiServiceProvider));
});

class StatsNotifier extends StateNotifier<AsyncValue<UserStats?>> {
  final ApiService _apiService;
  static const String _statsKey = 'user_stats_local';

  StatsNotifier(this._apiService) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    await _loadLocalStats();
    await fetchStats();
  }

  Future<void> _loadLocalStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final statsJson = prefs.getString(_statsKey);
      if (statsJson != null) {
        final stats = UserStats.fromJson(jsonDecode(statsJson));
        state = AsyncValue.data(stats);
      } else if (state.value == null) {
        state = AsyncValue.data(UserStats.initial());
      }
    } catch (e) {
    }
  }

  Future<void> _saveLocalStats(UserStats stats) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_statsKey, jsonEncode(stats.toJson()));
    } catch (e) {
    }
  }

  Future<void> fetchStats() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (state.value == null) {
          state = AsyncValue.data(UserStats.initial());
        }
        return;
      }

      final token = await user.getIdToken();
      if (token == null) {
        if (state.value == null) {
          state = AsyncValue.data(UserStats.initial());
        }
        return;
      }

      final statsData = await _apiService.getStats(token);
      if (statsData != null) {
        final stats = UserStats.fromJson(statsData);
        state = AsyncValue.data(stats);
        await _saveLocalStats(stats);
      } else if (state.value == null) {
        state = AsyncValue.data(UserStats.initial());
      }
    } catch (e, st) {
      if (state.value == null) {
        state = AsyncValue.error(e, st);
      }
    }
  }

  Future<void> updateWater(double amount) async {
    final currentStats = state.value ?? UserStats.initial();

    final updatedStats = UserStats(
      totalActivity: currentStats.totalActivity,
      totalKcal: currentStats.totalKcal,
      weightLost: currentStats.weightLost,
      streak: currentStats.streak,
      bpm: currentStats.bpm,
      steps: currentStats.steps,
      waterIntake: amount,
      fatRate: currentStats.fatRate,
      initialFatRate: currentStats.initialFatRate,
      initialMuscleMass: currentStats.initialMuscleMass,
      muscleMass: currentStats.muscleMass,
      totalDuration: currentStats.totalDuration,
      totalMoves: currentStats.totalMoves,
      completionRate: currentStats.completionRate,
      weight: currentStats.weight,
      initialWeight: currentStats.initialWeight,
      targetWeight: currentStats.targetWeight,
      sleepDuration: currentStats.sleepDuration,
      recentExercises: currentStats.recentExercises,
      completedDays: currentStats.completedDays,
      completedAtDates: currentStats.completedAtDates,
    );
    
    state = AsyncValue.data(updatedStats);
    await _saveLocalStats(updatedStats);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final token = await user.getIdToken();
        if (token != null) {
          await _apiService.updateWaterIntake(token, amount);
        }
      }
    } catch (e) {
    }
  }

  Future<void> completeDay(int dayNumber) async {
    final currentStats = state.value ?? UserStats.initial();

    if (currentStats.completedDays.contains(dayNumber)) return;

    final newList = List<int>.from(currentStats.completedDays)..add(dayNumber);
    newList.sort();

    final todayStr = DateTime.now().toIso8601String().split('T')[0];
    final newDatesList = List<String>.from(currentStats.completedAtDates);
    if (!newDatesList.contains(todayStr)) {
      newDatesList.add(todayStr);
    }

    final updatedStats = UserStats(
      totalActivity: currentStats.totalActivity + 1,
      totalKcal: currentStats.totalKcal,
      weightLost: currentStats.weightLost,
      streak: currentStats.streak + 1,
      bpm: currentStats.bpm,
      steps: currentStats.steps,
      waterIntake: currentStats.waterIntake,
      fatRate: currentStats.fatRate,
      initialFatRate: currentStats.initialFatRate,
      initialMuscleMass: currentStats.initialMuscleMass,
      muscleMass: currentStats.muscleMass,
      totalDuration: currentStats.totalDuration,
      totalMoves: currentStats.totalMoves,
      completionRate: currentStats.completionRate,
      weight: currentStats.weight,
      initialWeight: currentStats.initialWeight,
      targetWeight: currentStats.targetWeight,
      sleepDuration: currentStats.sleepDuration,
      recentExercises: currentStats.recentExercises,
      completedDays: newList,
      completedAtDates: newDatesList,
    );
    
    state = AsyncValue.data(updatedStats);
    await _saveLocalStats(updatedStats);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final token = await user.getIdToken();
        if (token != null) {
          await _apiService.completeDay(token, dayNumber);
        }
      }
    } catch (e) {
    }
  }
}
