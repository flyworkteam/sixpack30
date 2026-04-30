import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:six_pack_30/Models/onboard_view_model.dart';
import 'package:six_pack_30/Core/Routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
class OnboardViewController extends StateNotifier<OnboardViewModel> {
  final Ref ref;
  late final PageController pageController;
  OnboardViewController(this.ref) : super(OnboardViewModel()) {
    pageController = PageController(initialPage: 0);
  }
  void onPageChanged(int index) {
    state = state.copyWith(currentIndex: index);
  }
  void pushNextIndex(BuildContext context) {
    if (state.currentIndex < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _markOnboardSeen();
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  void skip(BuildContext context) {
    _markOnboardSeen();
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  Future<void> _markOnboardSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboard', true);
  }
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
