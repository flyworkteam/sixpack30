import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../TrainingDetailView/training_detail_view.dart';
class WorkoutDay {
  final int day;
  final String title;
  final String duration;
  final bool isCompleted;
  final bool isCurrent;
  final int imageIndex;
  bool get isLocked => !isCompleted && !isCurrent;
  WorkoutDay({
    required this.day,
    required this.title,
    this.duration = "30 Dakika",
    this.isCompleted = false,
    this.isCurrent = false,
    required this.imageIndex,
  });
}
class TrainingView extends StatefulWidget {
  final VoidCallback? onBackPressed;
  const TrainingView({super.key, this.onBackPressed});
  @override
  State<TrainingView> createState() => _TrainingViewState();
}
class _TrainingViewState extends State<TrainingView> {
  late List<WorkoutDay> workoutDays;
  @override
  void initState() {
    super.initState();
    final List<int> availableIndices = [
      1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 19
    ];

    List<int> assignedImages = [];
    for (int i = 0; i < 30; i++) {
      int imageIdx = availableIndices[(i * 2) % availableIndices.length];
      assignedImages.add(imageIdx);
    }

    workoutDays = [
      WorkoutDay(day: 1, title: 'Aktivasyon', isCompleted: true, imageIndex: assignedImages[0]),
      WorkoutDay(day: 2, title: 'Kontrol', isCompleted: true, imageIndex: assignedImages[1]),
      WorkoutDay(day: 3, title: 'Yakıcı', isCurrent: true, imageIndex: assignedImages[2]),
      WorkoutDay(day: 4, title: 'Aktif Dinlenme', imageIndex: assignedImages[3]),
      WorkoutDay(day: 5, title: 'Güçlendirme', imageIndex: assignedImages[4]),
      WorkoutDay(day: 6, title: 'Kontrol + Oblik', imageIndex: assignedImages[5]),
      WorkoutDay(day: 7, title: 'Aktif Dinlenme', imageIndex: assignedImages[6]),
      WorkoutDay(day: 8, title: 'Aktif Dinlenme', imageIndex: assignedImages[7]),
      WorkoutDay(day: 9, title: 'Core Güçlendirme', imageIndex: assignedImages[8]),
      WorkoutDay(day: 10, title: 'Kontrol + Oblik', imageIndex: assignedImages[9]),
      WorkoutDay(day: 11, title: 'Yakıcı + Dayanıklılık', imageIndex: assignedImages[10]),
      WorkoutDay(day: 12, title: 'Aktif Dinlenme', imageIndex: assignedImages[11]),
      WorkoutDay(day: 13, title: 'Core Güç + Kontrol', imageIndex: assignedImages[12]),
      WorkoutDay(day: 14, title: 'Alt Karın + Oblik', imageIndex: assignedImages[13]),
      WorkoutDay(day: 15, title: 'Yakıcı (Hafta Finali)', imageIndex: assignedImages[14]),
      WorkoutDay(day: 16, title: 'Aktif Dinlenme', imageIndex: assignedImages[15]),
      WorkoutDay(day: 17, title: 'Core Dayanıklılık', imageIndex: assignedImages[16]),
      WorkoutDay(day: 18, title: 'Alt Karın + Oblik', imageIndex: assignedImages[17]),
      WorkoutDay(day: 19, title: 'Yakıcı Kontrol', imageIndex: assignedImages[18]),
      WorkoutDay(day: 20, title: 'Aktif Dinlenme', imageIndex: assignedImages[19]),
      WorkoutDay(day: 21, title: 'Core Güç + Süre', imageIndex: assignedImages[20]),
      WorkoutDay(day: 22, title: 'Alt Karın & Oblik Netleştirme', imageIndex: assignedImages[21]),
      WorkoutDay(day: 23, title: 'Yakıcı Dayanıklılık (Final Öncesi)', imageIndex: assignedImages[22]),
      WorkoutDay(day: 24, title: 'Aktif Dinlenme', imageIndex: assignedImages[23]),
      WorkoutDay(day: 25, title: 'Core Dayanıklılık Zirvesi', imageIndex: assignedImages[24]),
      WorkoutDay(day: 26, title: 'Alt Karın + Oblik Maksimum Hacim', imageIndex: assignedImages[25]),
      WorkoutDay(day: 27, title: 'Final Öncesi Yakıcı Kombin', imageIndex: assignedImages[26]),
      WorkoutDay(day: 28, title: 'Aktif Dinlenme', imageIndex: assignedImages[27]),
      WorkoutDay(day: 29, title: 'Final Güç Testi', imageIndex: assignedImages[28]),
      WorkoutDay(day: 30, title: 'Final Burn & Kapanış', imageIndex: assignedImages[29]),
    ];
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final isLast = index == workoutDays.length - 1;
                return _buildTimelineItem(workoutDays[index], isLast);
              },
              childCount: workoutDays.length,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 100.h),
          ),
        ],
      ),
    );
  }
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 338.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(15.r)),
        image: DecorationImage(
          image: const AssetImage('assets/images/training_banner.jpg'),
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
                  '30 Günlük',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                    color: const Color(0xFF00EF5B),
                    height: 22 / 16,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Karın Kası Programı',
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
  Widget _buildTimelineItem(WorkoutDay day, bool isLast) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 55.w, right: 24.w, bottom: 14.h),
          child: GestureDetector(
            onTap: () {
              if (day.isLocked) return;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const TrainingDetailView(),
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
                  child: Image.asset(
                    'assets/images/day_${day.imageIndex}.${day.imageIndex <= 6 ? 'png' : 'jpg'}',
                    width: 115.w,
                    height: 70.h + 10.h,
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
                SizedBox(width: 12.w),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${day.day}.Gün: ${day.title}',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.sp,
                            color: const Color(0xFF000000),
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
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              day.duration,
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500,
                                fontSize: 11.sp,
                                color: const Color(0xFF000000),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (day.isLocked)
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
                _buildDot(day),
                if (!isLast) _buildDashedLine(day),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildDot(WorkoutDay day) {
    if (day.isCompleted) {
      return SvgPicture.asset(
        'assets/images/timeline_check_icon.svg',
        width: 14.w,
        height: 14.w,
      );
    } else if (day.isCurrent) {
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
          border: Border.all(color: const Color(0xFF747272)),
        ),
      );
    }
  }
  Widget _buildDashedLine(WorkoutDay day) {
    Color dashColor = day.isCompleted || day.isCurrent
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
