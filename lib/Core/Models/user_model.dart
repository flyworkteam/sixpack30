class UserModel {
  final int id;
  final String firebaseUid;
  final String? name;
  final String? email;
  final bool isPremium;
  final bool notificationsEnabled;
  final bool healthConnected;
  final String? photoUrl;
  final QuestionnaireModel? questionnaire;

  UserModel({
    required this.id,
    required this.firebaseUid,
    this.email,
    this.name,
    this.isPremium = false,
    this.notificationsEnabled = true,
    this.healthConnected = false,
    this.photoUrl,
    this.questionnaire,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final List? qList = json['questionnaires'];
    QuestionnaireModel? q;
    if (qList != null && qList.isNotEmpty) {
      q = QuestionnaireModel.fromJson(qList.first);
    }

    return UserModel(
      id: json['id'],
      firebaseUid: json['firebaseUid'],
      email: json['email'],
      name: json['name'],
      isPremium: json['isPremium'] ?? false,
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      healthConnected: json['healthConnected'] ?? false,
      photoUrl: json['photoUrl'],
      questionnaire: q,
    );
  }
}

class QuestionnaireModel {
  final int id;
  final double? weight;
  final double? height;
  final String? goal;
  final String? gender;
  final int? birthYear;
  final double? targetWeight;
  final double? bodyType;
  final double? targetBodyType;
  final int? speed;
  final int? experience;
  final int? trainingType;
  final int? activityLevel;
  final String? trainingDays;
  final int? trainingDuration;

  QuestionnaireModel({
    required this.id,
    this.weight,
    this.height,
    this.goal,
    this.gender,
    this.birthYear,
    this.targetWeight,
    this.bodyType,
    this.targetBodyType,
    this.speed,
    this.experience,
    this.trainingType,
    this.activityLevel,
    this.trainingDays,
    this.trainingDuration,
  });

  factory QuestionnaireModel.fromJson(Map<String, dynamic> json) {
    return QuestionnaireModel(
      id: json['id'],
      weight: (json['weight'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      goal: json['goal'],
      gender: json['gender'],
      birthYear: json['birthYear'],
      targetWeight: (json['targetWeight'] as num?)?.toDouble(),
      bodyType: (json['bodyType'] as num?)?.toDouble(),
      targetBodyType: (json['targetBodyType'] as num?)?.toDouble(),
      speed: json['speed'],
      experience: json['experience'],
      trainingType: json['trainingType'],
      activityLevel: json['activityLevel'],
      trainingDays: json['trainingDays'],
      trainingDuration: json['trainingDuration'],
    );
  }
}
