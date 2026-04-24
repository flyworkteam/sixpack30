class ExerciseInfo {
  final String name;
  final String sets;
  final String rest;
  final String imagePath;
  final String videoPath;

  ExerciseInfo({
    required this.name,
    required this.sets,
    required this.rest,
    required this.imagePath,
    required this.videoPath,
  });

  String getImagePath(String gender) {
    final String normalized = (gender == 'female' || gender == 'woman') ? 'woman' : 'man';
    return imagePath.replaceAll('{gender}', normalized);
  }

  String getVideoPath(String gender) {
    if (videoPath.startsWith('http')) {
      final String normalized = (gender == 'female' || gender == 'woman') ? 'woman' : 'man';
      return videoPath.replaceAll('{gender}', normalized);
    }
    return videoPath;
  }
}

class WorkoutData {
  final int day;
  final String title;
  final List<ExerciseInfo> exercises;

  WorkoutData({
    required this.day,
    required this.title,
    required this.exercises,
  });
}

class StaticWorkoutData {
  static List<ExerciseInfo> _generateCdnExercises(List<Map<String, String>> data) {
    return data.map((ex) {
      final String cleanName = ex['name']!.split('(')[0].trim();
      final String encodedName = Uri.encodeComponent(cleanName);
      
      final mp4List = [
        'Plank Hip Dip', 'Sit-Up', 'Pulse Crunch', 'Russian Twist', 
        'Scissor Kicks', 'Seated Twist', 'Standing Oblique Crunch', 
        'Standing Side Crunch', 'Mountain Climber', 'Leg Raise'
      ];
      final String ext = mp4List.contains(cleanName) ? 'mp4' : 'mov';
      
      final localExercisesLower = [
        'v-up', 'double crunch', 'flutter kicks', 'scissor kicks', 
        'russian twist', 'oblique v-up', 'side plank', 'high knees',
        'crunch', 'heel touch', 'plank', 'leg raise', 'sit-up',
        'bent knee leg raise', 'bicycle crunch', 'cross crunch', 'dead bug',
        'forearm plank', 'high plank knee drive', 'jackknife', 'lying knee raise',
        'lying leg hold', 'mountain climber', 'plank hip dip', 'plank shoulder tap',
        'pulse crunch', 'reach up crunch', 'reverse crunch', 'seated twist',
        'side crunch', 'side plank reach', 'standing oblique crunch',
        'standing side crunch', 'toe touch crunch'
      ];

      if (localExercisesLower.contains(cleanName.toLowerCase())) {
        String assetName = cleanName;
        
        if (cleanName.toLowerCase() == 'dead bug') assetName = 'Dead Bug';
        if (cleanName.toLowerCase() == 'v-up') assetName = 'V_Up';
        
        
        String videoAssetName = assetName.replaceAll(' ', '_');
        if (cleanName.toLowerCase() == 'dead bug') videoAssetName = 'Dead_bug';
        if (cleanName.toLowerCase() == 'v-up') videoAssetName = 'V_Up';

        return ExerciseInfo(
          name: ex['name']!,
          sets: ex['sets']!,
          rest: ex['rest']!,
          imagePath: 'assets/images/$assetName {gender}.png',
          videoPath: 'assets/videos/$videoAssetName.$ext',
        );
      }

      return ExerciseInfo(
        name: ex['name']!,
        sets: ex['sets']!,
        rest: ex['rest']!,
        imagePath: 'https://sixpack30.b-cdn.net/images/$encodedName%20{gender}.png',
        videoPath: 'https://sixpack30.b-cdn.net/videos/$encodedName%20{gender}.mp4',
      );
    }).toList();
  }

