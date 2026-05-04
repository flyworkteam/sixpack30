import 'dart:io';

import 'package:dio/dio.dart';

class ApiService {
  late final Dio _dio;
  String _languageCode = 'tr';

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Platform.isAndroid
            ? 'https://sixpack30.fly-work.com/api'
            : 'https://sixpack30.fly-work.com/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
        headers: {'Accept-Language': 'tr'},
      ),
    );
  }

  void setLanguage(String code) {
    _languageCode = code;
    _dio.options.headers['Accept-Language'] = code;
  }

  Future<Map<String, dynamic>?> syncUserWithBackend(
    String firebaseIdToken,
  ) async {
    try {
      final response = await _dio.post(
        '/user/auth',
        options: Options(
          headers: {
            'Authorization': 'Bearer $firebaseIdToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      if (e is DioException) {
        print('>>> SYNC USER AUTH ERROR: ${e.response?.statusCode} - ${e.response?.data}');
      }
      return null;
    }
  }

  Future<bool> updateProfile(
    String firebaseIdToken,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.put(
        '/user/profile',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $firebaseIdToken',
            'Content-Type': 'application/json',
          },
        ),
      );
      print('>>> UPDATE PROFILE RESPONSE: ${response.statusCode} - ${response.data}');
      return response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;
    } catch (e) {
      if (e is DioException) {
        print('>>> UPDATE PROFILE DIO ERROR: ${e.response?.statusCode} - ${e.response?.data}');
        print('>>> ERROR MESSAGE: ${e.message}');
      } else {
        print('>>> UPDATE PROFILE UNKNOWN ERROR: $e');
      }
      return false;
    }
  }

  Future<Map<String, dynamic>?> getProfile(String firebaseIdToken) async {
    try {
      final response = await _dio.get(
        '/user/profile',
        options: Options(headers: {'Authorization': 'Bearer $firebaseIdToken'}),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      if (e is DioException) {
        print('>>> GET PROFILE ERROR: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        print('>>> GET PROFILE UNKNOWN ERROR: $e');
      }
      return null;
    }
  }

  Future<Map<String, dynamic>?> getStats(String firebaseIdToken) async {
    try {
      final response = await _dio.get(
        '/user/stats',
        options: Options(headers: {'Authorization': 'Bearer $firebaseIdToken'}),
      );
      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateWaterIntake(String firebaseIdToken, double amount) async {
    try {
      final response = await _dio.put(
        '/user/stats/water',
        data: {'amount': amount},
        options: Options(
          headers: {
            'Authorization': 'Bearer $firebaseIdToken',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      if (e is DioException) {}
      return false;
    }
  }

  Future<List<dynamic>?> getNotifications(String firebaseIdToken) async {
    try {
      final response = await _dio.get(
        '/notifications',
        options: Options(headers: {'Authorization': 'Bearer $firebaseIdToken'}),
      );
      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteAllNotifications(String firebaseIdToken) async {
    try {
      final response = await _dio.delete(
        '/notifications',
        options: Options(headers: {'Authorization': 'Bearer $firebaseIdToken'}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List<dynamic>?> getWorkouts(String firebaseIdToken) async {
    try {
      final response = await _dio.get(
        '/workouts',
        options: Options(headers: {'Authorization': 'Bearer $firebaseIdToken'}),
      );
      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> syncHealthData(
    String firebaseIdToken,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.post(
        '/user/sync-health',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $firebaseIdToken',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      if (e is DioException) {}
      return false;
    }
  }

  Future<bool> completeDay(String firebaseIdToken, int dayNumber, {int? duration, num? calories}) async {
    try {
      final response = await _dio.post(
        '/training/complete-day',
        data: {
          'dayNumber': dayNumber,
          'duration': duration,
          'calories': calories,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $firebaseIdToken',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      if (e is DioException) {}
      return false;
    }
  }

  Future<bool> deleteAccount(String firebaseIdToken) async {
    try {
      final response = await _dio.delete(
        '/user/profile',
        options: Options(headers: {'Authorization': 'Bearer $firebaseIdToken'}),
      );
      return response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updatePremiumStatus(String firebaseIdToken, bool isPremium) async {
    try {
      final response = await _dio.post(
        '/user/premium',
        data: {'isPremium': isPremium},
        options: Options(
          headers: {
            'Authorization': 'Bearer $firebaseIdToken',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
