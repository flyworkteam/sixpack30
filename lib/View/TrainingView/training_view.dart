import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Core/Localization/translations.dart';
import '../../Riverpod/Controllers/locale_provider.dart';
import '../../Riverpod/Controllers/premium_provider.dart';
import '../../Riverpod/Controllers/workout_provider.dart';
import '../../Riverpod/Controllers/stats_provider.dart';
import '../../Core/Data/workout_data.dart';
import '../../Core/Network/api_service.dart';
import '../HomeView/home_view.dart';
import '../PaywallView/paywall_view.dart';
import '../TrainingDetailView/training_detail_view.dart';

class WorkoutDay {
  final int day;
  final String title;
  final String duration;
  final bool isCompleted;
  final bool isCurrent;
  final int imageIndex;

  WorkoutDay({
    required this.day,
    required this.title,
    this.duration = "10 Dakika",
    this.isCompleted = false,
    this.isCurrent = false,
    required this.imageIndex,
  });
}
class TrainingView extends ConsumerStatefulWidget {
  final VoidCallback? onBackPressed;
  const TrainingView({super.key, this.onBackPressed});
  @override
  ConsumerState<TrainingView> createState() => _TrainingViewState();
}
class _TrainingViewState extends ConsumerState<TrainingView> {
  late List<WorkoutDay> workoutDays;
  @override
  void initState() {
    super.initState();
    final List<int> availableIndices = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 19];
    List<int> assignedImages = List.generate(30, (i) => availableIndices[(i * 2) % availableIndices.length]);

    final List<String> fallbackTitles = [
      'Aktivasyon', 'Kontrol', 'Yakıcı', 'Aktif Dinlenme', 'Güçlendirme', 
      'Kontrol + Oblik', 'Aktif Dinlenme', 'Aktif Dinlenme', 'Core Güçlendirme', 
      'Kontrol + Oblik', 'Yakıcı + Dayanıklılık', 'Aktif Dinlenme', 
      'Core Güç + Kontrol', 'Alt Karın + Oblik', 'Yakıcı (Hafta Finali)', 
      'Aktif Dinlenme', 'Core Dayanıklılık', 'Alt Karın + Oblik', 
      'Yakıcı Kontrol', 'Aktif Dinlenme', 'Core Güç + Süre', 
      'Alt Karın & Oblik Netleştirme', 'Yakıcı Dayanıklılık (Final Öncesi)', 
      'Aktif Dinlenme', 'Core Dayanıklılık Zirvesi', 
      'Alt Karın + Oblik Maksimum Hacim', 'Final Öncesi Yakıcı Kombin', 
      'Aktif Dinlenme', 'Final Güç Testi', 'Final Burn & Kapanış'
    ];

