class RecentExercise {
  final int id;
  final String title;
  final String category;
  final String? imagePath;
  final double progress;
  final String progressText;

  RecentExercise({
    required this.id,
    required this.title,
    required this.category,
    this.imagePath,
    required this.progress,
    required this.progressText,
  });

  factory RecentExercise.fromJson(Map<String, dynamic> json) {
    return RecentExercise(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      imagePath: json['imagePath'],
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      progressText: json['progressText'] ?? '0%',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'imagePath': imagePath,
      'progress': progress,
      'progressText': progressText,
    };
  }
}

class UserStats {
  final int totalActivity;
  final double totalKcal;
  final double weightLost;
  final int streak;
  final int bpm;
  final int steps;
  final double waterIntake;
  final int fatRate;
  final double muscleMass;
  final int totalDuration;
  final int totalMoves;
  final int completionRate;
  final double weight;
  final double initialWeight;
  final double targetWeight;
  final int initialFatRate;
  final double initialMuscleMass;
  final String sleepDuration;
  final List<RecentExercise> recentExercises;
  final List<int> completedDays;
  final List<String> completedAtDates;

  UserStats({
    required this.totalActivity,
    required this.totalKcal,
    required this.weightLost,
    required this.streak,
    required this.bpm,
    required this.steps,
    required this.waterIntake,
    required this.fatRate,
    required this.muscleMass,
    required this.totalDuration,
    required this.totalMoves,
    required this.completionRate,
    required this.weight,
    required this.initialWeight,
    required this.targetWeight,
    required this.initialFatRate,
    required this.initialMuscleMass,
    required this.sleepDuration,
    required this.recentExercises,
    required this.completedDays,
    required this.completedAtDates,
  });

  factory UserStats.initial() {
    return UserStats(
      totalActivity: 0,
      totalKcal: 0.0,
      weightLost: 0.0,
      streak: 0,
      bpm: 0,
      steps: 0,
      waterIntake: 0.0,
      fatRate: 24,
      muscleMass: 30.0,
      totalDuration: 0,
      totalMoves: 0,
      completionRate: 0,
      weight: 70.0,
      initialWeight: 70.0,
      targetWeight: 70.0,
      initialFatRate: 24,
      initialMuscleMass: 30.0,
      sleepDuration: '0 Saat',
      recentExercises: [],
      completedDays: [],
      completedAtDates: [],
    );
  }

  factory UserStats.fromJson(Map<String, dynamic> json) {
    var list = json['recentExercises'] as List? ?? [];
    List<RecentExercise> recentList = list.map((i) => RecentExercise.fromJson(i)).toList();

    var dayList = json['completedDays'] as List? ?? [];
    List<int> completedDays = dayList.map((e) => (e is num) ? e.toInt() : 0).toList();

    return UserStats(
      totalActivity: (json['totalActivity'] as num?)?.toInt() ?? 0,
      totalKcal: (json['totalKcal'] as num?)?.toDouble() ?? 0.0,
      weightLost: (json['weightLost'] as num?)?.toDouble() ?? 0.0,
      streak: (json['streak'] as num?)?.toInt() ?? 0,
      bpm: (json['bpm'] as num?)?.toInt() ?? 0,
      steps: (json['steps'] as num?)?.toInt() ?? 0,
      waterIntake: (json['waterIntake'] as num?)?.toDouble() ?? 0.0,
      fatRate: (json['fatRate'] as num?)?.toInt() ?? 0,
      muscleMass: (json['muscleMass'] as num?)?.toDouble() ?? 0.0,
      totalDuration: (json['totalDuration'] as num?)?.toInt() ?? 0,
      totalMoves: (json['totalMoves'] as num?)?.toInt() ?? 0,
      completionRate: (json['completionRate'] as num?)?.toInt() ?? 0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      initialWeight: (json['initialWeight'] as num?)?.toDouble() ?? 0.0,
      targetWeight: (json['targetWeight'] as num?)?.toDouble() ?? 70.0,
      initialFatRate: (json['initialFatRate'] as num?)?.toInt() ?? 24,
      initialMuscleMass: (json['initialMuscleMass'] as num?)?.toDouble() ?? 30.0,
      sleepDuration: json['sleepDuration']?.toString() ?? '0 Saat',
      recentExercises: recentList,
      completedDays: completedDays,
      completedAtDates: (json['completedAtDates'] as List? ?? []).map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalActivity': totalActivity,
      'totalKcal': totalKcal,
      'weightLost': weightLost,
      'streak': streak,
      'bpm': bpm,
      'steps': steps,
      'waterIntake': waterIntake,
      'fatRate': fatRate,
      'muscleMass': muscleMass,
      'totalDuration': totalDuration,
      'totalMoves': totalMoves,
      'completionRate': completionRate,
      'weight': weight,
      'initialWeight': initialWeight,
      'targetWeight': targetWeight,
      'initialFatRate': initialFatRate,
      'initialMuscleMass': initialMuscleMass,
      'sleepDuration': sleepDuration,
      'recentExercises': recentExercises.map((e) => e.toJson()).toList(),
      'completedDays': completedDays,
      'completedAtDates': completedAtDates,
    };
  }
}
