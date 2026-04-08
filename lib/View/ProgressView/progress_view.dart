import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
class ProgressView extends StatefulWidget {
  final VoidCallback? onBackPressed;
  const ProgressView({super.key, this.onBackPressed});
  @override
  State<ProgressView> createState() => _ProgressViewState();
}
class _ProgressViewState extends State<ProgressView> {
  int _selectedTab = 2;
  double _waterIntake = 0.6;
  String _selectedStepGoal = '';
  final List<String> _stepGoals = [
    'Günlük 6 bin',
    'Günlük 10 bin',
    'Haftada 40 bin',
    'Haftada 90 bin',
  ];
  OverlayEntry? _stepGoalOverlay;
  final GlobalKey _hedefSecKey = GlobalKey();
  @override
  void dispose() {
    _stepGoalOverlay?.remove();
    super.dispose();
  }
  void _openStepGoalDropdown() {
    final box = _hedefSecKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final pos = box.localToGlobal(Offset.zero);
    _stepGoalOverlay = OverlayEntry(
      builder: (_) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeStepGoalDropdown,
              behavior: HitTestBehavior.opaque,
              child: const SizedBox.expand(),
            ),
          ),
          Positioned(
            left: pos.dx,
            top: pos.dy - 87,
            child: Material(
              color: Colors.transparent,
              child: _buildGoalDropdown(),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_stepGoalOverlay!);
  }
  void _closeStepGoalDropdown() {
    _stepGoalOverlay?.remove();
    _stepGoalOverlay = null;
  }
  Widget _buildGoalDropdown() {
    return Container(
      width: 85,
      height: 82,
      decoration: BoxDecoration(
        color: const Color(0xFFECECEC),
        border: Border.all(color: const Color(0x1CEBEBEB)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 20,
            child: Container(
              width: 85,
              height: 19,
              color: const Color(0x6DD0CDCD),
            ),
          ),
          ...{
            'Günlük 6 bin': 6.0,
            'Günlük 10 bin': 24.0,
            'Haftada 40 bin': 43.0,
            'Haftada 90 bin': 63.0,
          }.entries.map(
            (e) => Positioned(
              left: 0,
              top: e.value,
              child: GestureDetector(
                onTap: () {
                  setState(() => _selectedStepGoal = e.key);
                  _closeStepGoalDropdown();
                },
                child: Container(
                  width: 85,
                  height: 17,
                  alignment: Alignment.center,
                  child: Text(
                    e.key,
                    style: GoogleFonts.montserrat(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF0D0D0D),
                      letterSpacing: -0.011 * 10,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  final List<Map<String, dynamic>> _weekDays = [
    {'letter': 'P', 'num': '23', 'done': true},
    {'letter': 'S', 'num': '24', 'done': true},
    {'letter': 'Ç', 'num': '25', 'done': true},
    {'letter': 'P', 'num': '26', 'done': false},
    {'letter': 'C', 'num': '27', 'done': false},
    {'letter': 'C', 'num': '28', 'done': false},
    {'letter': 'P', 'num': '29', 'done': false},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 80.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 54.h),
                SizedBox(height: 20.h),
                _buildHeader(),
                SizedBox(height: 30.h),
                _buildSectionTitle('Günün Antrenmanı'),
                SizedBox(height: 20.h),
                _buildWorkoutCard(),
                SizedBox(height: 30.h),
                _buildStreakCard(),
                SizedBox(height: 40.h),
                _buildSectionTitle('Antrenman Özeti'),
                SizedBox(height: 20.h),
                _buildAntrenmanOzeti(),
                SizedBox(height: 30.h),
                _buildSectionTitle('Performans & İlerleme'),
                SizedBox(height: 20.h),
                _buildPerformansIlerleme(),
                SizedBox(height: 15.h),
                _buildStatsFooter(),
                SizedBox(height: 20.h),
                _buildActivityRow(),
                SizedBox(height: 20.h),
              ],
            ),
          ),
          if (widget.onBackPressed == null)
            Positioned(left: 0, right: 0, bottom: 0, child: _buildBottomNav()),
        ],
      ),
    );
  }
  Widget _buildHeader() {
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
              'İlerleme',
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
  Widget _buildWorkoutCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 342.w,
            padding: EdgeInsets.only(
              left: 20.w,
              top: 20.h,
              bottom: 20.h,
              right: 10.w,
            ),
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
                        'Aktivasyon',
                        style: GoogleFonts.montserrat(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          letterSpacing: -0.176.sp,
                        ),
                      ),
                      SizedBox(height: 11.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 9.h,
                        children: [
                          _buildWorkoutBadge(
                            '8 Egzersiz',
                            'assets/images/Exercise_Body_Icon.svg',
                          ),
                          _buildWorkoutBadge(
                            'Bölge:Karın',
                            'assets/images/Abs_Zone_Icon.svg',
                          ),
                        ],
                      ),
                      SizedBox(height: 9.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 9.h,
                        children: [
                          _buildWorkoutBadge(
                            '30 Dakika',
                            'assets/images/Duration_Badge_Icon.svg',
                          ),
                          _buildWorkoutBadge(
                            '250 Kcal',
                            'assets/images/Calorie_Badge_Icon.svg',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 100.w),
              ],
            ),
          ),
          Positioned(
            right: -10.w,
            bottom: 0,
            child: Image.asset(
              'assets/images/Adsız tasarım-6.png',
              width: 127.8.w,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutBadge(String label, String assetPath) {
    return Container(
      width: 88.w,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (assetPath.endsWith('.svg'))
            SvgPicture.asset(
              assetPath,
              width: 12.w,
              height: 12.h,
              fit: BoxFit.contain,
            )
          else
            Image.asset(
              assetPath,
              width: 12.w,
              height: 12.h,
              fit: BoxFit.contain,
            ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF100F0F),
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildStreakCard() {
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
                        SvgPicture.asset(
                          'assets/images/Streak_Fire_Icon_Full.svg',
                          width: 41.45.w,
                          height: 41.45.h,
                        ),
                        SizedBox(height: 5.82.h),
                        Text(
                          '3',
                          style: GoogleFonts.montserrat(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            letterSpacing: -0.22.sp,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          'Günlük Seri',
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
                        children: List.generate(_weekDays.length, (i) {
                          final bool done = _weekDays[i]['done'] as bool;
                          return Column(
                            children: [
                              Text(
                                _weekDays[i]['letter'] as String,
                                style: GoogleFonts.montserrat(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  letterSpacing: -0.176.sp,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              _buildDayCircle(
                                num: _weekDays[i]['num'] as String,
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
                  width: 111.15.w,
                  height: 18.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'Harika Gidiyorsun 🎉',
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
              ? SvgPicture.asset(
                  'assets/images/Streak_Tick_Base.svg',
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
  Widget _buildAntrenmanOzeti() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          Row(
            children: [
              _buildOzetiCard(
                width: 164.w,
                label: 'Tamamlanan Günler',
                labelColor: const Color(0xFF000000),
                value: '12/30',
                valueColor: const Color(0xFF06C44F),
                isGreen: false,
              ),
              SizedBox(width: 13.w),
              _buildOzetiCard(
                width: 164.w,
                label: 'Yakılan Kalori',
                labelColor: const Color(0xFFEEEEEE),
                value: '480 Kcal',
                valueColor: Colors.white,
                isGreen: true,
                overlayLeft: 122,
                overlayTop: 28,
                overlayWidget: Image.asset(
                  'assets/images/training_summary_graph.png',
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
                label: 'Hareket Sayısı',
                labelColor: const Color(0xFF000000),
                value: '46',
                valueColor: const Color(0xFF06C44F),
                isGreen: false,
                overlayLeft: 64,
                overlayTop: 23,
                overlayWidget: Image.asset(
                  'assets/images/cizgiler.png',
                  width: 149.12.w,
                  height: 63.h,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 9.w),
              _buildSureCard(),
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
  Widget _buildSureCard() {
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
                'Süre',
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
                    Image.asset(
                      'assets/images/elips.png',
                      width: 61.w,
                      height: 61.h,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      '40 Dk',
                      style: GoogleFonts.montserrat(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF06C44F),
                        letterSpacing: -0.132.sp,
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
  Widget _buildPerformansIlerleme() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          _buildListCard(
            label: 'Antrenman Tamamlama Oranın',
            value: '%72',
            iconWidget: SizedBox(
              width: 54.w,
              height: 54.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/Completion_Rate_Track.svg',
                    width: 54.w,
                    height: 54.h,
                  ),
                  SizedBox(
                    width: 54.w - 3.25.w,
                    height: 54.w - 3.25.w,
                    child: CircularProgressIndicator(
                      value: 0.72,
                      strokeWidth: 3.3.sp,
                      backgroundColor: Colors.transparent,
                      strokeCap: StrokeCap.round,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF06C44F),
                      ),
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/images/Training_Completion_Icon.svg',
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
            label: 'Toplam Yakılan Kalori',
            value: '2100 Kcal',
            iconWidget: SizedBox(
              width: 54.w,
              height: 54.h,
              child: Stack(
                children: [
                   Positioned(
                    top: 10.h,
                    left: 0,
                    right: 0,
                    child: SvgPicture.asset(
                      'assets/images/Total_Calories_Chart.svg',
                      width: 54.w,
                      height: 54.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    top: 21.h,
                    left: 11.w,
                    child: SvgPicture.asset(
                      'assets/images/Calories_Fire_Icon.svg',
                      width: 32.w,
                      height: 32.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15.h),
          Row(
            children: [
              _buildSmallCard(
                title: 'Kalp Atışın',
                bottomValue: '82',
                iconAsset: 'assets/images/Heart_Plus_Icon.svg',
                chartAsset: 'assets/images/Heart_Rhythm_Chart.svg',
              ),
              SizedBox(width: 14.w),
              _buildSmallCard(
                title: 'Mevcut Ağırlık',
                value: '62 Kg',
                subValue: '-3 Kg',
                iconAsset: 'assets/images/Current_Weight_Icon_16.svg',
              ),
              SizedBox(width: 14.w),
              _buildSmallCard(
                title: 'Yağ Oranın',
                value: '%12',
                subValue: 'Az',
                iconAsset: 'assets/images/Body_Fat_Icon.svg',
                iconInContainer: false,
              ),
            ],
          ),
          SizedBox(height: 15.h),
          _buildListCard(
            label: 'Uykuda Geçirilen Süre',
            value: '10 Saat',
            iconWidget: SizedBox(
              width: 54.w,
              height: 54.h,
              child: Stack(
                children: [
                  Positioned(
                    top: 10.h,
                    left: 0,
                    right: 0,
                    child: SvgPicture.asset(
                      'assets/images/Total_Calories_Chart.svg',
                      width: 54.w,
                      height: 54.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    top: 21.h,
                    left: 11.w,
                    child: SvgPicture.asset(
                      'assets/images/Sleep_Moon_Icon.svg',
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
          if (bottomValue != null)
            Positioned(
              left: 11.w,
              top: 8.5.h,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      letterSpacing: -0.11.sp,
                    ),
                  ),
                  if (iconAsset != null) ...[
                    SizedBox(width: 11.w),
                    Container(
                      width: 20.w,
                      height: 20.h,
                      padding: EdgeInsets.all(1.94.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: iconAsset.endsWith('.svg')
                          ? SvgPicture.asset(
                              iconAsset,
                              width: 16.w,
                              height: 16.h,
                              fit: BoxFit.contain,
                            )
                          : Image.asset(
                              iconAsset,
                              width: 16.w,
                              height: 16.h,
                              fit: BoxFit.contain,
                            ),
                    ),
                  ],
                ],
              ),
            ),
          if (chartAsset != null)
            Positioned(
              left: 0,
              right: 0,
              top: 25.h,
              bottom: 12.h,
              child: chartAsset.endsWith('.svg')
                  ? SvgPicture.asset(chartAsset, fit: BoxFit.contain)
                  : Image.asset(chartAsset, fit: BoxFit.contain),
            ),
          if (value.isNotEmpty)
            Positioned(
              left: 12.w,
              top: 10.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 60.w,
                    child: Text(
                      title,
                      style: GoogleFonts.montserrat(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        height: 1.2,
                        letterSpacing: -0.11.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 7.h),
                  Text(
                    value,
                    style: GoogleFonts.montserrat(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      letterSpacing: -0.154.sp,
                    ),
                  ),
                  if (subValue != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subValue,
                      style: GoogleFonts.montserrat(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF484848).withValues(alpha: 0.5),
                        letterSpacing: -0.132.sp,
                      ),
                    ),
                  ],
                ],
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
                          ? SvgPicture.asset(
                              iconAsset,
                              width: 16.w,
                              height: 16.h,
                              fit: BoxFit.contain,
                            )
                          : Image.asset(
                              iconAsset,
                              width: 16.w,
                              height: 16.h,
                              fit: BoxFit.contain,
                            ),
                    )
                  : (iconAsset.endsWith('.svg')
                      ? SvgPicture.asset(
                          iconAsset,
                          width: 20.w,
                          height: 20.h,
                          fit: BoxFit.contain,
                        )
                      : Image.asset(
                          iconAsset,
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
  Widget _buildStatsFooter() {
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
                label: 'Verilen Kilo',
                valuePart1: '-3',
                valuePart2: ' Kilo',
                valuePart1Color: const Color(0xFF06C44F),
                valuePart2Color: Colors.black,
                progressColor: const Color(0xFF06C44F),
                progressValue: 0.75,
                iconAsset: 'assets/images/iconstack.io - (Scale Light Line) (1).png',
                iconColor: const Color(0xFF06C44F),
              ),
              _buildStatColumn(
                label: 'Vücut Suyu',
                valuePart1: '%45',
                valuePart1Color: const Color(0xFF55C5FC),
                progressColor: const Color(0xFF55C5FC),
                progressValue: 0.45,
                iconAsset: 'assets/images/iconstack.io - (Water Drop 1).png',
                iconColor: const Color(0xFF55C5FC),
              ),
              _buildStatColumn(
                label: 'Kas Oranı',
                valuePart1: '%10',
                valuePart1Color: const Color(0xFFFBCF33),
                progressColor: const Color(0xFFFBCF33),
                progressValue: 0.82,
                iconAsset: 'assets/images/iconstack.io - (Body Part Six Pack) (1).png',
                iconColor: const Color(0xFFFBCF33),
                showArrow: true,
              ),
            ],
          ),
        ),
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
      width: 75.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.visible,
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
                SvgPicture.asset(
                  'assets/images/muscle_increase_arrow.svg',
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
  Widget _buildActivityRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          Expanded(child: _buildAdimCard()),
          SizedBox(width: 12.w),
          Expanded(child: _buildSuIcCard()),
        ],
      ),
    );
  }
  Widget _buildAdimCard() {
    return Container(
      height: 95.h,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEBEBEB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Adım',
            style: GoogleFonts.montserrat(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          Row(
            children: [
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
                        value: 0.4,
                        strokeWidth: 3.5.sp,
                        color: const Color(0xFF06C44F),
                        backgroundColor: const Color(0xFFF2F2F2),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/images/step_walk_icon.svg',
                      width: 22.sp,
                      height: 22.sp,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                key: _hedefSecKey,
                onTap: _openStepGoalDropdown,
                child: Container(
                  width: 85.w,
                  height: 22.h,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    top: 5.h,
                    bottom: 5.h,
                    left: 9.w,
                    right: 9.w,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    'Hedef seç',
                    maxLines: 1,
                    overflow: TextOverflow.visible,
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
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildSuIcCard() {
    return Container(
      height: 95.h,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEBEBEB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Su iç',
            style: GoogleFonts.montserrat(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              5,
              (i) => SvgPicture.asset(
                'assets/images/water_glass_icon.svg',
                width: 19.sp,
                height: 19.sp,
                colorFilter: ColorFilter.mode(
                  i < (_waterIntake * 5).round()
                      ? const Color(0xFF27BEEA)
                      : const Color(0xFFBBBBBB),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const Spacer(),
          _buildWaterBar(),
        ],
      ),
    );
  }
  Widget _buildWaterBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double w = constraints.maxWidth > 0
            ? constraints.maxWidth
            : 100.0;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragUpdate: (d) {
            setState(
              () => _waterIntake = (_waterIntake + d.delta.dx / w).clamp(
                0.0,
                1.0,
              ),
            );
          },
          onTapDown: (d) {
            setState(
              () => _waterIntake = (d.localPosition.dx / w).clamp(0.0, 1.0),
            );
          },
          child: SizedBox(
            height: 15.h,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.centerLeft,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 3.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC3F1FF),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                Container(
                  height: 3.h,
                  width: w * _waterIntake,
                  decoration: BoxDecoration(
                    color: const Color(0xFF06C44F),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                Positioned(
                  left: (w * _waterIntake).clamp(0.0, w) - 5,
                  top: 2.5.h,
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
        );
      },
    );
  }
  Widget _buildBottomNav() {
    final tabs = [
      {'label': 'Anasayfa', 'icon': Icons.home_outlined},
      {'label': 'Antrenman', 'icon': Icons.sports_gymnastics},
      {'label': 'İlerleme', 'icon': Icons.bar_chart},
      {'label': 'Profil', 'icon': Icons.person_outline},
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
