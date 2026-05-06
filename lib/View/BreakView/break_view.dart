import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Core/Localization/translations.dart';
import '../../Riverpod/Controllers/locale_provider.dart';

class BreakView extends ConsumerStatefulWidget {
  final int durationInSeconds;
  const BreakView({
    super.key,
    this.durationInSeconds = 30,
  });
  @override
  ConsumerState<BreakView> createState() => _BreakViewState();
}

class _BreakViewState extends ConsumerState<BreakView> with SingleTickerProviderStateMixin {
  late int remainingSeconds;
  Timer? _timer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.durationInSeconds;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 1) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        timer.cancel();
        Navigator.of(context).pop();
      }
    });
  }
  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 70.w,
                    height: 70.w,
                    alignment: Alignment.center,
                    child: SvgPicture.network('https://sixpack30.b-cdn.net/images/rest_muscles_icon.svg',
                      width: 70.w,
                      height: 70.w,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: Translations.translate('rest_muscles_title', ref.watch(localeProvider).languageCode).split(' ')[0] + '\n',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        fontSize: 24.69.sp,
                        color: const Color(0xFF000000),
                        height: 1.0,
                      ),
                      children: [
                        TextSpan(
                          text: Translations.translate('rest_muscles_title', ref.watch(localeProvider).languageCode).split(' ').sublist(1).join(' '),
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF06C44F),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50.h),
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: SizedBox(
                      width: 201.w,
                      height: 201.w,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 201.w,
                            height: 201.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF06C44F).withValues(alpha: 0.36),
                            ),
                          ),
                          Container(
                            width: 165.w,
                            height: 165.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF06C44F).withValues(alpha: 0.44),
                            ),
                          ),
                          Container(
                            width: 114.w,
                            height: 114.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF06C44F).withValues(alpha: 0.6),
                            ),
                          ),
                          Container(
                            width: 64.w,
                            height: 64.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF06C44F),
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${remainingSeconds - 1} ${Translations.translate('seconds', ref.watch(localeProvider).languageCode)}',
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 10.sp,
                                    color: Colors.white.withValues(alpha: 0.73),
                                    height: 1,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  '$remainingSeconds ${Translations.translate('seconds', ref.watch(localeProvider).languageCode)}',
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 50.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 45.w),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 20.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        border: Border.all(color: const Color(0xFFEBEBEB)),
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Text(
                        Translations.translate('rest_muscles_desc', ref.watch(localeProvider).languageCode),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: 13.sp,
                          color: const Color(0xFF000000),
                          height: 17 / 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
            Positioned(
              left: 24.w,
              right: 24.w,
              bottom: 34.h,
              child: GestureDetector(
                onTap: () {
                  _timer?.cancel();
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: double.infinity,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00EF5B),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    Translations.translate('skip', ref.watch(localeProvider).languageCode),
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: const Color(0xFF0A0A0A),
                      letterSpacing: -0.011,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