  static final Map<int, WorkoutData> _allWorkouts = {
    1: WorkoutData(
      day: 1,
      title: 'Aktivasyon',
      exercises: _generateCdnExercises([
        {"name": "Crunch", "sets": "3 Set × 20 Tekrar", "rest": "20–30 sn"},
        {"name": "Toe Touch Crunch", "sets": "3 Set × 15 Tekrar", "rest": "20–30 sn"},
        {"name": "Bent Knee Leg Raise", "sets": "3 Set × 15 Tekrar", "rest": "30 sn"},
        {"name": "Lying Knee Raise", "sets": "3 Set × 15 Tekrar", "rest": "30 sn"},
        {"name": "Heel Touch", "sets": "3 Set × 20 Tekrar (toplam)", "rest": "20–30 sn"},
        {"name": "Standing Side Crunch", "sets": "3 Set × 20 Tekrar (sağ + sol)", "rest": "20–30 sn"},
        {"name": "Forearm Plank", "sets": "3 Set × 45 Saniye", "rest": "30 sn"},
        {"name": "Mountain Climber (yavaş tempo)", "sets": "3 Set × 45 Saniye", "rest": "30 sn"},
      ]),
    ),
    2: WorkoutData(
      day: 2,
      title: 'Kontrol',
      exercises: _generateCdnExercises([
        {"name": "Sit-Up", "sets": "3 Set × 15 Tekrar", "rest": "30 sn"},
        {"name": "Cross Crunch", "sets": "3 Set × 20 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Leg Raise", "sets": "3 Set × 12 Tekrar", "rest": "30 sn"},
        {"name": "Reverse Crunch", "sets": "3 Set × 15 Tekrar", "rest": "30 sn"},
        {"name": "Bicycle Crunch", "sets": "3 Set × 20 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Side Crunch", "sets": "3 Set × 15 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Plank Shoulder Tap", "sets": "3 Set × 20 Tekrar (toplam)", "rest": "30 sn"},
        {"name": "Dead Bug", "sets": "3 Set × 20 Tekrar (toplam)", "rest": "30 sn"},
      ]),
    ),
    3: WorkoutData(
      day: 3,
      title: 'Yakıcı',
      exercises: _generateCdnExercises([
        {"name": "V-Up", "sets": "3 Set × 12 Tekrar", "rest": "40 sn"},
        {"name": "Double Crunch", "sets": "3 Set × 15 Tekrar", "rest": "30 sn"},
        {"name": "Flutter Kicks", "sets": "3 Set × 40 Saniye", "rest": "30 sn"},
        {"name": "Scissor Kicks", "sets": "3 Set × 40 Saniye", "rest": "30 sn"},
        {"name": "Russian Twist", "sets": "3 Set × 20 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Oblique V-Up", "sets": "3 Set × 12 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Side Plank", "sets": "3 Set × 45 Saniye (her iki taraf)", "rest": "30 sn"},
        {"name": "High Knees", "sets": "3 Set × 40 Saniye", "rest": "30 sn"},
      ]),
    ),
    4: WorkoutData(
      day: 4,
      title: 'Aktif Dinlenme',
      exercises: [],
    ),
    5: WorkoutData(
      day: 5,
      title: 'Güçlendirme',
      exercises: _generateCdnExercises([
        {"name": "Crunch", "sets": "3 Set × 25 Tekrar", "rest": "25 sn"},
        {"name": "Reach Up Crunch", "sets": "3 Set × 20 Tekrar", "rest": "25 sn"},
        {"name": "Leg Raise (düz bacak)", "sets": "3 Set × 15 Tekrar", "rest": "30 sn"},
        {"name": "Reverse Crunch", "sets": "3 Set × 18 Tekrar", "rest": "30 sn"},
        {"name": "Heel Touch", "sets": "3 Set × 24 Tekrar (toplam)", "rest": "25 sn"},
        {"name": "Standing Side Crunch", "sets": "3 Set × 24 Tekrar (sağ + sol)", "rest": "25 sn"},
        {"name": "Forearm Plank", "sets": "3 Set × 40 Saniye", "rest": "30 sn"},
        {"name": "Mountain Climber (orta tempo)", "sets": "3 Set × 40 Saniye", "rest": "30 sn"},
      ]),
    ),
    6: WorkoutData(
      day: 6,
      title: 'Kontrol + Oblik',
      exercises: _generateCdnExercises([
        {"name": "Sit-Up", "sets": "3 Set × 18 Tekrar", "rest": "30 sn"},
        {"name": "Cross Crunch", "sets": "3 Set × 24 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Bent Knee Leg Raise", "sets": "3 Set × 20 Tekrar", "rest": "30 sn"},
        {"name": "Lying Knee Raise", "sets": "3 Set × 20 Tekrar", "rest": "30 sn"},
        {"name": "Bicycle Crunch", "sets": "3 Set × 24 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Side Crunch", "sets": "3 Set × 18 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Plank Shoulder Tap", "sets": "3 Set × 24 Tekrar (toplam)", "rest": "30 sn"},
        {"name": "Dead Bug", "sets": "3 Set × 24 Tekrar (toplam)", "rest": "30 sn"},
      ]),
    ),
    7: WorkoutData(
      day: 7,
      title: 'Yakıcı (Hafta Finali)',
      exercises: _generateCdnExercises([
        {"name": "V-Up", "sets": "3 Set × 15 Tekrar", "rest": "40 sn"},
        {"name": "Double Crunch", "sets": "3 Set × 18 Tekrar", "rest": "30 sn"},
        {"name": "Flutter Kicks", "sets": "3 Set × 45 Saniye", "rest": "30 sn"},
        {"name": "Scissor Kicks", "sets": "3 Set × 45 Saniye", "rest": "30 sn"},
        {"name": "Russian Twist", "sets": "3 Set × 30 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Oblique V-Up", "sets": "3 Set × 15 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Side Plank", "sets": "3 Set × 45 Saniye (her iki taraf)", "rest": "30 sn"},
        {"name": "High Knees", "sets": "3 Set × 45 Saniye", "rest": "30 sn"},
      ]),
    ),
    8: WorkoutData(
      day: 8,
      title: 'Aktif Dinlenme',
      exercises: [],
    ),
    9: WorkoutData(
      day: 9,
      title: 'Core Güçlendirme',
      exercises: _generateCdnExercises([
        {"name": "Crunch", "sets": "3 Set × 30 Tekrar", "rest": "25 sn"},
        {"name": "Toe Touch Crunch", "sets": "3 Set × 20 Tekrar", "rest": "25 sn"},
        {"name": "Leg Raise (düz bacak)", "sets": "3 Set × 18 Tekrar", "rest": "30 sn"},
        {"name": "Reverse Crunch", "sets": "3 Set × 20 Tekrar", "rest": "30 sn"},
        {"name": "Heel Touch", "sets": "3 Set × 30 Tekrar (toplam)", "rest": "25 sn"},
        {"name": "Standing Side Crunch", "sets": "3 Set × 30 Tekrar (sağ + sol)", "rest": "25 sn"},
        {"name": "Forearm Plank", "sets": "3 Set × 45 Saniye", "rest": "30 sn"},
        {"name": "Mountain Climber (orta tempo)", "sets": "3 Set × 45 Saniye", "rest": "30 sn"},
      ]),
    ),
    10: WorkoutData(
      day: 10,
      title: 'Kontrol + Oblik Odak',
      exercises: _generateCdnExercises([
        {"name": "Sit-Up", "sets": "3 Set × 20 Tekrar", "rest": "30 sn"},
        {"name": "Cross Crunch", "sets": "3 Set × 30 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Bent Knee Leg Raise", "sets": "3 Set × 25 Tekrar", "rest": "30 sn"},
        {"name": "Lying Knee Raise", "sets": "3 Set × 25 Tekrar", "rest": "30 sn"},
        {"name": "Bicycle Crunch", "sets": "3 Set × 30 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Side Crunch", "sets": "3 Set × 20 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Plank Shoulder Tap", "sets": "3 Set × 30 Tekrar (toplam)", "rest": "30 sn"},
        {"name": "Dead Bug", "sets": "3 Set × 30 Tekrar (toplam)", "rest": "30 sn"},
      ]),
    ),
    11: WorkoutData(
      day: 11,
      title: 'Yakıcı + Dayanıklılık',
      exercises: _generateCdnExercises([
        {"name": "V-Up", "sets": "3 Set × 18 Tekrar", "rest": "40 sn"},
        {"name": "Double Crunch", "sets": "3 Set × 20 Tekrar", "rest": "30 sn"},
        {"name": "Flutter Kicks", "sets": "3 Set × 60 Saniye", "rest": "30 sn"},
        {"name": "Scissor Kicks", "sets": "3 Set × 60 Saniye", "rest": "30 sn"},
        {"name": "Russian Twist", "sets": "3 Set × 40 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Oblique V-Up", "sets": "3 Set × 18 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Side Plank", "sets": "3 Set × 35–40 Saniye (her iki taraf)", "rest": "30 sn"},
        {"name": "High Knees", "sets": "3 Set × 60 Saniye", "rest": "30 sn"},
      ]),
    ),
    12: WorkoutData(
      day: 12,
      title: 'Aktif Dinlenme',
      exercises: [],
    ),
    13: WorkoutData(
      day: 13,
      title: 'Core Güç + Kontrol',
      exercises: _generateCdnExercises([
        {"name": "Crunch", "sets": "3 Set × 35 Tekrar", "rest": "25 sn"},
        {"name": "Reach Up Crunch", "sets": "3 Set × 25 Tekrar", "rest": "25 sn"},
        {"name": "Leg Raise (düz bacak)", "sets": "3 Set × 20 Tekrar", "rest": "30 sn"},
        {"name": "Lying Leg Hold", "sets": "3 Set × 25 Saniye", "rest": "30 sn"},
        {"name": "Heel Touch", "sets": "3 Set × 35 Tekrar (toplam)", "rest": "25 sn"},
        {"name": "Standing Oblique Crunch", "sets": "3 Set × 30 Tekrar (sağ + sol)", "rest": "25 sn"},
        {"name": "Plank", "sets": "3 Set × 60 Saniye", "rest": "40 sn"},
        {"name": "Mountain Climber (orta tempo)", "sets": "3 Set × 60 Saniye", "rest": "30 sn"},
      ]),
    ),
    14: WorkoutData(
      day: 14,
      title: 'Alt Karın + Oblik Baskı',
      exercises: _generateCdnExercises([
        {"name": "Sit-Up", "sets": "3 Set × 22 Tekrar", "rest": "30 sn"},
        {"name": "Pulse Crunch", "sets": "3 Set × 25 Tekrar", "rest": "25 sn"},
        {"name": "Reverse Crunch", "sets": "3 Set × 22 Tekrar", "rest": "30 sn"},
        {"name": "Scissor Kicks", "sets": "3 Set × 60 Saniye", "rest": "30 sn"},
        {"name": "Russian Twist", "sets": "3 Set × 45 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Side Crunch", "sets": "3 Set × 25 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Plank Hip Dip", "sets": "3 Set × 30 Tekrar (toplam)", "rest": "30 sn"},
        {"name": "High Plank Knee Drive", "sets": "3 Set × 45 Saniye", "rest": "30 sn"},
      ]),
    ),
    15: WorkoutData(
      day: 15,
      title: 'Yakıcı (Hafta Finali)',
      exercises: _generateCdnExercises([
        {"name": "V-Up", "sets": "3 Set × 20 Tekrar", "rest": "40 sn"},
        {"name": "Double Crunch", "sets": "3 Set × 22 Tekrar", "rest": "30 sn"},
        {"name": "Flutter Kicks", "sets": "3 Set × 70 Saniye", "rest": "30 sn"},
        {"name": "Jackknife", "sets": "3 Set × 18 Tekrar", "rest": "30 sn"},
        {"name": "Oblique V-Up", "sets": "3 Set × 20 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Seated Twist", "sets": "3 Set × 40 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Side Plank Reach", "sets": "3 Set × 35 Saniye (her iki taraf)", "rest": "30 sn"},
        {"name": "High Knees", "sets": "3 Set × 70 Saniye", "rest": "30 sn"},
      ]),
    ),
    16: WorkoutData(
      day: 16,
      title: 'Aktif Dinlenme',
      exercises: [],
    ),
    17: WorkoutData(
      day: 17,
      title: 'Core Dayanıklılık',
      exercises: _generateCdnExercises([
        {"name": "Crunch", "sets": "4 Set × 35 Tekrar", "rest": "25 sn"},
        {"name": "Reach Up Crunch", "sets": "3 Set × 30 Tekrar", "rest": "25 sn"},
        {"name": "Leg Raise (düz bacak)", "sets": "3 Set × 22 Tekrar", "rest": "30 sn"},
        {"name": "Lying Knee Raise", "sets": "3 Set × 30 Tekrar", "rest": "30 sn"},
        {"name": "Heel Touch", "sets": "3 Set × 40 Tekrar (toplam)", "rest": "25 sn"},
        {"name": "Standing Side Crunch", "sets": "3 Set × 35 Tekrar (sağ + sol)", "rest": "25 sn"},
        {"name": "Forearm Plank", "sets": "3 Set × 75 Saniye", "rest": "40 sn"},
        {"name": "Mountain Climber (orta–hızlı tempo)", "sets": "3 Set × 75 Saniye", "rest": "30 sn"},
      ]),
    ),
    18: WorkoutData(
      day: 18,
      title: 'Alt Karın + Oblik Baskı',
      exercises: _generateCdnExercises([
        {"name": "Sit-Up", "sets": "4 Set × 25 Tekrar", "rest": "30 sn"},
        {"name": "Pulse Crunch", "sets": "3 Set × 30 Tekrar", "rest": "25 sn"},
        {"name": "Reverse Crunch", "sets": "3 Set × 25 Tekrar", "rest": "30 sn"},
        {"name": "Scissor Kicks", "sets": "3 Set × 75 Saniye", "rest": "30 sn"},
        {"name": "Russian Twist", "sets": "3 Set × 50 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Side Crunch", "sets": "3 Set × 30 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Plank Hip Dip", "sets": "3 Set × 40 Tekrar (toplam)", "rest": "30 sn"},
        {"name": "High Plank Knee Drive", "sets": "3 Set × 60 Saniye", "rest": "30 sn"},
      ]),
    ),
    19: WorkoutData(
      day: 19,
      title: 'Yakıcı Kontrol Günü',
      exercises: _generateCdnExercises([
        {"name": "V-Up", "sets": "4 Set × 22 Tekrar", "rest": "40 sn"},
        {"name": "Double Crunch", "sets": "3 Set × 25 Tekrar", "rest": "30 sn"},
        {"name": "Flutter Kicks", "sets": "3 Set × 80 Saniye", "rest": "30 sn"},
        {"name": "Jackknife", "sets": "3 Set × 22 Tekrar", "rest": "30 sn"},
        {"name": "Oblique V-Up", "sets": "3 Set × 25 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Seated Twist", "sets": "3 Set × 50 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Side Plank Reach", "sets": "3 Set × 45 Saniye (her iki taraf)", "rest": "30 sn"},
        {"name": "High Knees", "sets": "3 Set × 80 Saniye", "rest": "30 sn"},
      ]),
    ),
    20: WorkoutData(
      day: 20,
      title: 'Aktif Dinlenme',
      exercises: [],
    ),
    21: WorkoutData(
      day: 21,
      title: 'Core Güç + Süre',
      exercises: _generateCdnExercises([
        {"name": "Crunch", "sets": "4 Set × 40 Tekrar", "rest": "20–25 sn"},
        {"name": "Reach Up Crunch", "sets": "3 Set × 35 Tekrar", "rest": "25 sn"},
        {"name": "Leg Raise (düz bacak)", "sets": "3 Set × 25 Tekrar", "rest": "30 sn"},
        {"name": "Lying Leg Hold", "sets": "3 Set × 35 Saniye", "rest": "30 sn"},
        {"name": "Heel Touch", "sets": "3 Set × 45 Tekrar (toplam)", "rest": "25 sn"},
        {"name": "Standing Side Crunch", "sets": "3 Set × 40 Tekrar (sağ + sol)", "rest": "25 sn"},
        {"name": "Forearm Plank", "sets": "3 Set × 90 Saniye", "rest": "40 sn"},
        {"name": "Mountain Climber (orta–hızlı tempo)", "sets": "3 Set × 90 Saniye", "rest": "30 sn"},
      ]),
    ),
    22: WorkoutData(
      day: 22,
      title: 'Alt Karın & Oblik Netleştirme',
      exercises: _generateCdnExercises([
        {"name": "Sit-Up", "sets": "4 Set × 30 Tekrar", "rest": "30 sn"},
        {"name": "Pulse Crunch", "sets": "3 Set × 35 Tekrar", "rest": "25 sn"},
        {"name": "Reverse Crunch", "sets": "3 Set × 30 Tekrar", "rest": "30 sn"},
        {"name": "Scissor Kicks", "sets": "3 Set × 90 Saniye", "rest": "30 sn"},
        {"name": "Russian Twist", "sets": "3 Set × 60 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Side Crunch", "sets": "3 Set × 35 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Plank Hip Dip", "sets": "3 Set × 50 Tekrar (toplam)", "rest": "30 sn"},
        {"name": "High Plank Knee Drive", "sets": "3 Set × 75 Saniye", "rest": "30 sn"},
      ]),
    ),
    23: WorkoutData(
      day: 23,
      title: 'Yakıcı Dayanıklılık (Final Öncesi)',
      exercises: _generateCdnExercises([
        {"name": "V-Up", "sets": "4 Set × 25 Tekrar", "rest": "40 sn"},
        {"name": "Double Crunch", "sets": "3 Set × 30 Tekrar", "rest": "30 sn"},
        {"name": "Flutter Kicks", "sets": "3 Set × 90 Saniye", "rest": "30 sn"},
        {"name": "Jackknife", "sets": "3 Set × 25 Tekrar", "rest": "30 sn"},
        {"name": "Oblique V-Up", "sets": "3 Set × 30 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Seated Twist", "sets": "3 Set × 60 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Side Plank Reach", "sets": "3 Set × 55 Saniye (her iki taraf)", "rest": "30 sn"},
        {"name": "High Knees", "sets": "3 Set × 90 Saniye", "rest": "30 sn"},
      ]),
    ),
    24: WorkoutData(
      day: 24,
      title: 'Aktif Dinlenme',
      exercises: [],
    ),
    25: WorkoutData(
      day: 25,
      title: 'Core Dayanıklılık Zirvesi',
      exercises: _generateCdnExercises([
        {"name": "Crunch", "sets": "4 Set × 45 Tekrar", "rest": "20–25 sn"},
        {"name": "Reach Up Crunch", "sets": "3 Set × 40 Tekrar", "rest": "25 sn"},
        {"name": "Leg Raise (düz bacak)", "sets": "3 Set × 28 Tekrar", "rest": "30 sn"},
        {"name": "Lying Leg Hold", "sets": "3 Set × 45 Saniye", "rest": "30 sn"},
        {"name": "Heel Touch", "sets": "3 Set × 50 Tekrar (toplam)", "rest": "25 sn"},
        {"name": "Standing Side Crunch", "sets": "3 Set × 45 Tekrar (sağ + sol)", "rest": "25 sn"},
        {"name": "Forearm Plank", "sets": "3 Set × 100 Saniye", "rest": "40 sn"},
        {"name": "Mountain Climber (orta–hızlı tempo)", "sets": "3 Set × 100 Saniye", "rest": "30 sn"},
      ]),
    ),
    26: WorkoutData(
      day: 26,
      title: 'Alt Karın + Oblik Maksimum Hacim',
      exercises: _generateCdnExercises([
        {"name": "Sit-Up", "sets": "4 Set × 35 Tekrar", "rest": "30 sn"},
        {"name": "Pulse Crunch", "sets": "3 Set × 40 Tekrar", "rest": "25 sn"},
        {"name": "Reverse Crunch", "sets": "3 Set × 35 Tekrar", "rest": "30 sn"},
        {"name": "Scissor Kicks", "sets": "3 Set × 100 Saniye", "rest": "30 sn"},
        {"name": "Russian Twist", "sets": "3 Set × 70 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Side Crunch", "sets": "3 Set × 40 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Plank Hip Dip", "sets": "3 Set × 60 Tekrar (toplam)", "rest": "30 sn"},
        {"name": "High Plank Knee Drive", "sets": "3 Set × 90 Saniye", "rest": "30 sn"},
      ]),
    ),
    27: WorkoutData(
      day: 27,
      title: 'Final Öncesi Yakıcı Kombin',
      exercises: _generateCdnExercises([
        {"name": "V-Up", "sets": "4 Set × 30 Tekrar", "rest": "40 sn"},
        {"name": "Double Crunch", "sets": "3 Set × 35 Tekrar", "rest": "30 sn"},
        {"name": "Flutter Kicks", "sets": "3 Set × 100 Saniye", "rest": "30 sn"},
        {"name": "Jackknife", "sets": "3 Set × 30 Tekrar", "rest": "30 sn"},
        {"name": "Oblique V-Up", "sets": "3 Set × 35 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Seated Twist", "sets": "3 Set × 70 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Side Plank Reach", "sets": "3 Set × 65 Saniye (her iki taraf)", "rest": "30 sn"},
        {"name": "High Knees", "sets": "3 Set × 100 Saniye", "rest": "30 sn"},
      ]),
    ),
    28: WorkoutData(
      day: 28,
      title: 'Aktif Dinlenme',
      exercises: [],
    ),
    29: WorkoutData(
      day: 29,
      title: 'Final Güç Testi',
      exercises: _generateCdnExercises([
        {"name": "Crunch", "sets": "4 Set × 50 Tekrar", "rest": "20–25 sn"},
        {"name": "Reach Up Crunch", "sets": "3 Set × 45 Tekrar", "rest": "25 sn"},
        {"name": "Leg Raise (düz bacak)", "sets": "3 Set × 30 Tekrar", "rest": "30 sn"},
        {"name": "Lying Leg Hold", "sets": "3 Set × 60 Saniye", "rest": "30 sn"},
        {"name": "Heel Touch", "sets": "3 Set × 60 Tekrar (toplam)", "rest": "25 sn"},
        {"name": "Standing Side Crunch", "sets": "3 Set × 50 Tekrar (sağ + sol)", "rest": "25 sn"},
        {"name": "Forearm Plank", "sets": "3 Set × 120 Saniye", "rest": "45 sn"},
        {"name": "Mountain Climber (orta–hızlı tempo)", "sets": "3 Set × 120 Saniye", "rest": "30 sn"},
      ]),
    ),
    30: WorkoutData(
      day: 30,
      title: 'Final Burn & Kapanış',
      exercises: _generateCdnExercises([
        {"name": "V-Up", "sets": "4 Set × 35 Tekrar", "rest": "40 sn"},
        {"name": "Double Crunch", "sets": "3 Set × 40 Tekrar", "rest": "30 sn"},
        {"name": "Flutter Kicks", "sets": "3 Set × 120 Saniye", "rest": "30 sn"},
        {"name": "Jackknife", "sets": "3 Set × 35 Tekrar", "rest": "30 sn"},
        {"name": "Oblique V-Up", "sets": "3 Set × 40 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Seated Twist", "sets": "3 Set × 80 Tekrar (sağ + sol)", "rest": "30 sn"},
        {"name": "Side Plank Reach", "sets": "3 Set × 75 Saniye (her iki taraf)", "rest": "30 sn"},
        {"name": "High Knees", "sets": "3 Set × 120 Saniye", "rest": "30 sn"},
      ]),
    ),
  };

  static WorkoutData getWorkoutForDay(int day) {
    return _allWorkouts[day] ?? _allWorkouts[1]!;
  }
}
