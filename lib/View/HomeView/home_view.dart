import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../ProfileView/profile_view.dart';
import '../NotificationsView/notifications_view.dart';
import '../TrainingView/training_view.dart';
import '../ProgressView/progress_view.dart';
class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}
class _HomeViewState extends State<HomeView> {
  bool isPremium = true;
  int _selectedTab = 0;
  int _selectedDay = 0;
  final List<Map<String, String>> _days = [
    {'num': '22', 'letter': 'P'},
    {'num': '23', 'letter': 'S'},
    {'num': '24', 'letter': 'Ç'},
    {'num': '25', 'letter': 'P'},
    {'num': '26', 'letter': 'C'},
    {'num': '27', 'letter': 'C'},
    {'num': '28', 'letter': 'P'},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _selectedTab == 3
                ? ProfileView(
                    key: const ValueKey('ProfileTab'),
                    isPremium: isPremium,
                    onBackPressed: () => setState(() => _selectedTab = 0),
                  )
                : _selectedTab == 2
                ? ProgressView(
                    key: const ValueKey('ProgressTab'),
                    onBackPressed: () => setState(() => _selectedTab = 0),
                  )
                : _selectedTab == 1
                ? TrainingView(
                    key: const ValueKey('TrainingTab'),
                    onBackPressed: () => setState(() => _selectedTab = 0),
                  )
                : SingleChildScrollView(
                    key: const ValueKey('HomeTab'),
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 80.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 54.h),
                        _buildHeader(),
                        SizedBox(height: 18.h),
                        _buildDaySelector(),
                        SizedBox(height: 30.h),
                        _buildSectionTitle('Günün Antrenmanı'),
                        SizedBox(height: 18.h),
                        _buildWorkoutCard(),
                        SizedBox(height: 30.h),
                        _buildSectionTitle('Kaldığın Yerden Devam Et'),
                        SizedBox(height: 20.h),
                        _buildExerciseCard(
                          imagePath:
                              'assets/images/Gemini_Generated_Image_wgw42fwgw42fwgw4.png',
                          title: 'Bent Knee Leg Raise',
                          category: 'Karın',
                          progress: 109 / 213,
                          progressText: '62%',
                        ),
                        SizedBox(height: 15.h),
                        _buildExerciseCard(
                          imagePath:
                              'assets/images/Gemini_Generated_Image_h389nrh389nrh389.png',
                          title: 'Lying Knee Raise',
                          category: 'Karın',
                          progress: 80 / 213,
                          progressText: '45%',
                        ),
                        SizedBox(height: 30.h),
                        _buildProgressBadge(),
                        SizedBox(height: 30.h),
                        _buildSectionTitle('Tamamlanan Günler'),
                        SizedBox(height: 15.h),
                        _buildCompletedDays(),
                        if (!isPremium) ...[
                          SizedBox(height: 30.h),
                          _buildPremiumBanner(),
                        ],
                        SizedBox(height: 30.h),
                        _buildTransformationData(),
                        SizedBox(height: 30.h),
                        _buildProgressSection(),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
          ),
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
            onTap: () => setState(() => _selectedTab = 3),
            child: CircleAvatar(
              radius: 20.r,
              backgroundColor: const Color(0xFF06C44F),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/genderWOMAN.png',
                  width: 40.w,
                  height: 40.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hoşgeldin',
                style: GoogleFonts.montserrat(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0D0D0D),
                  height: 1.5,
                  letterSpacing: -0.132.sp,
                ),
              ),
              Text(
                'Sinem',
                style: GoogleFonts.montserrat(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0D0D0D),
                  height: 1.5,
                  letterSpacing: -0.22.sp,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsView(),
                ),
              );
            },
            child: Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: SvgPicture.asset(
                'assets/images/Notification_Icon.svg',
                width: 12.sp,
                height: 12.sp,
                colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
              ),
            ),
          ),
          if (isPremium) ...[
            SizedBox(width: 8.w),
            Container(
              width: 110.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: const Color(0xFFEFCE37),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/Crown_Premium.svg',
                    width: 24.sp,
                    height: 24.sp,
                    colorFilter: const ColorFilter.mode(Color(0xFFFDFDFD), BlendMode.srcIn),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Premium',
                    style: GoogleFonts.montserrat(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFFDFDFD),
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
  Widget _buildDaySelector() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_days.length, (i) {
          final bool isActive = _selectedDay == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedDay = i),
            child: Container(
              width: 40.w,
              padding: EdgeInsets.symmetric(vertical: 6.h),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF06C44F) : Colors.transparent,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _days[i]['num']!,
                    style: isActive
                        ? GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: -0.176.sp,
                            height: 1.2,
                          )
                        : GoogleFonts.montserrat(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            letterSpacing: -0.176.sp,
                            height: 1.2,
                          ),
                  ),
                  Text(
                    _days[i]['letter']!,
                    style: isActive
                        ? GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: -0.176.sp,
                            height: 1.2,
                          )
                        : GoogleFonts.montserrat(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            letterSpacing: -0.176.sp,
                            height: 1.2,
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
  Widget _buildExerciseCard({
    required String imagePath,
    required String title,
    required String category,
    required double progress,
    required String progressText,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 23.w),
      child: Container(
        width: 345.w,
        height: 103.h,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFEBEBEB)),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 10.w,
              top: 9.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      width: 97.w,
                      height: 86.h,
                      color: const Color(0xFFF0F0F0),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Center(
                          child: Icon(
                            Icons.fitness_center,
                            color: const Color(0xFF06C44F),
                            size: 32.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 11.w),
                  SizedBox(
                    width: 213.w,
                    height: 86.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 168.w,
                              child: Text(
                                title,
                                style: GoogleFonts.montserrat(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  letterSpacing: -0.176.sp,
                                ),
                              ),
                            ),
                            SvgPicture.asset(
                              'assets/images/Exercise_Forward_Icon.svg',
                              width: 22.w,
                              height: 22.h,
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 53.w,
                              height: 17.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF5B5B5B,
                                ).withValues(alpha: 0.77),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Text(
                                category,
                                style: GoogleFonts.montserrat(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  letterSpacing: -0.11.sp,
                                ),
                              ),
                            ),
                            Text(
                              progressText,
                              style: GoogleFonts.montserrat(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                letterSpacing: -0.154.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Stack(
                          children: [
                            Container(
                              width: 213.w,
                              height: 5.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFFDDDDDD),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                            ),
                            Container(
                              width: 213.w * progress,
                              height: 5.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFF00EF5B),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(4.r),
                                  bottomRight: Radius.circular(4.r),
                                ),
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
          ],
        ),
      ),
    );
  }
  Widget _buildProgressBadge() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 74.w,
            height: 74.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 74.w,
                  height: 74.w,
                  child: CircularProgressIndicator(
                    value: 0.86,
                    strokeWidth: 5.w,
                    backgroundColor: const Color.fromRGBO(165, 165, 165, 0.32),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF06C44F),
                    ),
                  ),
                ),
                Text(
                  '%86',
                  style: GoogleFonts.nunito(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF06C44F),
                    letterSpacing: -0.154.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 18.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: 'Bugünkü antrenmanının '),
                      TextSpan(
                        text: '%86',
                        style: GoogleFonts.nunito(
                          color: const Color(0xFF06C44F),
                        ),
                      ),
                      const TextSpan(text: '\'sını tamamladın!'),
                    ],
                  ),
                  style: GoogleFonts.nunito(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF100F0F),
                    letterSpacing: -0.154.sp,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Kısa bir mola ver, nefesini toparla ve güçlü bir şekilde devam et.',
                  style: GoogleFonts.nunito(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF434343),
                    height: 1.3,
                    letterSpacing: -0.132.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildCompletedDays() {
    final completedDays = [1, 2, 3];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        width: 342.w,
        height: 126.h,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFEBEBEB)),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 11.w,
              top: 15.h,
              child: SizedBox(
                width: 320.w,
                height: 16.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Tamamlanan Günler',
                      style: GoogleFonts.montserrat(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        letterSpacing: -0.11.sp,
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/Completed_Days_Back_Icon.svg',
                          width: 16.sp,
                          height: 16.sp,
                        ),
                        SizedBox(width: 8.w),
                        SvgPicture.asset(
                          'assets/images/Completed_Days_Forward_Icon.svg',
                          width: 16.sp,
                          height: 16.sp,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 27.w,
              top: 43.h,
              child: SizedBox(
                width: 288.w,
                height: 83.h,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(7, (i) {
                    final bool done = completedDays.contains(i + 1);
                    final String dayNum = (i + 1).toString().padLeft(2, '0');
                    return Row(
                      children: [
                        _buildDayBar(done: done, dayNum: dayNum),
                        if (i < 6) SizedBox(width: 6.w),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildDayBar({required bool done, required String dayNum}) {
    return Container(
      width: 36.w,
      height: 84.h,
      decoration: BoxDecoration(
        color: done
            ? const Color(0xFF06C44F)
            : const Color(0xFF06C44F).withValues(alpha: 0.16),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6.r),
          topRight: Radius.circular(6.r),
        ),
      ),
      child: done
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/Completed_Day_Flame_Icon.svg',
                    width: 10.w,
                    height: 13.57.h,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    dayNum,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      letterSpacing: -0.11.sp,
                    ),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 65.5.h,
                  child: Text(
                    dayNum,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF100F0F),
                      letterSpacing: -0.11.sp,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
  Widget _buildPremiumBanner() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        width: 342.w,
        height: 124.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF20C729), Color(0xFF063527)],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/Premium_Upgrade_Icon.svg',
                width: 32.w,
                height: 32.h,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Premium\'a Geç',
                      style: GoogleFonts.montserrat(
                        fontSize: 16.6.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: -0.11.sp,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Tüm gelişmiş özelliklerin kilidini aç.',
                      style: GoogleFonts.montserrat(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: -0.11.sp,
                      ),
                    ),
                    SizedBox(height: 13.h),
                    Container(
                      width: 217.w,
                      height: 44.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF20C729), Color(0xFF063527)],
                        ).createShader(bounds),
                        blendMode: BlendMode.srcIn,
                        child: Text(
                          'Planı Yükselt',
                          style: GoogleFonts.montserrat(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.11.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildTransformationData() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        width: 342.w,
        padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dönüşüm Verileri',
              style: GoogleFonts.montserrat(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                letterSpacing: -0.176.sp,
              ),
            ),
            SizedBox(height: 15.h),
            Container(
              width: 320.w,
              height: 127.h,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color.fromRGBO(235, 235, 235, 0.55),
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 11.w,
                    top: 15.h,
                    child: SizedBox(
                      width: 105.5.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Toplam',
                            style: GoogleFonts.montserrat(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              letterSpacing: -0.11.sp,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Kilo Değişimi',
                            style: GoogleFonts.montserrat(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              letterSpacing: -0.11.sp,
                            ),
                          ),
                          SizedBox(height: 13.h),
                          SizedBox(
                            width: 71.2.w,
                            height: 71.2.h,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 71.2.w,
                                  height: 71.2.h,
                                  child: CustomPaint(
                                    painter: ArchProgressPainter(
                                      progress: 0.6,
                                      backgroundColor: const Color.fromRGBO(
                                        165,
                                        165,
                                        165,
                                        0.32,
                                      ),
                                      progressColor: const Color(0xFF06C44F),
                                      strokeWidth: 5.w,
                                    ),
                                  ),
                                ),
                                Text(
                                  '-3.4',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF06C44F),
                                    letterSpacing: -0.11.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 140.w,
                    top: 15.h,
                    child: SizedBox(
                      width: 163.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLinearProgress(
                            title: 'Yağ Oranı Değişimi',
                            color: const Color(0xFFFF383C),
                            percentage: 0.61,
                            valueStr: '(-4%)',
                          ),
                          SizedBox(height: 12.h),
                          _buildLinearProgress(
                            title: 'Kas Kütlesi Artışı',
                            color: const Color(0xFFFFCC00),
                            percentage: 0.61,
                            valueStr: '(+2.1)',
                          ),
                          SizedBox(height: 12.h),
                          _buildLinearProgress(
                            title: 'Bel Çevresi Değişimi',
                            color: const Color(0xFF6155F5),
                            percentage: 0.61,
                            valueStr: '(-3.2)',
                          ),
                        ],
                      ),
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
  Widget _buildLinearProgress({
    required String title,
    required Color color,
    required double percentage,
    required String valueStr,
  }) {
    return SizedBox(
      width: 163.w,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  letterSpacing: -0.11.sp,
                ),
              ),
              SizedBox(height: 5.h),
              Stack(
                children: [
                  Container(
                    width: 133.w,
                    height: 7.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E2E2),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  Container(
                    width: 133.w * percentage,
                    height: 7.h,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            valueStr,
            style: GoogleFonts.montserrat(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: color,
              letterSpacing: -0.11.sp,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildProgressSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'İlerleme Durumun',
                style: GoogleFonts.montserrat(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  letterSpacing: -0.176.sp,
                ),
              ),
              SvgPicture.asset(
                'assets/images/Progress_Status_Icon.svg',
                width: 24.sp,
                height: 24.sp,
                colorFilter: const ColorFilter.mode(Color(0xFF4E4A4A), BlendMode.srcIn),
              ),
            ],
          ),
          SizedBox(height: 11.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 206.w,
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildProgressCard(
                          label: 'Toplam Aktivite',
                          value: '12',
                          isHighlight: false,
                          assetPath: 'assets/images/Total_Activity_Icon.svg',
                        ),
                        SizedBox(width: 4.w),
                        _buildProgressCard(
                          label: 'Yakılan Kalori',
                          value: '40 Kcal',
                          isHighlight: true,
                          assetPath: 'assets/images/Burned_Calories_Icon.svg',
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        _buildProgressCard(
                          label: 'Verilen Kilo',
                          value: '-2 Kg',
                          isHighlight: true,
                          assetPath: 'assets/images/Weight_Lost_Icon.svg',
                        ),
                        SizedBox(width: 4.w),
                        _buildProgressCard(
                          label: 'Serilerin',
                          value: '3 Gün',
                          isHighlight: false,
                          assetPath: 'assets/images/Streak_Icon.svg',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 11.w),
              Container(
                width: 125.w,
                height: 188.h,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: const Color(0xFF06C44F),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    SizedBox(
                      width: 125.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 22.h),
                          Text(
                            'Başarı Yüzden',
                            style: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: -0.15.sp,
                            ),
                          ),
                          SizedBox(height: 15.h),
                          Container(
                            width: 60.w,
                            height: 60.h,
                            decoration: const BoxDecoration(
                              color: Color(0xFFCBF6DB),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '%24',
                              style: GoogleFonts.montserrat(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF008B35),
                                letterSpacing: -0.19.sp,
                              ),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'En iyini yaptığını bil. ✨',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              letterSpacing: -0.11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 38.w,
                      top: 142.h,
                      child: SvgPicture.asset(
                        'assets/images/Success_Trophy_Icon.svg',
                        width: 50.sp,
                        height: 46.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildProgressCard({
    required String label,
    required String value,
    required bool isHighlight,
    required String assetPath,
  }) {
    return Container(
      width: 101.w,
      height: 90.h,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: isHighlight ? const Color(0xFFD4FFE4) : const Color(0xFFFCFCFC),
        border: isHighlight ? null : Border.all(color: const Color(0xFFEBEBEB)),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (assetPath.endsWith('.svg'))
            SvgPicture.asset(
              assetPath,
              width: 24.w,
              height: 24.h,
              fit: BoxFit.contain,
            )
          else
            Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: const Color(0xFF06C44F),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Image.asset(
                assetPath,
                width: 14.sp,
                height: 14.sp,
                color: Colors.white,
              ),
            ),
          const Spacer(),
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              letterSpacing: -0.11.sp,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              letterSpacing: -0.176.sp,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildBottomNav() {
    final tabs = [
      {
        'label': 'Anasayfa',
        'icon': 'assets/images/Nav_Home_Icon.svg',
      },
      {
        'label': 'Antrenman',
        'icon': 'assets/images/Nav_Workout_Icon.svg',
      },
      {
        'label': 'İlerleme',
        'icon': 'assets/images/Nav_Progress_Icon.svg',
      },
      {
        'label': 'Profil',
        'icon': 'assets/images/Nav_Profile_Icon.svg',
      },
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
            onTap: () => setState(() => _selectedTab = i),
            child: SizedBox(
              width: 95.w,
              height: 70.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if ((tabs[i]['icon'] as String).endsWith('.svg'))
                    SvgPicture.asset(
                      tabs[i]['icon'] as String,
                      width: 24.sp,
                      height: 24.sp,
                      colorFilter: ColorFilter.mode(
                        isActive ? const Color(0xFF06C44F) : const Color(0xFF323232),
                        BlendMode.srcIn,
                      ),
                    )
                  else
                    Image.asset(
                      tabs[i]['icon'] as String,
                      width: 24.sp,
                      height: 24.sp,
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
class ArchProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;
  ArchProgressPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });
  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    Paint progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    Rect rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height,
    );
    double pi = 3.141592653589793;
    canvas.drawArc(rect, pi, pi, false, backgroundPaint);
    double sweepAngle = pi * progress;
    double startAngle = pi + (pi - sweepAngle) / 2;
    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }
  @override
  bool shouldRepaint(covariant ArchProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
