import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Core/Localization/translations.dart';
import '../../Riverpod/Controllers/locale_provider.dart';

class MotivationView extends ConsumerStatefulWidget {
  final String userName;
  final int completedExercises;
  final int activeMinutes;
  final bool isFinal;
  const MotivationView({
    super.key,
    this.userName = "Kullanıcı",
    this.completedExercises = 4,
    this.activeMinutes = 10,
    this.isFinal = false,
  });
  @override
  ConsumerState<MotivationView> createState() => _MotivationViewState();
}

class _MotivationViewState extends ConsumerState<MotivationView> {
  Timer? _timer;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();
    _timer = Timer(const Duration(seconds: 5), () {
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _timer?.cancel();
          Navigator.of(context).pop();
        },
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: 500.h,
              child: CachedNetworkImage(imageUrl: 'https://sixpack30.b-cdn.net/images/confetti_bg.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple
                ],
              ),
            ),
            Positioned(
              left: 24.w,
              top: 68.h,
              child: GestureDetector(
                onTap: () {
                  _timer?.cancel();
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDEDED).withValues(alpha: 0.85),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(right: 2.w),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 12.sp,
                      color: const Color(0xFF0D0D0D),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00EF5B),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 60.w,
                    ),
                  ),
                  SizedBox(height: 35.h),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: Translations.translate('doing_great', ref.watch(localeProvider).languageCode),
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w600,
                        fontSize: 24.sp,
                        color: const Color(0xFF000000),
                        height: 30 / 24,
                      ),
                      children: [
                        TextSpan(
                          text: widget.userName,
                          style: GoogleFonts.manrope(
                            color: const Color(0xFF00EF5B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 22.h),
                  Text(
                    widget.isFinal 
                      ? '${Translations.translate('great_job', ref.watch(localeProvider).languageCode)}\n${Translations.translate('goal_reached_desc', ref.watch(localeProvider).languageCode)}'
                      : '${Translations.translate('half_way_done', ref.watch(localeProvider).languageCode)}\n${Translations.translate('half_way_desc', ref.watch(localeProvider).languageCode)}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                      color: const Color(0xFF5C5C5C),
                      height: 25 / 18,
                    ),
                  ),
                  SizedBox(height: 35.h),
                  Container(
                    width: 334.w,
                    padding: EdgeInsets.symmetric(vertical: 22.h, horizontal: 28.w),
                    decoration: BoxDecoration(
                      color: const Color(0x9BACEDC5),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🚀 ${widget.completedExercises} ${Translations.translate('exercises_finished', ref.watch(localeProvider).languageCode)}',
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                            color: const Color(0xFF100F0F),
                            height: 25 / 18,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          '⚡️ ${widget.activeMinutes} ${Translations.translate('minutes_done', ref.watch(localeProvider).languageCode)}',
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                            color: const Color(0xFF100F0F),
                            height: 25 / 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
