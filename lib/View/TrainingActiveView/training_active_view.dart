import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Core/Data/workout_data.dart';
import '../../Riverpod/Controllers/stats_provider.dart';
import '../../Riverpod/Controllers/user_provider.dart';
import './video_player_widget.dart';
import '../BreakView/break_view.dart';
import '../MotivationView/motivation_view.dart';

class TrainingActiveView extends StatefulWidget {
  final String gender;
  final int initialIndex;
  final List<ExerciseInfo> exercises;

  final int dayNumber;

  const TrainingActiveView({
    super.key,
    this.gender = 'woman',
    required this.initialIndex,
    required this.exercises,
    required this.dayNumber,
  });
  @override
  State<TrainingActiveView> createState() => _TrainingActiveViewState();
}

class _TrainingActiveViewState extends State<TrainingActiveView> {
  double progress = 0.0;
  bool isPlaying = true;
  late int currentIndex;
  late List<ExerciseInfo> exercises;
  
  Timer? _timer;
  int _totalSeconds = 0;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    exercises = widget.exercises;
    _initializeTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initializeTimer() {
    _timer?.cancel();
    final exercise = exercises[currentIndex];
    _totalSeconds = _extractSeconds(exercise.sets);
    _remainingSeconds = _totalSeconds;
    progress = 0.0;
    if (isPlaying) _startTimer();
  }

