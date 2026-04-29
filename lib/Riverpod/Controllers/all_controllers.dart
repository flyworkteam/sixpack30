import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:six_pack_30/Riverpod/Controllers/OnboardViewController/onboard_view_controller.dart';
import 'package:six_pack_30/Models/onboard_view_model.dart';
class AllControllers {
  static final onboardViewController = StateNotifierProvider<OnboardViewController, OnboardViewModel>((ref) {
    return OnboardViewController(ref);
  });
}
