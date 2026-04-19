import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Riverpod/Controllers/locale_provider.dart';
import '../../Core/Localization/translations.dart';
import 'package:six_pack_30/Riverpod/Controllers/user_provider.dart';
import 'package:six_pack_30/Riverpod/Controllers/stats_provider.dart';
import 'package:six_pack_30/Riverpod/Controllers/workout_provider.dart';
import 'package:six_pack_30/Riverpod/Controllers/premium_provider.dart';
import 'package:six_pack_30/Core/Data/workout_data.dart';
import '../ProfileView/profile_view.dart';
import '../ProgressView/progress_view.dart';
import '../TrainingView/training_view.dart';
import '../NotificationsView/notifications_view.dart';
import '../PaywallView/paywall_view.dart';
import '../TrainingDetailView/training_detail_view.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});
  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}
class _HomeViewState extends ConsumerState<HomeView> {
  bool isPremium = false;
  int _selectedTab = 0;
  int _selectedDay = 0;
  late final List<Map<String, String>> _days;
  int _completedDaysPage = 0;

  @override
  void initState() {
    super.initState();
    _days = _generateCurrentWeek('tr');
    _selectedDay = DateTime.now().weekday - 1;
  }

  List<Map<String, String>> _generateCurrentWeek(String langCode) {
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final List<String> letters = Translations.translate('day_initials', langCode).split(',');
    
    return List.generate(7, (i) {
      final date = firstDayOfWeek.add(Duration(days: i));
      return {
        'num': date.day.toString(),
        'letter': letters[i],
      };
    });
  }
  @override
  Widget build(BuildContext context) {
    final userProfileValue = ref.watch(userProfileProvider);
    final statsValue = ref.watch(statsProvider);
    final langCode = ref.watch(localeProvider).languageCode;
    final user = userProfileValue.value;
    final stats = statsValue.value;

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
                        _buildDaySelector(langCode),
                        SizedBox(height: 30.h),
                        _buildSectionTitle(Translations.translate('daily_workout', langCode)),
                        SizedBox(height: 18.h),
                        _buildWorkoutCard(),
                        if (stats != null && stats.recentExercises.isNotEmpty) ...[
                          SizedBox(height: 30.h),
                          _buildSectionTitle(Translations.translate('continue_where_left', langCode)),
                          SizedBox(height: 20.h),
                          ...stats.recentExercises.map((ex) => Padding(
                                padding: EdgeInsets.only(bottom: 15.h, left: 24.w, right: 24.w),
                                child: _buildExerciseCard(
                                  imagePath: ex.imagePath ?? 'assets/images/Gemini_Generated_Image_wgw42fwgw42fwgw4.png',
                                  title: ex.title,
                                  category: ex.category,
                                  progress: ex.progress,
                                  progressText: ex.progressText,
                                ),
                              )),
                        ],
                        SizedBox(height: 30.h),
                        _buildProgressBadge(),
                        SizedBox(height: 30.h),
                        _buildSectionTitle(Translations.translate('completed_days', langCode)),
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
    final userProfile = ref.watch(userProfileProvider);
    final statsValue = ref.watch(statsProvider);
    final langCode = ref.watch(localeProvider).languageCode;
    final user = userProfile.value;
    final stats = statsValue.value;
    
    final bool isLoading = userProfile.isLoading && user == null;
    final bool isGuest = user == null && !userProfile.isLoading;
    
    final String displayName = isLoading 
        ? Translations.translate('loading', langCode) 
        : (isGuest ? Translations.translate('guest', langCode) : (user?.name ?? 'Kullanıcı'));
        
    final bool isMan = !isGuest && user != null && user.questionnaire?.gender == 'man';
    final String? userPhoto = user?.photoUrl;
    final String defaultProfileImage = 'assets/images/iconstack.io - (User Circle Regular).png';
    isPremium = isGuest ? false : (user?.isPremium ?? false);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => setState(() => _selectedTab = 3),
            child: CircleAvatar(
              radius: 20.r,
              backgroundColor: const Color(0xFFF3F3F3),
              child: ClipOval(
                child: userPhoto != null 
                  ? Image.network(
                      userPhoto,
                      width: 40.w,
                      height: 40.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.person_rounded,
                        size: 24.sp,
                        color: const Color(0xFFADADAD),
                      ),
                    )
                  : Icon(
                      Icons.person_rounded,
                      size: 24.sp,
                      color: const Color(0xFFADADAD),
                    ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Translations.translate('welcome_back', langCode),
                style: GoogleFonts.montserrat(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0D0D0D),
                  height: 1.5,
                  letterSpacing: -0.132.sp,
                ),
              ),
              Text(
                displayName,
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
  Widget _buildDaySelector(String langCode) {
    final weekDays = _generateCurrentWeek(langCode);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(weekDays.length, (i) {
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
                    weekDays[i]['num']!,
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
                    weekDays[i]['letter']!,
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
    final langCode = ref.watch(localeProvider).languageCode;
    final workoutsAsync = ref.watch(workoutProvider);
    final statsAsync = ref.watch(statsProvider);
    final premiumAsync = ref.watch(premiumProvider);
    
    final workoutList = workoutsAsync.value;
    final stats = statsAsync.value;
    final bool isPremiumUser = premiumAsync.value ?? false;
    final List<int> completedDays = stats?.completedDays ?? [];
    
    int maxCompleted = completedDays.isEmpty ? 0 : completedDays.reduce((a, b) => a > b ? a : b);
    int currentDay = maxCompleted + 1;
    if (currentDay > 30) currentDay = 30;

    final workoutData = StaticWorkoutData.getWorkoutForDay(currentDay);
    
    final workoutFromApi = workoutList?.where((w) => w.id == currentDay).firstOrNull;
    
    final String rawTitle = workoutFromApi?.title ?? workoutData.title;
    final String workoutTitle = Translations.translateWorkoutTitle(rawTitle, langCode);
    final int exerciseCount = workoutFromApi?.exerciseCount ?? workoutData.exercises.length;
    final int duration = workoutFromApi?.durationMinutes ?? 10;
    final int kcal = workoutFromApi?.calories ?? 250;
    
    final bool isLocked = currentDay > 3 && !isPremiumUser;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: GestureDetector(
        onTap: () {
          if (isLocked) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const PaywallView()));
          } else {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => TrainingDetailView(
                dayNumber: currentDay, 
                title: workoutTitle, 
                exercises: workoutData.exercises,
              ))
            );
          }
        },
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
                          '${currentDay}. ${Translations.translate('workout_day', langCode)}: $workoutTitle',
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
                              exerciseCount == 0 ? Translations.translate('rest', langCode) : '$exerciseCount ${Translations.translate('exercises_count', langCode)}',
                              'assets/images/Exercise_Body_Icon.svg',
                            ),
                            _buildWorkoutBadge(
                              '${Translations.translate('focus_area', langCode)}:${Translations.translate('abs', langCode)}',
                              'assets/images/Abs_Zone_Icon.svg',
                            ),
                            _buildWorkoutBadge(
                              '$duration ${Translations.translate('minutes', langCode)}',
                              'assets/images/Duration_Badge_Icon.svg',
                            ),
                            _buildWorkoutBadge(
                              '$kcal Kcal',
                              'assets/images/Calorie_Badge_Icon.svg',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 110.w),
                ],
              ),
            ),
            Positioned(
              right: -10.w,
              bottom: 0,
              child: Opacity(
                opacity: 1.0,
                child: Image.asset(
                  'assets/images/Adsız tasarım-6.png',
                  width: 127.8.w,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildWorkoutBadge(String label, String assetPath) {
    return Container(
      constraints: BoxConstraints(maxWidth: 100.w),
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
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
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF100F0F),
                height: 1.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
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
                      child: imagePath.startsWith('http')
                        ? Image.network(
                            imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Center(
                              child: Icon(
                                Icons.fitness_center,
                                color: const Color(0xFF06C44F),
                                size: 32.sp,
                              ),
                            ),
                          )
                        : Center(
                            child: Icon(
                              Icons.fitness_center,
                              color: const Color(0xFF06C44F),
                              size: 32.sp,
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
    final userProfile = ref.watch(userProfileProvider);
    final stats = ref.watch(statsProvider).value;
    final langCode = ref.watch(localeProvider).languageCode;
    final bool isGuest = userProfile.value == null;
    
    final todayStr = DateTime.now().toIso8601String().split('T')[0];
    final bool finishedToday = stats?.completedAtDates.contains(todayStr) ?? false;
    
    final String percentage = isGuest ? '86' : (finishedToday ? '100' : '0');
    final double progressVal = isGuest ? 0.86 : (finishedToday ? 1.0 : 0.0);

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
                    value: progressVal,
                    strokeWidth: 5.w,
                    backgroundColor: const Color.fromRGBO(165, 165, 165, 0.32),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF06C44F),
                    ),
                  ),
                ),
                Text(
                  '%$percentage',
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
                      TextSpan(text: Translations.translate('daily_goal_message_start', langCode)),
                      TextSpan(
                        text: '%$percentage',
                        style: GoogleFonts.nunito(
                          color: const Color(0xFF06C44F),
                        ),
                      ),
                      TextSpan(text: Translations.translate('daily_goal_message_end', langCode)),
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
                  Translations.translate('daily_goal_subtext', langCode),
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
    final langCode = ref.watch(localeProvider).languageCode;
    final statsAsync = ref.watch(statsProvider);
    final stats = statsAsync.value;
    final List<int> completedDays = stats?.completedDays ?? [];

    final now = DateTime.now();
    final int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final int totalPages = (daysInMonth / 7).ceil();

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
                      Translations.translate('completed_days', langCode),
                      style: GoogleFonts.montserrat(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        letterSpacing: -0.11.sp,
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_completedDaysPage > 0) {
                              setState(() => _completedDaysPage--);
                            }
                          },
                          child: SvgPicture.asset(
                            'assets/images/Completed_Days_Back_Icon.svg',
                            width: 16.sp,
                            height: 16.sp,
                            colorFilter: ColorFilter.mode(
                              _completedDaysPage > 0 ? Colors.black : Colors.grey,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: () {
                            if (_completedDaysPage < totalPages - 1) {
                              setState(() => _completedDaysPage++);
                            }
                          },
                          child: SvgPicture.asset(
                            'assets/images/Completed_Days_Forward_Icon.svg',
                            width: 16.sp,
                            height: 16.sp,
                            colorFilter: ColorFilter.mode(
                              _completedDaysPage < totalPages - 1 ? Colors.black : Colors.grey,
                              BlendMode.srcIn,
                            ),
                          ),
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
                    final int dayIndex = (_completedDaysPage * 7) + i + 1;
                    if (dayIndex > daysInMonth) return const SizedBox.shrink();

                    final bool done = completedDays.contains(dayIndex);
                    final String dayNum = dayIndex.toString().padLeft(2, '0');
                    
                    return Row(
                      children: [
                        _buildDayBar(done: done, dayNum: dayNum),
                        if (i < 6 && dayIndex < daysInMonth) SizedBox(width: 6.w),
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
    final langCode = ref.watch(localeProvider).languageCode;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PaywallView()),
          );
        },
        child: Container(
        width: 342.w,
        height: 124.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          gradient: const LinearGradient(
            begin: Alignment(0.0, -1.0),
            end: Alignment(0.0, 1.0),
            colors: [Color(0xFF20C729), Color(0xFF063527)],
            stops: [-0.0645, 1.1124],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: SvgPicture.asset(
                            'assets/images/Premium_Upgrade_Icon.svg',
                            width: 32.w,
                            height: 32.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          Translations.translate('premium_upgrade', langCode),
                          style: GoogleFonts.montserrat(
                            fontSize: 16.67.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: -0.11.sp,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Padding(
                      padding: EdgeInsets.only(left: 40.w),
                      child: Text(
                        Translations.translate('premium_upgrade_desc', langCode) ?? 'Tüm gelişmiş özelliklerin kilidini aç.',
                        style: GoogleFonts.montserrat(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          letterSpacing: -0.11.sp,
                          height: 1.25,
                        ),
                      ),
                    ),
                    SizedBox(height: 13.h),
                    Padding(
                      padding: EdgeInsets.only(left: 40.w),
                      child: Container(
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
                            Translations.translate('plan_upgrade', langCode),
                            style: GoogleFonts.montserrat(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.11.sp,
                            ),
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
    ),
    );
  }
  Widget _buildTransformationData() {
    final langCode = ref.watch(localeProvider).languageCode;
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
              Translations.translate('transformation_data', langCode),
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
                            Translations.translate('total', langCode) ?? 'Toplam',
                            style: GoogleFonts.montserrat(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              letterSpacing: -0.11.sp,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            Translations.translate('weight_change', langCode) ?? 'Kilo Değişimi',
                            style: GoogleFonts.montserrat(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              letterSpacing: -0.11.sp,
                            ),
                          ),
                          SizedBox(height: 13.h),
                          Consumer(
                            builder: (context, ref, child) {
                              final statsAsync = ref.watch(statsProvider);
                              final stats = statsAsync.value;
                              
                              final double kiloProgress = (stats == null || stats.totalActivity == 0) ? 0.0 : 0.6;
                              final String kiloValue = stats == null ? '0.0' : (stats.weightLost == 0 ? '0.0' : '-${stats.weightLost}');

                                  return SizedBox(
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
                                              progress: kiloProgress,
                                              backgroundColor: const Color.fromRGBO(
                                                165,
                                                165,
                                                155,
                                                0.32,
                                              ),
                                              progressColor: const Color(0xFF06C44F),
                                              strokeWidth: 5.w,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          kiloValue,
                                          style: GoogleFonts.montserrat(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF06C44F),
                                            letterSpacing: -0.11.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 130.w,
                    top: 15.h,
                    right: 15.w,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Consumer(
                            builder: (context, ref, child) {
                              final statsAsync = ref.watch(statsProvider);
                              final userStats = statsAsync.value;
                              
                              if (userStats == null) {
                                return Column(
                                  children: [
                                    _buildLinearProgress(title: Translations.translate('fat_rate_change', langCode), color: const Color(0xFFFF383C), percentage: 0, valueStr: '-%0'),
                                    SizedBox(height: 12.h),
                                    _buildLinearProgress(title: Translations.translate('muscle_mass_increase', langCode), color: const Color(0xFFFFCC00), percentage: 0, valueStr: '+0.0 Kg'),
                                    SizedBox(height: 12.h),
                                    _buildLinearProgress(title: Translations.translate('waist_circumference', langCode), color: const Color(0xFF6155F5), percentage: 0, valueStr: '-0.0 cm'),
                                  ],
                                );
                              }

                              final int initialFat = userStats.initialFatRate;
                              final int currentFat = userStats.fatRate;
                              final int fatDiff = initialFat - currentFat;
                              double fatProgress = (fatDiff / 5.0);
                              if (fatProgress.isNaN) fatProgress = 0.0;
                              fatProgress = fatProgress.clamp(0.0, 1.0);
                              final String fatRateStr = '-%$fatDiff';

                              final double initialMuscle = userStats.initialMuscleMass;
                              final double currentMuscle = userStats.muscleMass;
                              final double muscleDiffVal = (currentMuscle - initialMuscle);
                              final String muscleDiff = muscleDiffVal.toStringAsFixed(1);
                              double muscleProgress = (muscleDiffVal / 2.0);
                              if (muscleProgress.isNaN) muscleProgress = 0.0;
                              muscleProgress = muscleProgress.clamp(0.0, 1.0);
                              final String muscleMassStr = '+$muscleDiff Kg';

                              final double weightLost = userStats.weightLost;
                              final double waistDiffVal = weightLost * 1.2;
                              final String waistDiff = waistDiffVal.toStringAsFixed(1);
                              double waistProgress = (weightLost / 10.0);
                              if (waistProgress.isNaN) waistProgress = 0.0;
                              waistProgress = waistProgress.clamp(0.0, 1.0);
                              final String waistChange = '-$waistDiff cm';

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLinearProgress(
                                    title: Translations.translate('fat_rate_change', langCode),
                                    color: const Color(0xFFFF383C),
                                    percentage: fatProgress,
                                    valueStr: fatRateStr,
                                  ),
                                  SizedBox(height: 12.h),
                                  _buildLinearProgress(
                                    title: Translations.translate('muscle_mass_increase', langCode),
                                    color: const Color(0xFFFFCC00),
                                    percentage: muscleProgress,
                                    valueStr: muscleMassStr,
                                  ),
                                  SizedBox(height: 12.h),
                                  _buildLinearProgress(
                                    title: Translations.translate('waist_circumference', langCode),
                                    color: const Color(0xFF6155F5),
                                    percentage: waistProgress,
                                    valueStr: waistChange,
                                  ),
                                ],
                              );
                            },
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
  Widget _buildLinearProgress({
    required String title,
    required Color color,
    required double percentage,
    required String valueStr,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 5.h),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 7.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E2E2),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: percentage,
                    child: Container(
                      height: 7.h,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 8.w),
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
    );
  }
  Widget _buildProgressSection() {
    final langCode = ref.watch(localeProvider).languageCode;
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
                Translations.translate('my_progress_status', langCode),
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
          Consumer(
            builder: (context, ref, child) {
              final statsAsync = ref.watch(statsProvider);
              final userStats = statsAsync.value;
              final langCode = ref.watch(localeProvider).languageCode;
              
              final int completedCount = userStats?.completedDays.length ?? 0;
              final String activityCount = userStats == null ? '0' : (userStats.totalActivity == 0 ? '$completedCount' : '${userStats.totalActivity}');
              
              final double calculatedKcal = completedCount * 250.0;
              final String calories = userStats == null ? '0 Kcal' : '${calculatedKcal.toInt()} Kcal';
              
              final double initialW = userStats?.initialWeight ?? 0;
              final double currentW = userStats?.weight ?? 0;
              double weightDiff = initialW - currentW;
              if (weightDiff < 0) weightDiff = 0;
              final String weightLostStr = userStats == null ? '0 Kg' : '${weightDiff.toStringAsFixed(1)} Kg';
              
              final String streakStr = userStats == null ? '0 ${Translations.translate('days', langCode)}' : '${userStats.streak} ${Translations.translate('days', langCode)}';
              
              final int successVal = userStats == null ? 0 : ((completedCount / 30) * 100).toInt();
              final String successPercent = '%$successVal';

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildProgressCard(
                                label: Translations.translate('total_activity', langCode),
                                value: activityCount,
                                isHighlight: false,
                                assetPath: 'assets/images/Total_Activity_Icon.svg',
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: _buildProgressCard(
                                label: Translations.translate('calories_burned', langCode),
                                value: calories,
                                isHighlight: true,
                                assetPath: 'assets/images/Burned_Calories_Icon.svg',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Expanded(
                              child: _buildProgressCard(
                                label: Translations.translate('weight_lost', langCode),
                                value: weightLostStr,
                                isHighlight: true,
                                assetPath: 'assets/images/Weight_Lost_Icon.svg',
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: _buildProgressCard(
                                label: Translations.translate('streak', langCode),
                                value: streakStr,
                                isHighlight: false,
                                assetPath: 'assets/images/Streak_Icon.svg',
                              ),
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
                                Translations.translate('success_rate', langCode),
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
                                  successPercent,
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
                                Translations.translate('success_message', langCode) ?? 'En iyini yaptığını bil. ✨',
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
              );
            },
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
    final langCode = ref.watch(localeProvider).languageCode;
    final tabs = [
      {
        'label': Translations.translate('home', langCode),
        'icon': 'assets/images/Nav_Home_Icon.svg',
      },
      {
        'label': Translations.translate('training', langCode),
        'icon': 'assets/images/Nav_Workout_Icon.svg',
      },
      {
        'label': Translations.translate('progress', langCode),
        'icon': 'assets/images/Nav_Progress_Icon.svg',
      },
      {
        'label': Translations.translate('profile', langCode),
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
