import 'package:flutter/material.dart';
import 'package:six_pack_30/View/InitialView/initial_view.dart';
import 'package:six_pack_30/View/SplashView/splash_view.dart';
import 'package:six_pack_30/View/OnboardView/onboard_view.dart';
import 'package:six_pack_30/View/LoginView/login_view.dart';
import 'package:six_pack_30/View/QuestionsView/questions_view.dart';
import 'package:six_pack_30/View/HomeView/home_view.dart';
import 'package:six_pack_30/View/ProgressView/progress_view.dart';
class AppRoutes {
  static const String initial = "/";
  static const String splash = "/splash";
  static const String onboard = "/onboard";
  static const String login = "/login";
  static const String questions = "/questions";
  static const String home = "/home";
  static const String progress = "/progress";
  static Map<String, Widget Function(BuildContext)> routes = {
    initial: (_) => const InitialView(),
    splash: (_) => const SplashView(),
    onboard: (_) => const OnboardView(),
    login: (_) => const LoginView(),
    questions: (_) => const QuestionsView(),
    home: (_) => const HomeView(),
    progress: (_) => const ProgressView(),
  };
}