  int _extractSeconds(String setsText) {
    final RegExp regExp = RegExp(r'(\d+)\s*(Saniye|sn)', caseSensitive: false);
    final match = regExp.firstMatch(setsText);
    if (match != null) {
      return int.parse(match.group(1)!);
    }
    return 30;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
            progress = _remainingSeconds / _totalSeconds;
          } else {
            _timer?.cancel();
            _nextExercise();
          }
        });
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        _startTimer();
      } else {
        _timer?.cancel();
      }
    });
  }

  void _nextExercise() async {
    if (currentIndex < exercises.length - 1) {
      _timer?.cancel();
      bool wasPlaying = isPlaying;
      
      int halfWayMark = (exercises.length ~/ 2) - 1;
      if (currentIndex == halfWayMark) {
        final container = ProviderScope.containerOf(context);
        final userAsync = container.read(userProfileProvider);
        final userName = userAsync.when(
          data: (user) => user?.name ?? 'Şampiyon',
          loading: () => 'Şampiyon',
          error: (_, __) => 'Şampiyon',
        );

        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MotivationView(
              userName: userName,
              completedExercises: currentIndex + 1,
              activeMinutes: (currentIndex + 1) * 2,
            ),
          ),
        );
      } else {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const BreakView(durationInSeconds: 30),
          ),
        );
      }
      
      if (mounted) {
        setState(() {
          currentIndex++;
          isPlaying = wasPlaying;
          _initializeTimer();
        });
      }
    } else {
      _finishWorkout();
    }
  }

  void _finishWorkout() async {
    final container = ProviderScope.containerOf(context);
    await container.read(statsProvider.notifier).completeDay(widget.dayNumber);
    
    final userAsync = container.read(userProfileProvider);
    final userName = userAsync.when(
      data: (user) => user?.name ?? 'Şampiyon',
      loading: () => 'Şampiyon',
      error: (_, __) => 'Şampiyon',
    );
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tebrikler $userName! Antrenmanı başarıyla tamamladın.'),
          backgroundColor: const Color(0xFF00EF5B),
        ),
      );
      Navigator.of(context).pop();
      Navigator.of(context).popUntil((route) => route.isFirst || route.settings.name == '/'); 
    }
  }
  void _prevExercise() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        _initializeTimer();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: 573.h,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(6.r),
                    bottomRight: Radius.circular(6.r),
                  ),
                ),
                clipBehavior: Clip.hardEdge,
                child: ExerciseVideoPlayer(
                  videoUrl: exercises[currentIndex].videoPath,
                  placeholderUrl: exercises[currentIndex].getImagePath(widget.gender),
                  isPlaying: isPlaying,
                ),
              ),
            ),
            Positioned(
              left: 24.w,
              top: 68.h,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC2C2C2).withValues(alpha: 0.85),
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
            Positioned(
              left: 0,
              right: 0,
              top: 459.h,
              height: 236.h,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFF7FFFA),
                      Color(0xFFFFFFFF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 25.w,
                      top: 23.h,
                      child: Text(
                        exercises[currentIndex].name,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.sp,
                          color: const Color(0xFF000000),
                          height: 22 / 18,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 24.w,
                      right: 24.w,
                      top: 75.h,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildProgressBar(),
                          SizedBox(height: 15.h),
                          _buildTimerRow(),
                          SizedBox(height: 20.h),
                          _buildControlsRow(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 24.w,
              right: 24.w,
              bottom: 35.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      text: '${currentIndex + 1}',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: const Color(0xFF000000),
                        height: 22 / 16,
                      ),
                      children: [
                        TextSpan(
                          text: '/${exercises.length}',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: const Color(0xFF000000),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (currentIndex < exercises.length - 1)
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              'Sıradaki Hareket',
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                                color: const Color(0xFF000000),
                                height: 15 / 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFFFF),
                              border: Border.all(color: const Color(0xFFEBEBEB)),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(3.r),
                                  child: Image.network(
                                    exercises[currentIndex + 1].getImagePath(widget.gender),
                                    width: 29.w,
                                    height: 21.w,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_,__,___) => Container(width: 29.w, height: 21.w, color: Colors.grey[300]),
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Flexible(
                                  child: Text(
                                    exercises[currentIndex + 1].name,
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10.sp,
                                      color: const Color(0xFF100F0F),
                                      height: 12 / 10,
                                    ),
                                    overflow: TextOverflow.ellipsis,
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
          ],
        ),
      ),
    );
  }
  Widget _buildProgressBar() {
    return SizedBox(
      height: 18.h,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double totalWidth = constraints.maxWidth;
          return Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: 12.h,
                width: totalWidth,
                decoration: BoxDecoration(
                  color: const Color(0xFFD5D5D5),
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              Container(
                height: 12.h,
                width: totalWidth * progress.clamp(0.0, 1.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF06C44F),
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              Positioned(
                left: (totalWidth * progress.clamp(0.0, 1.0)) - 9.w,
                child: Container(
                  width: 18.w,
                  height: 18.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF05A642),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTimerRow() {
    final int minutes = _remainingSeconds ~/ 60;
    final int seconds = _remainingSeconds % 60;
    
    final int totalRemainingSeconds = _remainingSeconds + (exercises.length - currentIndex - 1) * 30;
    final int totalMins = totalRemainingSeconds ~/ 60;
    final int totalSecs = totalRemainingSeconds % 60;

    return SizedBox(
      height: 39.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: SizedBox(
                width: 74.w,
                height: 12.h,
                child: Text(
                  'kalan süre ${totalMins.toString().padLeft(2, '0')}:${totalSecs.toString().padLeft(2, '0')}',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w300,
                    fontSize: 8.5.sp,
                    color: const Color(0xFF000000),
                    height: 1.0,
                  ),
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(5.w, 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  minutes.toString().padLeft(2, '0'),
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 32.sp,
                    color: const Color(0xFF07983E),
                    height: 1.0,
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, -2.h),
                  child: Text(
                    ':',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 32.sp,
                      color: const Color(0xFF07983E),
                      height: 1.0,
                    ),
                  ),
                ),
                Text(
                  seconds.toString().padLeft(2, '0'),
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 32.sp,
                    color: const Color(0xFF07983E),
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _prevExercise,
          child: SvgPicture.asset(
            'assets/images/prev_exercise_button.svg',
            width: 32.w,
            height: 32.w,
          ),
        ),
        SizedBox(width: 34.w),
        GestureDetector(
          onTap: _togglePlayPause,
          child: isPlaying
              ? SvgPicture.asset(
                  'assets/images/pause_button_active.svg',
                  width: 45.w,
                  height: 45.w,
                )
              : Container(
                  width: 45.w,
                  height: 45.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF06C44F),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 28.sp,
                  ),
                ),
        ),
        SizedBox(width: 34.w),
        GestureDetector(
          onTap: _nextExercise,
          child: currentIndex == exercises.length - 1
            ? Container(
                width: 60.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF06C44F),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  'BİTİR',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: 10.sp,
                    color: Colors.white,
                  ),
                ),
              )
            : SvgPicture.asset(
                'assets/images/next_exercise_button.svg',
                width: 32.w,
                height: 32.w,
              ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFE0E0E0),
      child: Center(
        child: Icon(
          Icons.fitness_center,
          color: Colors.black26,
          size: 60.sp,
        ),
      ),
    );
  }

  Widget _buildPlaceholderFixedSize() {
    return Container(
      width: 29.w,
      height: 21.w,
      color: Colors.grey,
      child: Icon(Icons.image, size: 12.sp),
    );
  }
}