    workoutDays = List.generate(30, (i) => WorkoutDay(
      day: i + 1,
      title: fallbackTitles[i],
      imageIndex: assignedImages[i],
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeader(),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 25.h),
          ),
          Consumer(
            builder: (context, ref, child) {
              final workoutsAsync = ref.watch(workoutProvider);
              final statsAsync = ref.watch(statsProvider);
              final premiumAsync = ref.watch(premiumProvider);
              
              final bool isPremium = premiumAsync.value ?? false;

              return workoutsAsync.when(
                data: (workoutList) {
                  final stats = statsAsync.value;
                  final List<int> completedDays = stats?.completedDays ?? [];
                  
                  int maxCompleted = completedDays.isEmpty ? 0 : completedDays.reduce((a, b) => a > b ? a : b);
                  int currentActiveDay = maxCompleted + 1;

                  final bool isGuest = workoutList.isEmpty;
                  final langCode = ref.watch(localeProvider).languageCode;
                  final List<WorkoutDay> baseList = isGuest 
                      ? workoutDays.map((d) => WorkoutDay(
                          day: d.day,
                          title: Translations.translateWorkoutTitle(d.title, langCode),
                          duration: '10 ${Translations.translate('minutes', langCode)}',
                          imageIndex: d.imageIndex,
                        )).toList()
                      : workoutList.asMap().entries.map((e) {
                          final index = e.key;
                          final w = e.value;
                          return WorkoutDay(
                            day: index + 1,
                            title: Translations.translateWorkoutTitle(w.title, langCode),
                            duration: '${w.durationMinutes} ${Translations.translate('minutes', langCode)}',
                            imageIndex: (index % 18) + 1,
                          );
                        }).toList();

                  final activeList = baseList.map((d) {
                    return WorkoutDay(
                      day: d.day,
                      title: d.title,
                      duration: d.duration,
                      isCompleted: completedDays.contains(d.day),
                      isCurrent: d.day == currentActiveDay,
                      imageIndex: d.imageIndex,
                    );
                  }).toList();

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final isLast = index == activeList.length - 1;
                        final dayItem = activeList[index];
                        
                        final bool isPremiumLocked = dayItem.day > 3 && !isPremium;
                        final bool isSequentialLocked = dayItem.day > currentActiveDay;

                        return _buildTimelineItem(
                          dayItem, 
                          isLast, 
                          isPremiumLocked: isPremiumLocked,
                          isSequentialLocked: isSequentialLocked,
                        );
                      },
                      childCount: activeList.length,
                    ),
                  );
                },
                loading: () => const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => SliverToBoxAdapter(
                  child: Center(child: Text('Hata: $err')),
                ),
              );
            },
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 100.h),
          ),
        ],
      ),
    );
  }
  Widget _buildHeader() {
    final langCode = ref.watch(localeProvider).languageCode;
    return Container(
      width: double.infinity,
      height: 338.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(15.r)),
        image: DecorationImage(
          image: const NetworkImage('https://sixpack30.b-cdn.net/banners/training_banner.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.38),
            BlendMode.darken,
          ),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 25.w,
            top: 60.h,
            child: GestureDetector(
              onTap: () {
                if (widget.onBackPressed != null) {
                  widget.onBackPressed!();
                } else {
                  Navigator.pop(context);
                }
              },
              child: Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF).withValues(alpha: 0.85),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 14.sp,
                  color: const Color(0xFF0D0D0D),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 122.h,
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(15.r)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF271F1A).withValues(alpha: 0.4),
                    const Color(0xFF000000).withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 30.w,
            bottom: 25.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Translations.translate('program_days_title', langCode),
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                    color: const Color(0xFF00EF5B),
                    height: 22 / 16,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  Translations.translate('program_subtitle', langCode),
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                    color: const Color(0xFFFFFFFF),
                    height: 22 / 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildTimelineItem(WorkoutDay day, bool isLast, {required bool isPremiumLocked, required bool isSequentialLocked}) {
    final bool isLocked = isPremiumLocked || isSequentialLocked;
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 55.w, right: 24.w, bottom: 14.h),
          child: GestureDetector(
            onTap: () {
              if (isPremiumLocked) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const PaywallView()),
                );
                return;
              }
              
              final langCode = ref.read(localeProvider).languageCode;
              if (isSequentialLocked) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(Translations.translate('lock_message_sequential', langCode)),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    final data = StaticWorkoutData.getWorkoutForDay(day.day);
                    return TrainingDetailView(
                      dayNumber: data.day,
                      title: Translations.translateWorkoutTitle(data.title, langCode),
                      exercises: data.exercises,
                    );
                  },
                ),
              );
            },
            child: Container(
              constraints: BoxConstraints(minHeight: 70.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(color: const Color(0xFFEBEBEB)),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(14.r),
                    ),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        isLocked ? Colors.black.withValues(alpha: 0.3) : Colors.transparent,
                        BlendMode.darken,
                      ),
                      child: Image.network(
                        'https://sixpack30.b-cdn.net/days/day_${day.imageIndex}.${day.imageIndex <= 6 ? 'png' : 'jpg'}',
                        width: 115.w,
                        height: 80.h,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 115.w,
                          height: 80.h,
                          color: const Color(0xFFD9D9D9),
                          child: Center(
                            child: Icon(Icons.fitness_center,
                                color: Colors.white, size: 30.sp),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${day.day}. ${Translations.translate('workout_day', ref.watch(localeProvider).languageCode)}: ${day.title}',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w700,
                              fontSize: 13.sp,
                              color: isLocked ? const Color(0xFF747272) : const Color(0xFF000000),
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/training_clock_icon.svg',
                                width: 15.8.w,
                                height: 15.8.w,
                                colorFilter: isLocked 
                                  ? const ColorFilter.mode(Color(0xFF747272), BlendMode.srcIn)
                                  : null,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                day.duration,
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11.sp,
                                  color: isLocked ? const Color(0xFF747272) : const Color(0xFF000000),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isLocked)
                    Padding(
                      padding: EdgeInsets.only(right: 15.w),
                      child: SvgPicture.asset(
                        'assets/images/training_lock_icon.svg',
                        width: 20.w,
                        height: 20.w,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 20.w,
          top: 0,
          bottom: 0,
          child: SizedBox(
            width: 20.w,
            child: Column(
              children: [
                _buildDot(day, isLocked),
                if (!isLast) _buildDashedLine(day, isLocked),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildDot(WorkoutDay day, bool isLocked) {
    if (day.isCompleted && !isLocked) {
      return SvgPicture.asset(
        'assets/images/timeline_check_icon.svg',
        width: 14.w,
        height: 14.w,
      );
    } else if (day.isCurrent && !isLocked) {
      return Container(
        width: 14.w,
        height: 14.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFD9D9D9).withValues(alpha: 0.23),
          border: Border.all(color: const Color(0xFF00EF5B)),
        ),
      );
    } else {
      return Container(
        width: 14.w,
        height: 14.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFD9D9D9).withValues(alpha: 0.23),
          border: Border.all(color: isLocked ? const Color(0xFF747272) : const Color(0xFF747272)),
        ),
      );
    }
  }

  Widget _buildDashedLine(WorkoutDay day, bool isLocked) {
    Color dashColor = (day.isCompleted || day.isCurrent) && !isLocked
        ? const Color(0xFF00EF5B)
        : const Color(0xFF000000).withValues(alpha: 0.56);
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final boxHeight = constraints.constrainHeight();
          const dashHeight = 4.0;
          const dashSpace = 4.0;
          final dashCount = (boxHeight / (dashHeight + dashSpace)).floor();
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: 1.w,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: dashColor),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
