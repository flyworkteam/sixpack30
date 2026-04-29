import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:six_pack_30/Riverpod/Controllers/auth_controller.dart';
import 'package:six_pack_30/Riverpod/Controllers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialView extends ConsumerStatefulWidget {
  const InitialView({super.key});

  @override
  ConsumerState<InitialView> createState() => _InitialViewState();
}

class _InitialViewState extends ConsumerState<InitialView> {
  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final status = await ref.read(authControllerProvider.notifier).checkInitialStatus();
      final bool isLoggedIn = status['isLoggedIn'] ?? false;
      final bool? hasCompletedSurvey = status['hasCompletedSurvey'];

      final double targetSeconds = isLoggedIn ? 1.5 : 3.0;
      final int elapsedMillis = stopwatch.elapsedMilliseconds;
      final int remainingMillis = ((targetSeconds * 1000) - elapsedMillis).toInt();

      if (remainingMillis > 0) {
        await Future.delayed(Duration(milliseconds: remainingMillis));
      }

      if (!mounted) return;

      if (isLoggedIn) {
        await ref.read(userProfileProvider.notifier).fetchProfile();

        if (hasCompletedSurvey == true) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (hasCompletedSurvey == false) {
          Navigator.pushReplacementNamed(context, '/questions');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        final prefs = await SharedPreferences.getInstance();
        final bool seenOnboard = prefs.getBool('seen_onboard') ?? false;
        
        if (seenOnboard) {
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          Navigator.pushReplacementNamed(context, '/onboard');
        }
      }
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 3000));
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 154.w,
              height: 154.w,
              decoration: BoxDecoration(
                color: const Color(0xFF43A047),
                borderRadius: BorderRadius.circular(24.r),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Text(
                    "Logo",
                    style: TextStyle(color: Colors.white, fontSize: 24.sp),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "SixPack30",
              style: GoogleFonts.nunitoSans(
                fontSize: 34.sp,
                fontWeight: FontWeight.w800,
                color: Colors.black,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
