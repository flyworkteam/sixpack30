import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:six_pack_30/Core/Routes/app_routes.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:six_pack_30/Riverpod/Controllers/auth_controller.dart';
import 'package:six_pack_30/Riverpod/Controllers/user_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isIOS = Platform.isIOS;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 118.w,
                height: 118.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFFF2F2F2).withValues(alpha: 0.43),
                    width: 0.8,
                  ),
                  image: const DecorationImage(
                    image: NetworkImage('https://sixpack30.b-cdn.net/images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                'SixPack30',
                style: GoogleFonts.manrope(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 44 / 32,
                ),
              ),
              SizedBox(height: 30.h),
              Text(
                'Hoşgeldin',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0D0D0D),
                  letterSpacing: 0.24.sp,
                  height: 29 / 24,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                'Seni tekrar görmek güzel! Giriş yaparak\nter dökmeye hazır mısın?',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF464646),
                  height: 1.0,
                  letterSpacing: 0,
                ),
              ),
              SizedBox(height: 15.h),
              _buildButton(
                onTap: () async {
                  bool? hasCompletedSurvey;
                  if (isIOS) {
                     hasCompletedSurvey = await ref.read(authControllerProvider.notifier).signInWithApple();
                  } else {
                     hasCompletedSurvey = await ref.read(authControllerProvider.notifier).signInWithGoogle();
                  }
                  
                  final userState = ref.read(authControllerProvider);
                  if (userState.hasValue && userState.value != null && context.mounted) {
                      await ref.read(userProfileProvider.notifier).fetchProfile();
                      
                      if (hasCompletedSurvey == true) {
                        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                      } else if (hasCompletedSurvey == false) {
                        Navigator.pushNamed(context, AppRoutes.questions);
                      } else {
                        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                      }
                  } else if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Giriş yapılamadı. Lütfen internet bağlantınızı ve sunucu durumunu kontrol edin.'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                  }
                },
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      isIOS ? 'assets/images/ic_baseline-apple.svg' : 'assets/images/material-icon-theme_google.svg',
                      width: 28.w,
                      height: 28.h,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      isIOS ? 'Apple ile giriş yapın' : 'Google ile giriş yapın',
                      style: GoogleFonts.montserrat(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0D0D0D),
                        height: 17 / 14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              _buildButton(
                onTap: () async {
                  bool? hasCompletedSurvey;
                  if (isIOS) {
                    hasCompletedSurvey = await ref.read(authControllerProvider.notifier).signInWithGoogle();
                  } else {
                    hasCompletedSurvey = await ref.read(authControllerProvider.notifier).signInWithApple();
                  }

                  final userState = ref.read(authControllerProvider);
                  if (userState.hasValue && userState.value != null && context.mounted) {
                      await ref.read(userProfileProvider.notifier).fetchProfile();

                      if (hasCompletedSurvey == true) {
                        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                      } else if (hasCompletedSurvey == false) {
                        Navigator.pushNamed(context, AppRoutes.questions);
                      } else {
                        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                      }
                  }
                },
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      isIOS ? 'assets/images/material-icon-theme_google.svg' : 'assets/images/ic_baseline-apple.svg',
                      width: 28.w,
                      height: 28.h,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      isIOS ? 'Google ile giriş yapın' : 'Apple ile giriş yapın',
                      style: GoogleFonts.montserrat(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0D0D0D),
                        height: 17 / 14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              GestureDetector(
                onTap: () async {
                  final bool? hasCompletedSurvey = await ref.read(authControllerProvider.notifier).signInAnonymously();
                  if (context.mounted) {
                    final userState = ref.read(authControllerProvider);
                    if (userState.hasValue && userState.value != null) {
                      await ref.read(userProfileProvider.notifier).fetchProfile();
                      
                      if (hasCompletedSurvey == true) {
                        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                      } else if (hasCompletedSurvey == false) {
                        Navigator.pushNamed(context, AppRoutes.questions);
                      } else {
                        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Giriş yapılamadı. Lütfen internet bağlantınızı kontrol edin.'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.network('https://sixpack30.b-cdn.net/images/iconstack.io - (User Outline).svg', width: 18.w, height: 18.h, fit: BoxFit.cover),
                    SizedBox(width: 4.w),
                    Text(
                      'Misafir Olarak Devam Et',
                      style: GoogleFonts.nunito(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF464646),
                        height: 19 / 14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              SizedBox(
                width: 342.w,
                child: Text.rich(
                  TextSpan(
                    style: GoogleFonts.montserrat(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF464646),
                      height: 1.0,
                      letterSpacing: 0,
                    ),
                    children: [
                      const TextSpan(text: "SixPack30' a kaydolmakla "),
                      TextSpan(
                        text: 'Hizmet Şartlarımızı',
                        style: GoogleFonts.montserrat(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF464646),
                          decoration: TextDecoration.underline,
                          height: 1.0,
                          letterSpacing: 0,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launchUrl(
                              Uri.parse('https://fly-work.com/sixpack30/terms/'),
                              mode: LaunchMode.externalApplication),
                      ),
                      const TextSpan(
                          text:
                              ' kabul etmiş olursunuz. Verilerinizi nasıl işlediğimiz hakkında daha fazla bilgi edinmek için '),
                      TextSpan(
                        text: 'Gizlilik Politikamızı',
                        style: GoogleFonts.montserrat(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF464646),
                          decoration: TextDecoration.underline,
                          height: 1.0,
                          letterSpacing: 0,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launchUrl(
                              Uri.parse('https://fly-work.com/sixpack30/privacy-policy/'),
                              mode: LaunchMode.externalApplication),
                      ),
                      const TextSpan(text: ', '),
                      TextSpan(
                        text: 'Çerez Politikamızı',
                        style: GoogleFonts.montserrat(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF464646),
                          decoration: TextDecoration.underline,
                          height: 1.0,
                          letterSpacing: 0,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launchUrl(
                              Uri.parse('https://fly-work.com/sixpack30/cookies/'),
                              mode: LaunchMode.externalApplication),
                      ),
                      const TextSpan(text: ' ve '),
                      TextSpan(
                        text: 'CSAE Politikamızı',
                        style: GoogleFonts.montserrat(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF464646),
                          decoration: TextDecoration.underline,
                          height: 1.0,
                          letterSpacing: 0,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launchUrl(
                              Uri.parse('https://fly-work.com/sixpack30/csae/'),
                              mode: LaunchMode.externalApplication),
                      ),
                      const TextSpan(text: ' inceleyiniz.'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildButton({
    required VoidCallback onTap,
    required Widget child,
    double? width,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: width,
        height: 44.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: child,
      ),
    );
  }
}
