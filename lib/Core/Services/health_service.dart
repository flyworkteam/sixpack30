import 'package:health/health.dart';
import '../Network/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HealthService {
  static final HealthService _instance = HealthService._internal();
  factory HealthService() => _instance;
  HealthService._internal();

  final Health _health = Health();
  final ApiService _apiService = ApiService();

  final List<HealthDataType> _types = [
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.SLEEP_SESSION,
  ];

  Future<bool> requestPermissions() async {
    try {
      bool? hasPermissions = await _health.hasPermissions(_types);
      if (hasPermissions != true) {
        return await _health.requestAuthorization(_types);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> syncHealthData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final bool hasPermission = await requestPermissions();
    if (!hasPermission) return;

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    try {
      List<HealthDataPoint> dataPoints = await _health.getHealthDataFromTypes(
        types: _types,
        startTime: todayStart,
        endTime: now,
      );

      int steps = 0;
      double calories = 0;
      int sleepMinutes = 0;

      for (var point in dataPoints) {
        if (point.type == HealthDataType.STEPS) {
          steps += int.tryParse(point.value.toString()) ?? 0;
        } else if (point.type == HealthDataType.ACTIVE_ENERGY_BURNED) {
          calories += double.tryParse(point.value.toString()) ?? 0;
        } else if (point.type == HealthDataType.SLEEP_SESSION) {
          final duration = point.dateTo.difference(point.dateFrom).inMinutes;
          sleepMinutes += duration;
        }
      }

      final token = await user.getIdToken();
      if (token != null) {
        await _apiService.syncHealthData(token, {
          'steps': steps,
          'calories': calories,
          'sleepMinutes': sleepMinutes,
        });
      }
    } catch (e) {
    }
  }
}
