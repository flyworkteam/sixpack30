import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Riverpod/Controllers/stats_provider.dart';
import '../../Riverpod/Controllers/workout_provider.dart';
import '../../Core/Models/stats_model.dart';
import '../../Core/Models/workout_model.dart';
import '../../Core/Services/health_service.dart';
import '../../Riverpod/Controllers/user_provider.dart';
import '../../Riverpod/Controllers/locale_provider.dart';
import '../../Core/Localization/translations.dart';
import '../../Core/Data/workout_data.dart';
import '../../Riverpod/Controllers/workout_progress_provider.dart';
import '../../Core/Services/workout_progress_service.dart';

class ProgressView extends ConsumerStatefulWidget {
  final VoidCallback? onBackPressed;
  const ProgressView({super.key, this.onBackPressed});
  @override
  ConsumerState<ProgressView> createState() => _ProgressViewState();
}

class _ProgressViewState extends ConsumerState<ProgressView> {
  int _selectedTab = 2;
  int _selectedStepGoalValue = 15000;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(userProfileProvider).value;
      if (user?.healthConnected == true) {
        HealthService().syncHealthData().then((_) {
          ref.invalidate(statsProvider);
        });
      }
    });
  }

  List<Map<String, dynamic>> _getDynamicWeekDays(List<String> completedAtDates, String langCode) {
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final List<String> dayInitials = Translations.translate('day_initials', langCode).split(',');

    return List.generate(7, (index) {
      final day = firstDayOfWeek.add(Duration(days: index));
      final String dateStr = day.toIso8601String().split('T')[0];
      final String letter = dayInitials[index];
      return {
        'letter': letter,
        'num': day.day.toString(),
        'done': completedAtDates.contains(dateStr),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(statsProvider);
    final workoutsAsync = ref.watch(workoutProvider);
    final langCode = ref.watch(localeProvider).languageCode;
    final inProgressWorkout = ref.watch(workoutProgressProvider);
    final workoutList = workoutsAsync.value;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.only(
              top: 20.h,
              bottom: 120.h,
            ),
            child: statsAsync.when(
              loading: () => SizedBox(
                height: 1.sh,
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xFF06C44F)),
                ),
              ),
              error: (err, st) => Center(child: Text('${Translations.translate('data_load_error', langCode)}$err')),
              data: (stats) {
                final bool isGuest = stats == null;
                final currentWeekDays = _getDynamicWeekDays(
                  stats?.completedAtDates ?? [],
                  langCode,
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(langCode),
                    SizedBox(height: 30.h),
                    _buildSectionTitle(Translations.translate('daily_workout', langCode)),
                    SizedBox(height: 20.h),
                    _buildWorkoutCard(
                      title: isGuest
                          ? Translations.translate('activation', langCode)
                          : (workoutList != null && workoutList.isNotEmpty
                                ? Translations.translateWorkoutTitle(workoutList[0].title, langCode)
                                : Translations.translate('activation', langCode)),
                      isGuest: isGuest,
                      workout: workoutList != null && workoutList.isNotEmpty
                          ? workoutList[0]
                          : null,
                      langCode: langCode,
                    ),
                    SizedBox(height: 30.h),
                    _buildStreakCard(
                      streak: stats?.streak ?? 0,
                      weekDays: currentWeekDays,
                      langCode: langCode,
                    ),
                    SizedBox(height: 40.h),
                    _buildSectionTitle(Translations.translate('workout_summary', langCode)),
                    SizedBox(height: 20.h),
                    _buildAntrenmanOzeti(stats, langCode),
                    SizedBox(height: 30.h),
                    _buildSectionTitle(Translations.translate('performance_progress', langCode)),
                    SizedBox(height: 20.h),
                    _buildPerformansIlerleme(stats, langCode),
                    SizedBox(height: 15.h),
                    _buildStatsFooter(stats, langCode),
                    SizedBox(height: 15.h),
                    _buildDetailedHealthStats(stats, langCode),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Row(
                        children: [
                          Expanded(child: _buildAdimCard(stats?.steps ?? 0, langCode)),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _buildSuIcCard(stats?.waterIntake ?? 0.0, langCode),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                );
              },
            ),
          ),
          if (widget.onBackPressed == null)
            Positioned(left: 0, right: 0, bottom: 0, child: _buildBottomNav()),
        ],
      ),
    );
  }

  Widget _buildHeader(String langCode) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onBackPressed ?? () => Navigator.maybePop(context),
            child: Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: const Color(0xFFEDEDED).withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                size: 14.sp,
                color: const Color(0xFF0D0D0D),
              ),
            ),
          ),
          SizedBox(width: 7.w),
          Expanded(
            child: Text(
              Translations.translate('progress', langCode),
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0D0D0D),
                letterSpacing: -0.22.sp,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(width: 31.w),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          color: Colors.black,
          letterSpacing: -0.176.sp,
          height: 1.0,
        ),
      ),
    );
  }

  Widget _buildWorkoutCard({
    required String title,
    required bool isGuest,
    required String langCode,
    WorkoutModel? workout,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          Container(
            width: 342.w,
            height: 121.h,
            padding: EdgeInsets.fromLTRB(20.w, 10.h, 0, 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFF06C44F),
              border: Border.all(color: const Color(0xFFEBEBEB)),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          letterSpacing: -0.176.sp,
                        ),
                      ),
                      SizedBox(height: 11.h),
                      SizedBox(
                        width: 186.w,
                        child: Table(
                          columnWidths: const {
                            0: FixedColumnWidth(88),
                            1: FixedColumnWidth(88),
                          },
                          children: [
                            TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10.h),
                                  child: _buildWorkoutBadge(
                                    workout != null
                                        ? '${workout.exerciseCount ?? 8} ${Translations.translate('exercises_count', langCode)}'
                                        : '8 ${Translations.translate('exercises_count', langCode)}',
                                    'assets/images/Exercise_Body_Icon.svg',
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10.w, bottom: 10.h),
                                  child: _buildWorkoutBadge(
                                    '${Translations.translate('focus_area', langCode)}:${Translations.translate('abs', langCode)}',
                                    'assets/images/Abs_Zone_Icon.svg',
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                _buildWorkoutBadge(
                                  workout != null
                                      ? '${(workout.duration / 60).toInt()} ${Translations.translate('minutes', langCode)}'
                                      : '30 ${Translations.translate('minutes', langCode)}',
                                  'assets/images/Duration_Badge_Icon.svg',
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10.w),
                                  child: _buildWorkoutBadge(
                                    workout != null
                                        ? '${workout.calories ?? 200} ${Translations.translate('kcal', langCode)}'
                                        : '250 ${Translations.translate('kcal', langCode)}',
                                    'assets/images/Calorie_Badge_Icon.svg',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          Positioned(
            left: 223.w,
            top: -52.h,
            child: CachedNetworkImage(imageUrl: 'https://sixpack30.b-cdn.net/images/Adsız tasarım-6.png',
              width: 127.8.w,
              height: 225.38.h,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutBadge(String label, String assetPath, {double? width}) {
    return Container(
      width: width ?? 88.w,
      height: 20.h,
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (assetPath.endsWith('.svg'))
            SvgPicture.network(
              assetPath.startsWith('assets/') ? assetPath.replaceFirst('assets/', 'https://sixpack30.b-cdn.net/') : assetPath,
              width: 12.sp,
              height: 12.sp,
              fit: BoxFit.contain,
              colorFilter: const ColorFilter.mode(Color(0xFF06C44F), BlendMode.srcIn),
            )
          else
            CachedNetworkImage(
              imageUrl: assetPath.startsWith('assets/') ? assetPath.replaceFirst('assets/', 'https://sixpack30.b-cdn.net/') : assetPath,
              width: 12.sp,
              height: 12.sp,
              fit: BoxFit.contain,
            ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF100F0F),
                height: 1.2,
                letterSpacing: -0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard({
    required int streak,
    required List<Map<String, dynamic>> weekDays,
    required String langCode,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        width: 342.w,
        height: 196.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F1).withValues(alpha: 0.23),
          border: Border.all(color: const Color(0xFFEBEBEB)),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                width: 329.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SvgPicture.network('https://sixpack30.b-cdn.net/images/Streak_Fire_Icon_Full.svg',
                          width: 41.45.w,
                          height: 41.45.h,
                        ),
                        SizedBox(height: 5.82.h),
                        Text(
                          '$streak',
                          style: GoogleFonts.montserrat(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            letterSpacing: -0.22.sp,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          Translations.translate('streak', langCode),
                          style: GoogleFonts.montserrat(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            letterSpacing: -0.11.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      width: 322.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(weekDays.length, (i) {
                          final bool done = weekDays[i]['done'] as bool;
                          return Column(
                            children: [
                              Text(
                                weekDays[i]['letter'] as String,
                                style: GoogleFonts.montserrat(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  letterSpacing: -0.176.sp,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              _buildDayCircle(
                                num: weekDays[i]['num'] as String,
                                done: done,
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 18.w,
              top: 45.65.h,
              child: Transform.rotate(
                angle: -3.88 * 3.14159 / 180,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    Translations.translate('keep_going', langCode),
                    style: GoogleFonts.montserrat(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      letterSpacing: -0.11.sp,
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

  Widget _buildDayCircle({required String num, required bool done}) {
    return SizedBox(
      width: 34.w,
      height: 34.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          done
              ? SvgPicture.network('https://sixpack30.b-cdn.net/images/Streak_Tick_Base.svg',
                  width: 34.w,
                  height: 34.h,
                )
              : Container(
                  width: 34.w,
                  height: 34.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF47CD7A).withValues(alpha: 0.16),
                    shape: BoxShape.circle,
                  ),
                ),
          Text(
            num,
            style: GoogleFonts.montserrat(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: done
                  ? const Color(0xFF47CD7A).withValues(alpha: 0.58)
                  : const Color(0xFF06C44F),
              letterSpacing: -0.176.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAntrenmanOzeti(UserStats? stats, String langCode) {
    final workoutsAsync = ref.watch(workoutProvider);
    final workoutList = workoutsAsync.value;
    final inProgressWorkout = ref.watch(workoutProgressProvider);

    int totalKcal = (stats?.totalKcal ?? 0).toInt();
    int totalMoves = stats?.totalMoves ?? 0;
    int totalDuration = stats?.totalDuration ?? 0;

    if (inProgressWorkout != null) {
      final workoutData = StaticWorkoutData.getWorkoutForDay(inProgressWorkout!.dayNumber);
      final int totalExercises = workoutData.exercises.length;
      if (totalExercises > 0) {
        final double progressFactor = (inProgressWorkout!.exerciseIndex / totalExercises);
        
        final currentWorkout = workoutList?.where((w) => w.id == inProgressWorkout!.dayNumber).firstOrNull;
        final int dayKcal = currentWorkout?.calories ?? 250;
        final int dayDuration = currentWorkout?.durationMinutes ?? 15;
        final int dayMoves = currentWorkout?.exerciseCount ?? totalExercises;

        totalKcal += (progressFactor * dayKcal).toInt();
        totalMoves += inProgressWorkout!.exerciseIndex.toInt();
        totalDuration += (progressFactor * dayDuration).toInt();
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          Row(
            children: [
              _buildOzetiCard(
                width: 164.w,
                label: Translations.translate('completed_days', langCode),
                labelColor: const Color(0xFF000000),
                value: stats == null ? '0/30' : '${stats.completedDays.length}/30',
                valueColor: const Color(0xFF06C44F),
                isGreen: false,
              ),
              SizedBox(width: 13.w),
              _buildOzetiCard(
                width: 164.w,
                label: Translations.translate('calories_burned', langCode),
                labelColor: const Color(0xFFEEEEEE),
                value: '$totalKcal ${Translations.translate('kcal', langCode)}',
                valueColor: Colors.white,
                isGreen: true,
                overlayLeft: 122,
                overlayTop: 28,
                overlayWidget: CachedNetworkImage(imageUrl: 'https://sixpack30.b-cdn.net/images/training_summary_graph.png',
                  width: 42.38.w,
                  height: 49.16.h,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          SizedBox(height: 13.h),
          Row(
            children: [
              _buildOzetiCard(
                width: 213.w,
                label: Translations.translate('total_moves', langCode) ?? 'Hareket Sayısı',
                labelColor: const Color(0xFF000000),
                value: '$totalMoves',
                valueColor: const Color(0xFF06C44F),
                isGreen: false,
                overlayLeft: 64,
                overlayTop: 23,
                overlayWidget: CachedNetworkImage(imageUrl: 'https://sixpack30.b-cdn.net/images/cizgiler.png',
                  width: 149.12.w,
                  height: 63.h,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 9.w),
              _buildSureCard(
                value: '$totalDuration ${Translations.translate('minutes', langCode)}',
                langCode: langCode,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOzetiCard({
    required double width,
    required String label,
    required Color labelColor,
    required String value,
    required Color valueColor,
    required bool isGreen,
    Widget? overlayWidget,
    double overlayLeft = 0,
    double overlayTop = 0,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        width: width,
        height: 76.h,
        decoration: BoxDecoration(
          color: isGreen ? const Color(0xFF06C44F) : Colors.white,
          border: isGreen ? null : Border.all(color: const Color(0xFFEBEBEB)),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 12.w,
              top: 10.5.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.montserrat(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: labelColor,
                      height: 1.0,
                      letterSpacing: -0.11.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  value.contains('/')
                      ? RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: value.split('/')[0],
                                style: GoogleFonts.montserrat(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                  color: valueColor,
                                  letterSpacing: -0.22.sp,
                                ),
                              ),
                              TextSpan(
                                text: '/${value.split('/')[1]}',
                                style: GoogleFonts.montserrat(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  letterSpacing: -0.22.sp,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Text(
                          value,
                          style: GoogleFonts.montserrat(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: valueColor,
                            letterSpacing: -0.22.sp,
                          ),
                        ),
                ],
              ),
            ),
            if (overlayWidget != null)
              Positioned(
                left: overlayLeft.w,
                top: overlayTop.h,
                child: overlayWidget,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSureCard({required String value, required String langCode}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        width: 119.w,
        height: 76.h,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFEBEBEB)),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 8.w,
              top: 11.h,
              child: Text(
                Translations.translate('duration', langCode) ?? 'Süre',
                style: GoogleFonts.montserrat(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF434343),
                  letterSpacing: -0.132.sp,
                ),
              ),
            ),
            Positioned(
              left: 51.w,
              top: 9.h,
              child: SizedBox(
                width: 61.w,
                height: 61.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CachedNetworkImage(imageUrl: 'https://sixpack30.b-cdn.net/images/elips.png',
                      width: 61.w,
                      height: 61.h,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      value.replaceAll(' ', '\n'),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF06C44F),
                        letterSpacing: -0.132.sp,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformansIlerleme(UserStats? stats, String langCode) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          _buildListCard(
            label: Translations.translate('completion_rate', langCode),
            value: stats == null ? '%0' : '%${stats.completionRate.toInt()}',
            iconWidget: SizedBox(
              width: 54.w,
              height: 54.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.network('https://sixpack30.b-cdn.net/images/Completion_Rate_Track.svg',
                    width: 54.w,
                    height: 54.h,
                  ),
                  SizedBox(
                    width: 54.w - 3.25.w,
                    height: 54.w - 3.25.w,
                    child: CircularProgressIndicator(
                      value: stats == null ? 0.0 : (stats.completedDays.length / 30),
                      strokeWidth: 3.3.sp,
                      backgroundColor: Colors.transparent,
                      strokeCap: StrokeCap.round,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF06C44F),
                      ),
                    ),
                  ),
                  SvgPicture.network('https://sixpack30.b-cdn.net/images/Training_Completion_Icon.svg',
                    width: 20.w,
                    height: 20.h,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15.h),
          _buildListCard(
            label: Translations.translate('total_burned_calories', langCode),
            value: stats == null ? '0 ${Translations.translate('kcal', langCode)}' : '${stats.totalKcal.toInt()} ${Translations.translate('kcal', langCode)}',
            iconWidget: SizedBox(
              width: 54.w,
              height: 54.h,
              child: Stack(
                children: [
                  Positioned(
                    top: 10.h,
                    left: 0,
                    right: 0,
                    child: SvgPicture.network('https://sixpack30.b-cdn.net/images/Total_Calories_Chart.svg',
                      width: 54.w,
                      height: 54.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    top: 21.h,
                    left: 11.w,
                    child: SvgPicture.network('https://sixpack30.b-cdn.net/images/Calories_Fire_Icon.svg',
                      width: 32.w,
                      height: 32.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsFooter(UserStats? stats, String langCode) {
    if (stats == null) return const SizedBox.shrink();

    final user = ref.watch(userProfileProvider).value;
    final bool isHealthConnected = user?.healthConnected ?? false;

    final int displayBpm = isHealthConnected && stats.bpm > 0 ? stats.bpm : (isHealthConnected ? 0 : 82);
    String displaySleep = stats.sleepDuration
        .replaceAll(Translations.translate('hours', 'tr'), Translations.translate('hours', langCode))
        .replaceAll(Translations.translate('minutes', 'tr'), Translations.translate('minutes', langCode));

    if (!isHealthConnected && (stats.sleepDuration == '0 ${Translations.translate('hours', 'tr')} 0 ${Translations.translate('minutes', 'tr')}' || stats.sleepDuration == '0 ${Translations.translate('hours', 'tr')}')) {
      displaySleep = '7 ${Translations.translate('hours', langCode)} 20 ${Translations.translate('minutes', langCode)}';
    }

    final String bpm = '$displayBpm';
    final String weight = '${stats.weight.toStringAsFixed(1)} ${Translations.translate('weight_unit', langCode)}';
    final bool isGaining = stats.targetWeight > stats.initialWeight;
    final String weightChangeSign = isGaining ? '+' : '-';
    final String weightChange = stats.weightLost > 0 ? '$weightChangeSign${stats.weightLost.toStringAsFixed(1)} ${Translations.translate('weight_unit', langCode)}' : '0 ${Translations.translate('weight_unit', langCode)}';
    final String fatRate = '${stats.fatRate}%';

    String fatStatus = Translations.translate('fat_status_normal', langCode);
    if (stats.fatRate > 0 && stats.fatRate <= 10) {
      fatStatus = Translations.translate('fat_status_low', langCode);
    } else if (stats.fatRate >= 20) {
      fatStatus = Translations.translate('fat_status_high', langCode);
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSmallCard(
              title: Translations.translate('heart_rate', langCode),
              value: displayBpm > 0 ? '$bpm bpm' : '0',
              iconAsset: 'assets/images/Heart_Plus_Icon.svg',
              chartAsset: 'assets/images/Heart_Rhythm_Chart.svg',
            ),
            SizedBox(width: 14.w),
            _buildSmallCard(
              title: Translations.translate('current_weight', langCode),
              value: weight,
              subValue: weightChange,
              iconAsset: 'assets/images/Current_Weight_Icon_16.svg',
            ),
            SizedBox(width: 14.w),
            _buildSmallCard(
              title: Translations.translate('fat_rate', langCode),
              value: fatRate,
              subValue: fatStatus,
              iconAsset: 'assets/images/Body_Fat_Icon.svg',
              iconInContainer: false,
            ),
          ],
        ),
        SizedBox(height: 15.h),
        _buildListCard(
          label: Translations.translate('sleep_duration', langCode),
          value: displaySleep,
          iconWidget: SizedBox(
            width: 54.w,
            height: 54.h,
            child: Stack(
              children: [
                Positioned(
                  top: 10.h,
                  left: 0,
                  right: 0,
                  child: SvgPicture.network('https://sixpack30.b-cdn.net/images/Total_Calories_Chart.svg',
                    width: 54.w,
                    height: 54.h,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  top: 21.h,
                  left: 11.w,
                  child: SvgPicture.network('https://sixpack30.b-cdn.net/images/Sleep_Moon_Icon.svg',
                    width: 32.w,
                    height: 32.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedHealthStats(UserStats? stats, String langCode) {
    if (stats == null) return const SizedBox.shrink();

    final bool isGaining = stats.targetWeight > stats.initialWeight;
    final double weightDiff = (stats.weight - stats.initialWeight).abs();
    
    final weightLossGoal = (stats.initialWeight - stats.targetWeight).abs();
    final weightLossProgress = weightLossGoal > 0
        ? (weightDiff / weightLossGoal).clamp(0.0, 1.0)
        : 0.0;

    final waterProgress = (stats.waterIntake / 2.5).clamp(0.0, 1.0);
    final muscleProgress = (stats.muscleMass / 100.0).clamp(0.0, 1.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        width: 345.w,
        height: 148.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: const Color(0xFFF2F2F2), width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 17.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatColumn(
                label: isGaining ? Translations.translate('weight_gained', langCode) : Translations.translate('weight_lost', langCode),
                valuePart1: isGaining ? '+${weightDiff.toStringAsFixed(1)}' : '-${weightDiff.toStringAsFixed(1)}',
                valuePart2: ' ${Translations.translate('weight_unit', langCode) ?? 'Kg'}',
                valuePart1Color: const Color(0xFF06C44F),
                valuePart2Color: Colors.black,
                progressColor: const Color(0xFF06C44F),
                progressValue: weightLossProgress,
                iconAsset:
                    'assets/images/iconstack.io - (Scale Light Line) (1).png',
                iconColor: const Color(0xFF06C44F),
              ),
              _buildStatColumn(
                label: Translations.translate('body_water', langCode),
                valuePart1: '%${(stats.waterIntake / 2.5 * 100).toInt()}',
                valuePart1Color: const Color(0xFF55C5FC),
                progressColor: const Color(0xFF55C5FC),
                progressValue: waterProgress,
                iconAsset: 'assets/images/iconstack.io - (Water Drop 1).png',
                iconColor: const Color(0xFF55C5FC),
              ),
              _buildStatColumn(
                label: Translations.translate('muscle_rate', langCode),
                valuePart1: '%${stats.muscleMass.toInt()}',
                valuePart1Color: const Color(0xFFFBCF33),
                progressColor: const Color(0xFFFBCF33),
                progressValue: muscleProgress,
                iconAsset:
                    'assets/images/iconstack.io - (Body Part Six Pack) (1).png',
                iconColor: const Color(0xFFFBCF33),
                showArrow: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListCard({
    required String label,
    required String value,
    required Widget iconWidget,
  }) {
    return Container(
      width: 342.w,
      height: 76.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEBEBEB)),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Stack(
        children: [
          Positioned(left: 15.w, top: 11.h, child: iconWidget),
          Positioned(
            left: 81.w,
            top: 17.h,
            child: SizedBox(
              width: 226.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.montserrat(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      letterSpacing: -0.154.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    value,
                    style: GoogleFonts.montserrat(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      letterSpacing: -0.154.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallCard({
    required String title,
    String value = '',
    String? subValue,
    String? bottomValue,
    String? iconAsset,
    String? chartAsset,
    bool iconInContainer = true,
  }) {
    return Container(
      width: 105.w,
      height: 90.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        border: Border.all(
          color: const Color(0xFFF2F2F2).withValues(alpha: 0.66),
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 12.w,
            top: 9.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 41.w,
                  height: 24.h,
                  child: Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      height: 1.2,
                      letterSpacing: -0.11.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 9.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: GoogleFonts.montserrat(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        letterSpacing: -0.11.sp,
                        height: 1.1,
                      ),
                    ),
                    if (subValue != null) ...[
                      SizedBox(height: 7.h),
                      Text(
                        subValue,
                        style: GoogleFonts.montserrat(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF484848),
                          letterSpacing: -0.11.sp,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (chartAsset != null)
            Positioned(
              left: 0,
              right: 0,
              top: 58.h, // Pushed down to avoid overlap with 'bpm'
              bottom: 0,
              child: Opacity(
                opacity: 0.8,
                child: chartAsset.endsWith('.svg')
                    ? SvgPicture.network(chartAsset.startsWith('assets/') ? chartAsset.replaceFirst('assets/', 'https://sixpack30.b-cdn.net/') : chartAsset,
                        fit: BoxFit.fitWidth, alignment: Alignment.bottomCenter)
                    : CachedNetworkImage(imageUrl: chartAsset.startsWith('assets/') ? chartAsset.replaceFirst('assets/', 'https://sixpack30.b-cdn.net/') : chartAsset,
                        fit: BoxFit.fitWidth, alignment: Alignment.bottomCenter),
              ),
            ),
          if (iconAsset != null)
            Positioned(
              right: 12.w,
              top: 12.h,
              child: iconInContainer
                  ? Container(
                      width: 18.w,
                      height: 18.h,
                      padding: EdgeInsets.all(1.94.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: iconAsset.endsWith('.svg')
                          ? SvgPicture.network(
                              iconAsset.startsWith('assets/') ? iconAsset.replaceFirst('assets/', 'https://sixpack30.b-cdn.net/') : iconAsset,
                              width: 16.w,
                              height: 16.h,
                              fit: BoxFit.contain,
                            )
                          : CachedNetworkImage(imageUrl: 
                              iconAsset.startsWith('assets/') ? iconAsset.replaceFirst('assets/', 'https://sixpack30.b-cdn.net/') : iconAsset,
                              width: 16.w,
                              height: 16.h,
                              fit: BoxFit.contain,
                            ),
                    )
                  : (iconAsset.endsWith('.svg')
                        ? SvgPicture.network(
                            iconAsset.startsWith('assets/') ? iconAsset.replaceFirst('assets/', 'https://sixpack30.b-cdn.net/') : iconAsset,
                            width: 20.w,
                            height: 20.h,
                            fit: BoxFit.contain,
                          )
                        : CachedNetworkImage(imageUrl: 
                            iconAsset.startsWith('assets/') ? iconAsset.replaceFirst('assets/', 'https://sixpack30.b-cdn.net/') : iconAsset,
                            width: 20.w,
                            height: 20.h,
                            fit: BoxFit.contain,
                          )),
            ),
          if (bottomValue != null)
            Positioned(
              left: 80.w,
              top: 67.h,
              child: Text(
                bottomValue,
                style: GoogleFonts.montserrat(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF484848),
                  letterSpacing: -0.132.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatColumn({
    required String label,
    required String valuePart1,
    String? valuePart2,
    required Color valuePart1Color,
    Color? valuePart2Color,
    required Color progressColor,
    required double progressValue,
    required String iconAsset,
    Color? iconColor,
    bool showArrow = false,
  }) {
    return SizedBox(
      width: 90.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            maxLines: 2,
            softWrap: true,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              letterSpacing: -0.011 * 12,
            ),
          ),
          SizedBox(height: 14.h),
          SizedBox(
            width: 44.w,
            height: 44.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 44.w,
                  height: 44.h,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 3.5.sp,
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFEBEBEB),
                    ),
                  ),
                ),
                SizedBox(
                  width: 44.w,
                  height: 44.h,
                  child: CircularProgressIndicator(
                    value: progressValue,
                    strokeWidth: 3.5.sp,
                    backgroundColor: Colors.transparent,
                    strokeCap: StrokeCap.round,
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  ),
                ),
                Image.asset(
                  iconAsset,
                  width: 20.w,
                  height: 20.h,
                  color: iconColor,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      SizedBox(width: 20.w, height: 20.h),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: valuePart1,
                      style: GoogleFonts.montserrat(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: valuePart1Color,
                        letterSpacing: -0.011 * 14,
                      ),
                    ),
                    if (valuePart2 != null)
                      TextSpan(
                        text: valuePart2,
                        style: GoogleFonts.montserrat(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: valuePart2Color ?? Colors.black,
                          letterSpacing: -0.011 * 14,
                        ),
                      ),
                  ],
                ),
              ),
              if (showArrow) ...[
                SizedBox(width: 4.w),
                SvgPicture.network('https://sixpack30.b-cdn.net/images/muscle_increase_arrow.svg',
                  width: 12.w,
                  height: 12.h,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdimCard(int steps, String langCode) {
    return Container(
      height: 95.h,
      padding: EdgeInsets.only(left: 14.w, top: 12.h, right: 14.w, bottom: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFE),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFEBEBEB)),
      ),
      child: Stack(
        children: [
          Text(
            Translations.translate('steps', langCode),
            style: GoogleFonts.montserrat(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              letterSpacing: -0.011 * 14.sp,
            ),
          ),
          Positioned(
            left: 0,
            top: 22.h,
            child: SizedBox(
              width: 44.w,
              height: 44.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 44.w,
                    height: 44.h,
                    child: CircularProgressIndicator(
                      value: (steps / _selectedStepGoalValue).clamp(0.0, 1.0),
                      strokeWidth: 3.5.sp,
                      color: const Color(0xFF06C44F),
                      backgroundColor: const Color(0xFFA5A5A5).withOpacity(0.32),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  SvgPicture.network('https://sixpack30.b-cdn.net/images/step_walk_icon.svg',
                    width: 22.w,
                    height: 22.h,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 42.h,
            child: PopupMenuButton<int>(
              offset: const Offset(0, -95),
              color: const Color(0xFFECECEC),
              elevation: 0,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(
                minWidth: 85.w,
                maxWidth: 85.w,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
                side: const BorderSide(color: Color.fromRGBO(235, 235, 235, 0.11)),
              ),
              onSelected: (val) => setState(() => _selectedStepGoalValue = val),
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  enabled: false,
                  padding: EdgeInsets.zero,
                  height: 76.h,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildCustomPopupItem(Translations.translate('daily_goal', langCode).replaceAll('{count}', '10.000'), 10000, isSelected: _selectedStepGoalValue == 10000),
                      _buildCustomPopupItem(Translations.translate('daily_goal', langCode).replaceAll('{count}', '15.000'), 15000, isSelected: _selectedStepGoalValue == 15000),
                      _buildCustomPopupItem(Translations.translate('daily_goal', langCode).replaceAll('{count}', '20.000'), 20000, isSelected: _selectedStepGoalValue == 20000),
                      _buildCustomPopupItem(Translations.translate('daily_goal', langCode).replaceAll('{count}', '30.000'), 30000, isSelected: _selectedStepGoalValue == 30000),
                    ],
                  ),
                ),
              ],
              child: Container(
                width: 85.w,
                height: 22.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  Translations.translate('select_goal', langCode),
                  maxLines: 1,
                  style: GoogleFonts.montserrat(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.0,
                    letterSpacing: -0.011 * 10.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomPopupItem(
    String label,
    int value, {
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context, value);
      },
      child: Container(
        width: 85.w,
        height: 19.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color.fromRGBO(208, 205, 205, 0.43) : Colors.transparent,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF0D0D0D),
            letterSpacing: -0.11,
          ),
        ),
      ),
    );
  }

  Widget _buildSuIcCard(double water, String langCode) {
    final progressPercent = (water / 2.5).clamp(0.0, 1.0);
    return Container(
      height: 95.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFE),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFEBEBEB)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double cardWidth = constraints.maxWidth;
          final double barWidth = cardWidth - 20.w;
          return Stack(
            children: [
              Text(
                Translations.translate('water_intake', langCode),
                style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  letterSpacing: -0.011 * 14.sp,
                ),
              ),
              Positioned(
                left: 2.w,
                top: 29.h,
                child: Row(
                  children: List.generate(
                    5,
                    (i) => Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: GestureDetector(
                        onTap: () {
                          final newAmount = (i + 1) * 0.5;
                          ref.read(statsProvider.notifier).updateWater(newAmount);
                        },
                        child: SvgPicture.network('https://sixpack30.b-cdn.net/images/water_glass_icon.svg',
                          width: 19.w,
                          height: 19.h,
                          colorFilter: ColorFilter.mode(
                            i < (water / 0.5 + 0.1).floor().clamp(0, 5)
                                ? const Color(0xFF27BEEA)
                                : const Color(0xFFBBBBBB),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 10.w,
                top: 60.h,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanUpdate: (details) {
                    final double tapLoc = details.localPosition.dx;
                    final double ratio = (tapLoc / barWidth).clamp(0.0, 1.0);
                    final double newAmount = (ratio * 2.5);
                    ref.read(statsProvider.notifier).updateWater(newAmount);
                  },
                  onTapDown: (details) {
                    final double tapLoc = details.localPosition.dx;
                    final double ratio = (tapLoc / barWidth).clamp(0.0, 1.0);
                    final double newAmount = (ratio * 2.5);
                    ref.read(statsProvider.notifier).updateWater(newAmount);
                  },
                  child: SizedBox(
                    height: 10.h,
                    width: barWidth,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 4.h,
                          width: barWidth,
                          decoration: BoxDecoration(
                            color: const Color(0xFFC3F1FF),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        Container(
                          height: 4.h,
                          width: barWidth * progressPercent,
                          decoration: BoxDecoration(
                            color: const Color(0xFF06C44F),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        Positioned(
                          left: (barWidth * progressPercent).clamp(0.0, barWidth) - 5,
                          top: 0,
                          child: Container(
                            width: 10.w,
                            height: 10.h,
                            decoration: const BoxDecoration(
                              color: Color(0xFF06C44F),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomNav() {
    final langCode = ref.watch(localeProvider).languageCode;
    final tabs = [
      {'label': Translations.translate('home', langCode), 'icon': Icons.home_outlined},
      {'label': Translations.translate('training', langCode), 'icon': Icons.sports_gymnastics},
      {'label': Translations.translate('progress', langCode), 'icon': Icons.bar_chart},
      {'label': Translations.translate('profile', langCode), 'icon': Icons.person_outline},
    ];
    return Container(
      width: double.infinity,
      height: 70.h,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            offset: const Offset(0, -1),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final bool isActive = _selectedTab == i;
          return GestureDetector(
            onTap: () {
              if (i == 0) {
                Navigator.pushReplacementNamed(context, '/home');
              } else {
                setState(() => _selectedTab = i);
              }
            },
            child: SizedBox(
              width: 95.w,
              height: 70.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    tabs[i]['icon'] as IconData,
                    size: 24.sp,
                    color: isActive
                        ? const Color(0xFF06C44F)
                        : const Color(0xFF323232),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    tabs[i]['label'] as String,
                    style: GoogleFonts.manrope(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: isActive
                          ? const Color(0xFF06C44F)
                          : const Color(0xFF323232),
                      height: 22 / 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
