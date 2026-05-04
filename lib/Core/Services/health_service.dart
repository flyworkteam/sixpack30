import 'package:health/health.dart' as health_pkg;
import 'package:health/health.dart' show HealthDataType, HealthDataPoint, Health;
import 'package:flutter/foundation.dart';
import '../Network/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HealthService {
  static final HealthService _instance = HealthService._internal();
  factory HealthService() => _instance;
  HealthService._internal();

  final Health _health = Health();
  final ApiService _apiService = ApiService();

  
  final List<HealthDataType> types = [
    HealthDataType.HEART_RATE,
    HealthDataType.SLEEP_IN_BED,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.STEPS,
  ];

  Future<bool> requestPermissions() async {
    try {
      bool requested = await _health.requestAuthorization(types);
      return requested;
    } catch (e) {
      debugPrint('Health Auth Error: $e');
      return false;
    }
  }

  Future<void> syncHealthData() async {
    try {
<<<<<<< HEAD
      // iOS returns null for hasPermissions because it doesn't allow checking read permissions.
      // Therefore we must default to true if it returns null.
      final bool hasPermission = await _health.hasPermissions(types) ?? true;
=======
      final bool hasPermission = await _health.hasPermissions(types) ?? false;
>>>>>>> d5f7518ac4c379ce62ddfcd109a71d76d3c9ac97
      if (!hasPermission) return;

      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      
      List<HealthDataPoint> healthData = await _health.getHealthDataFromTypes(
          startTime: yesterday, endTime: now, types: types);

      
      double heartRate = 0;
      double sleepMinutes = 0;
      int steps = 0;

      for (var point in healthData) {
        if (point.type == HealthDataType.HEART_RATE) {
          final val = double.tryParse(point.value.toString()) ?? 0;
          if (val > 0) heartRate = val;
<<<<<<< HEAD
        } else if (point.type == HealthDataType.SLEEP_ASLEEP) {
          // Sadece SLEEP_ASLEEP toplanmalı, IN_BED ile toplanırsa çifte sayım olur
=======
        } else if (point.type == HealthDataType.SLEEP_IN_BED || point.type == HealthDataType.SLEEP_ASLEEP) {
>>>>>>> d5f7518ac4c379ce62ddfcd109a71d76d3c9ac97
          sleepMinutes += double.tryParse(point.value.toString()) ?? 0;
        } else if (point.type == HealthDataType.STEPS) {
          steps += int.tryParse(point.value.toString()) ?? 0;
        }
      }

      
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final token = await user.getIdToken();
        if (token != null) {
          await _apiService.syncHealthData(token, {
            'heartRate': heartRate,
            'sleepMinutes': sleepMinutes,
            'steps': steps,
            'syncDate': now.toIso8601String(),
          });
        }
      }
    } catch (e) {
      debugPrint('Health Sync Error: $e');
    }
  }
}
