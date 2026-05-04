import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WorkoutProgress {
  final int dayNumber;
  final int exerciseIndex;
  final int setIndex;
  final String title;
  final DateTime timestamp;

  WorkoutProgress({
    required this.dayNumber,
    required this.exerciseIndex,
    required this.setIndex,
    required this.title,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'dayNumber': dayNumber,
    'exerciseIndex': exerciseIndex,
    'setIndex': setIndex,
    'title': title,
    'timestamp': timestamp.toIso8601String(),
  };

  factory WorkoutProgress.fromJson(Map<String, dynamic> json) => WorkoutProgress(
    dayNumber: json['dayNumber'],
    exerciseIndex: json['exerciseIndex'],
    setIndex: json['setIndex'],
    title: json['title'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}

class WorkoutProgressService {
  static const String _key = 'workout_progress';

  static Future<void> saveProgress(WorkoutProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(progress.toJson()));
  }

  static Future<WorkoutProgress?> getProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_key);
    if (data == null) return null;
    
    try {
      final progress = WorkoutProgress.fromJson(jsonDecode(data));
      
      if (DateTime.now().difference(progress.timestamp).inHours > 24) {
        await clearProgress();
        return null;
      }
      return progress;
    } catch (e) {
      return null;
    }
  }

  static Future<void> clearProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
