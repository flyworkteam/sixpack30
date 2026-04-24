import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Core/Services/workout_progress_service.dart';

final workoutProgressProvider = StateNotifierProvider<WorkoutProgressNotifier, WorkoutProgress?>((ref) {
  return WorkoutProgressNotifier();
});

class WorkoutProgressNotifier extends StateNotifier<WorkoutProgress?> {
  WorkoutProgressNotifier() : super(null) {
    loadProgress();
  }

  Future<void> loadProgress() async {
    final progress = await WorkoutProgressService.getProgress();
    state = progress;
  }

  Future<void> saveProgress(WorkoutProgress progress) async {
    await WorkoutProgressService.saveProgress(progress);
    state = progress;
  }

  Future<void> clearProgress() async {
    await WorkoutProgressService.clearProgress();
    state = null;
  }
}
