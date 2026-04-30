
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Network/api_service.dart';
import '../../Riverpod/Controllers/locale_provider.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final apiService = ApiService();
  final locale = ref.watch(localeProvider);
  apiService.setLanguage(locale.languageCode);
  return apiService;
});
