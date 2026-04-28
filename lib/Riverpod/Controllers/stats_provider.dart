import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:six_pack_30/Core/Models/stats_model.dart';
import 'package:six_pack_30/Core/Network/api_service_provider.dart';
import 'package:six_pack_30/Core/Network/api_service.dart';
import 'package:six_pack_30/Riverpod/Controllers/user_provider.dart';
import 'package:six_pack_30/Riverpod/Controllers/workout_provider.dart';
import 'package:six_pack_30/Core/Data/workout_data.dart';

final statsProvider = StateNotifierProvider<StatsNotifier, AsyncValue<UserStats?>>((ref) {
  return StatsNotifier(ref.watch(apiServiceProvider), ref);
});

class StatsNotifier extends StateNotifier<AsyncValue<UserStats?>> {
  final ApiService _apiService;
  final Ref _ref;
  static const String _statsKey = 'user_stats_local';

  StatsNotifier(this._apiService, this._ref) : super(const AsyncValue.loading()) {
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
        final user = _ref.read(userProfileProvider).value;
        final q = user?.questionnaire;
        state = AsyncValue.data(UserStats.initial(
          weight: q?.weight ?? 70.0,
          initialWeight: q?.weight ?? 70.0,
          targetWeight: q?.targetWeight ?? 70.0,
        ));
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
    final localStatsBeforeLoading = state.value;
    try {
      if (localStatsBeforeLoading == null) {
        state = const AsyncValue.loading();
      }
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (localStatsBeforeLoading == null) {
          final userProfile = _ref.read(userProfileProvider).value;
          final q = userProfile?.questionnaire;
          state = AsyncValue.data(UserStats.initial(
            weight: q?.weight ?? 70.0,
            initialWeight: q?.weight ?? 70.0,
            targetWeight: q?.targetWeight ?? 70.0,
          ));
        }
        return;
      }

      final token = await user.getIdToken();
      if (token == null) {
        if (state.value == null) {
          final user = _ref.read(userProfileProvider).value;
          final q = user?.questionnaire;
          state = AsyncValue.data(UserStats.initial(
            weight: q?.weight ?? 70.0,
            initialWeight: q?.weight ?? 70.0,
            targetWeight: q?.targetWeight ?? 70.0,
          ));
        }
        return;
      }

      final statsData = await _apiService.getStats(token);
      if (statsData != null) {
        final backendStats = UserStats.fromJson(statsData);
        
        final localStats = state.value;
        
        Set<int> mergedDaysSet = Set<int>.from(backendStats.completedDays);
        if (localStats != null) {
          mergedDaysSet.addAll(localStats.completedDays);
          
          for (int day in localStats.completedDays) {
            if (!backendStats.completedDays.contains(day)) {
              _apiService.completeDay(token, day).catchError((_) => false);
            }
          }
        }
        List<int> mergedDays = mergedDaysSet.toList()..sort();

        final stats = UserStats(
          totalActivity: (localStats?.totalActivity ?? 0) > backendStats.totalActivity ? localStats!.totalActivity : backendStats.totalActivity,
          totalKcal: (localStats?.totalKcal ?? 0.0) > backendStats.totalKcal ? localStats!.totalKcal : backendStats.totalKcal,
          weightLost: (localStats?.weightLost ?? 0.0) > backendStats.weightLost ? localStats!.weightLost : backendStats.weightLost,
          streak: (localStats?.streak ?? 0) > backendStats.streak ? localStats!.streak : backendStats.streak,
          bpm: backendStats.bpm,
          steps: backendStats.steps,
          waterIntake: (localStats?.waterIntake ?? 0.0) > backendStats.waterIntake ? localStats!.waterIntake : backendStats.waterIntake,
          fatRate: backendStats.fatRate,
          initialFatRate: backendStats.initialFatRate,
          initialMuscleMass: backendStats.initialMuscleMass,
          muscleMass: backendStats.muscleMass,
          totalDuration: (localStats?.totalDuration ?? 0) > backendStats.totalDuration ? localStats!.totalDuration : backendStats.totalDuration,
          totalMoves: (localStats?.totalMoves ?? 0) > backendStats.totalMoves ? localStats!.totalMoves : backendStats.totalMoves,
          completionRate: (localStats?.completionRate ?? 0) > backendStats.completionRate ? localStats!.completionRate : backendStats.completionRate,
          weight: backendStats.weight,
          initialWeight: backendStats.initialWeight,
          targetWeight: backendStats.targetWeight,
          sleepDuration: backendStats.sleepDuration,
          recentExercises: (localStats?.recentExercises.length ?? 0) > backendStats.recentExercises.length ? localStats!.recentExercises : backendStats.recentExercises,
          completedDays: mergedDays,
          completedAtDates: (localStats?.completedAtDates.length ?? 0) > backendStats.completedAtDates.length ? localStats!.completedAtDates : backendStats.completedAtDates,
        );

        state = AsyncValue.data(stats);
        await _saveLocalStats(stats);
      } else {
        if (!state.hasValue || state.value == null) {
          final userProfile = _ref.read(userProfileProvider).value;
          final q = userProfile?.questionnaire;
          state = AsyncValue.data(UserStats.initial(
            weight: q?.weight ?? 70.0,
            initialWeight: q?.weight ?? 70.0,
            targetWeight: q?.targetWeight ?? 70.0,
          ));
        }
      }
    } catch (e, st) {
      if (!state.hasValue || state.value == null) {
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

  Future<void> completeDay(int dayNumber, {int? duration, int? calories}) async {
    final currentStats = state.value ?? UserStats.initial();

    if (currentStats.completedDays.contains(dayNumber)) return;

    final newList = List<int>.from(currentStats.completedDays)..add(dayNumber);
    newList.sort();

    final todayStr = DateTime.now().toIso8601String().split('T')[0];
    final newDatesList = List<String>.from(currentStats.completedAtDates);
    if (!newDatesList.contains(todayStr)) {
      newDatesList.add(todayStr);
    }

    final newRecent = List<RecentExercise>.from(currentStats.recentExercises);
    
    newRecent.removeWhere((e) => e.id == dayNumber);
    newRecent.insert(0, RecentExercise(
      id: dayNumber,
      title: 'Day $dayNumber',
      category: 'Karın',
      progress: 1.0,
      progressText: '100%',
      imagePath: 'assets/images/detayantrenman.jpg',
    ));
    if (newRecent.length > 5) newRecent.removeLast();

    final workoutList = _ref.read(workoutProvider).value;
    final workoutApi = workoutList?.where((w) => w.id == dayNumber).firstOrNull;
    
    int workoutDuration = duration ?? 15;
    int workoutMoves = 20;
    int workoutKcal = calories ?? 250;

    if (workoutApi != null) {
      if (duration == null) workoutDuration = workoutApi.durationMinutes;
      workoutMoves = workoutApi.exerciseCount ?? 20;
      if (calories == null) workoutKcal = workoutApi.calories ?? 250;
    } else if (duration == null || calories == null) {
      final staticWorkout = StaticWorkoutData.getWorkoutForDay(dayNumber);
      workoutDuration = duration ?? 10;
      workoutMoves = staticWorkout.exercises.length > 0 ? staticWorkout.exercises.length : 15;
      workoutKcal = calories ?? (workoutMoves * 12);
    }

    // Use a more visible simulation for progress (at least 0.1kg loss)
    final double simulatedWeightLoss = (workoutKcal / 7700.0).clamp(0.1, 1.0);
    final double newWeight = currentStats.weight - simulatedWeightLoss;
    final double newWeightLost = currentStats.initialWeight - newWeight;
    final double newCompletionRate = (newList.length / 30.0) * 100.0;

    final updatedStats = UserStats(
      totalActivity: currentStats.totalActivity + 1,
      totalKcal: currentStats.totalKcal + workoutKcal,
      weightLost: newWeightLost,
      streak: currentStats.streak + 1,
      bpm: currentStats.bpm,
      steps: currentStats.steps,
      waterIntake: currentStats.waterIntake,
      fatRate: (currentStats.fatRate - 1).clamp(5, 40),
      initialFatRate: currentStats.initialFatRate,
      initialMuscleMass: currentStats.initialMuscleMass,
      muscleMass: currentStats.muscleMass + 0.1,
      totalDuration: currentStats.totalDuration + workoutDuration,
      totalMoves: currentStats.totalMoves + workoutMoves,
      completionRate: newCompletionRate.toInt(),
      weight: newWeight,
      initialWeight: currentStats.initialWeight,
      targetWeight: currentStats.targetWeight,
      sleepDuration: currentStats.sleepDuration,
      recentExercises: newRecent,
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
          await _apiService.completeDay(token, dayNumber, 
            duration: workoutDuration, 
            calories: workoutKcal
          );
        }
      }
    } catch (e) {
    }
  }
}
