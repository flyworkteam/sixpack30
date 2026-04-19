class WorkoutModel {
  final int id;
  final String title;
  final String? description;
  final int duration;
  final String? imagePath;
  final String? difficulty;
  final bool isPremium;

  final int? exerciseCount;
  final int? calories;

  WorkoutModel({
    required this.id,
    required this.title,
    this.description,
    required this.duration,
    this.imagePath,
    this.difficulty,
    required this.isPremium,
    this.exerciseCount,
    this.calories,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    String? rawPath = json['imagePath'];
    String? finalPath = rawPath;
    if (rawPath != null && !rawPath.startsWith('http')) {
      finalPath = 'https://sixpack30.b-cdn.net/exercises/${rawPath.split('/').last}';
    }

    return WorkoutModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      duration: json['duration'] ?? 600,
      imagePath: finalPath,
      difficulty: json['difficulty'],
      isPremium: json['isPremium'] ?? false,
      exerciseCount: json['exerciseCount'],
      calories: json['calories'],
    );
  }

  int get durationMinutes => (duration / 60).toInt();
}
