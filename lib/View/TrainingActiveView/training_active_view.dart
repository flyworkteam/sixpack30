import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Core/Data/workout_data.dart';
import '../../Riverpod/Controllers/stats_provider.dart';
import '../../Riverpod/Controllers/user_provider.dart';
import './video_player_widget.dart';
import '../BreakView/break_view.dart';
import '../MotivationView/motivation_view.dart';
import '../../Core/Services/workout_progress_service.dart';
import '../../Riverpod/Controllers/workout_progress_provider.dart';

class TrainingActiveView extends ConsumerStatefulWidget {
  final String gender;
  final int initialIndex;
  final int initialSetIndex;
  final List<ExerciseInfo> exercises;
  final int dayNumber;
  final String title;

  const TrainingActiveView({
    super.key,
    this.gender = 'woman',
    required this.initialIndex,
    this.initialSetIndex = 0,
    required this.exercises,
    required this.dayNumber,
    this.title = 'Antrenman',
  });
  @override
  ConsumerState<TrainingActiveView> createState() => _TrainingActiveViewState();
}

class _TrainingActiveViewState extends ConsumerState<TrainingActiveView> {
  double progress = 0.0;
  bool isPlaying = true;
  late int currentIndex;
  int currentSetIndex = 0;
  late List<ExerciseInfo> exercises;
  
  Timer? _timer;
  int _totalSeconds = 0;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    currentSetIndex = widget.initialSetIndex;
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
    
    
    ref.read(workoutProgressProvider.notifier).saveProgress(WorkoutProgress(
      dayNumber: widget.dayNumber,
      exerciseIndex: currentIndex,
      setIndex: currentSetIndex,
      title: widget.title,
      timestamp: DateTime.now(),
    ));
  }

  int _extractSeconds(String setsText) {
    final RegExp regExp = RegExp(r'(\d+)\s*(Saniye|sn)', caseSensitive: false);
    final match = regExp.firstMatch(setsText);
    if (match != null) {
      return int.parse(match.group(1)!);
    }
    return 45;
  }

  int _extractSets(String setsText) {
    final RegExp regExp = RegExp(r'(\d+)\s*Set', caseSensitive: false);
    final match = regExp.firstMatch(setsText);
    if (match != null) {
      return int.parse(match.group(1)!);
    }
    return 1;
  }

  int _extractRestSeconds(String restText) {
    final RegExp regExp = RegExp(r'(\d+)', caseSensitive: false);
    final matches = regExp.allMatches(restText);
    if (matches.isNotEmpty) {
      return int.parse(matches.last.group(1)!);
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
    final currentExercise = exercises[currentIndex];
    final totalSets = _extractSets(currentExercise.sets);

    if (currentSetIndex < totalSets - 1) {
      _timer?.cancel();
      bool wasPlaying = isPlaying;
      
      final restSeconds = _extractRestSeconds(currentExercise.rest);
      
      
      ref.read(workoutProgressProvider.notifier).saveProgress(WorkoutProgress(
        dayNumber: widget.dayNumber,
        exerciseIndex: currentIndex,
        setIndex: currentSetIndex + 1,
        title: widget.title,
        timestamp: DateTime.now(),
      ));
      
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BreakView(durationInSeconds: restSeconds),
        ),
      );
      
      if (mounted) {
        setState(() {
          currentSetIndex++;
          isPlaying = wasPlaying;
          _initializeTimer();
        });
      }
    } else if (currentIndex < exercises.length - 1) {
      _timer?.cancel();
      bool wasPlaying = isPlaying;
      
      int halfWayMark = (exercises.length ~/ 2) - 1;
      if (currentIndex == halfWayMark) {
        final user = ref.read(userProfileProvider).value;
        final firebaseUser = FirebaseAuth.instance.currentUser;
        final String firebaseDisplayName = firebaseUser?.displayName ?? '';
        final String firebaseEmailPart = firebaseUser?.email != null 
            ? (firebaseUser!.email!.contains('privaterelay.appleid.com') ? '' : firebaseUser!.email!.split('@').first) 
            : '';
        final String backendName = (user?.name != null && user!.name!.trim().isNotEmpty) ? user!.name!.trim() : '';
        final String userName = backendName.isNotEmpty 
            ? backendName 
            : (firebaseDisplayName.isNotEmpty 
                ? firebaseDisplayName 
                : (firebaseEmailPart.isNotEmpty 
                    ? firebaseEmailPart 
                    : 'Kullanıcı'));

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
        final restSeconds = _extractRestSeconds(currentExercise.rest);
        
        
        ref.read(workoutProgressProvider.notifier).saveProgress(WorkoutProgress(
          dayNumber: widget.dayNumber,
          exerciseIndex: currentIndex + 1,
          setIndex: 0,
          title: widget.title,
          timestamp: DateTime.now(),
        ));
        
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BreakView(durationInSeconds: restSeconds),
          ),
        );
      }
      
      if (mounted) {
        setState(() {
          currentIndex++;
          currentSetIndex = 0;
          isPlaying = wasPlaying;
          _initializeTimer();
        });
      }
    } else {
      _finishWorkout();
    }
  }

  void _finishWorkout() async {
    try {
      
      await ref.read(statsProvider.notifier).completeDay(widget.dayNumber);
    } catch (e) {
      debugPrint("Error completing workout: $e");
    }
    
    final user = ref.read(userProfileProvider).value;
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final String firebaseDisplayName = firebaseUser?.displayName ?? '';
    final String firebaseEmailPart = firebaseUser?.email != null 
        ? (firebaseUser!.email!.contains('privaterelay.appleid.com') ? '' : firebaseUser!.email!.split('@').first) 
        : '';
    final String backendName = (user?.name != null && user!.name!.trim().isNotEmpty) ? user!.name!.trim() : '';
    final String userName = backendName.isNotEmpty 
        ? backendName 
        : (firebaseDisplayName.isNotEmpty 
            ? firebaseDisplayName 
            : (firebaseEmailPart.isNotEmpty 
                ? firebaseEmailPart 
                : 'Kullanıcı'));
    
    if (mounted) {
      
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MotivationView(
            userName: userName,
            completedExercises: exercises.length,
            activeMinutes: exercises.length * 2,
            isFinal: true,
          ),
        ),
      );
      
      
      await ref.read(workoutProgressProvider.notifier).clearProgress();
      
      if (mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).popUntil((route) => route.isFirst || route.settings.name == '/');
      }
    }
  }
  void _prevExercise() {
    if (currentSetIndex > 0) {
      setState(() {
        currentSetIndex--;
        _initializeTimer();
      });
    } else if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        currentSetIndex = 0;
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
                  videoUrl: exercises[currentIndex].getVideoPath(widget.gender),
                  placeholderUrl: exercises[currentIndex].getImagePath(widget.gender),
                  isPlaying: isPlaying,
                ),
              ),
            ),
            Positioned(
              left: 24.w,
              top: MediaQuery.of(context).padding.top + 10.h,
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
              bottom: 0,
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
                          fontWeight: FontWeight.w700,
                          fontSize: 22.sp,
                          color: const Color(0xFF000000),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 75.h,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildProgressBar(),
                          SizedBox(height: 15.h),
                          _buildTimerRow(),
                          SizedBox(height: 8.h),
                          Text(
                            'REPS SET ${currentSetIndex + 1} OF ${_extractSets(exercises[currentIndex].sets)}',
                            style: GoogleFonts.montserrat(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF7E8896),
                              height: 20 / 16,
                            ),
                          ),
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
                          if (currentIndex < exercises.length - 1) ...[
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
                                          child: exercises[currentIndex + 1].getImagePath(widget.gender).startsWith('http')
                                              ? Image.network(
                                                  exercises[currentIndex + 1].getImagePath(widget.gender),
                                                  width: 38.w,
                                                  height: 28.h,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_,__,___) => Container(width: 38.w, height: 28.h, color: Colors.grey[300]),
                                                )
                                              : Image.asset(
                                                  exercises[currentIndex + 1].getImagePath(widget.gender),
                                                  width: 38.w,
                                                  height: 28.h,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_,__,___) => Container(width: 38.w, height: 28.h, color: Colors.grey[300]),
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
                height: 8.h,
                width: totalWidth,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              Container(
                height: 8.h,
                width: totalWidth * progress.clamp(0.0, 1.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF00EF5B),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              Positioned(
                left: (totalWidth * progress.clamp(0.0, 1.0)) - 6.w,
                child: Container(
                  width: 12.w,
                  height: 12.w,
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 48.sp,
            color: const Color(0xFF00EF5B),
            height: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildControlsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _prevExercise,
          child: Container(
            width: 45.w,
            height: 45.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Icon(Icons.keyboard_double_arrow_left_rounded, color: const Color(0xFF101010), size: 24.sp),
          ),
        ),
        SizedBox(width: 34.w),
        GestureDetector(
          onTap: _togglePlayPause,
          child: Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: const Color(0xFF00EF5B),
              borderRadius: BorderRadius.circular(12.r),
            ),
            alignment: Alignment.center,
            child: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: Colors.white,
              size: 36.sp,
            ),
          ),
        ),
        SizedBox(width: 34.w),
        GestureDetector(
          onTap: _nextExercise,
          child: Container(
            width: 45.w,
            height: 45.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Icon(
              currentIndex == exercises.length - 1 ? Icons.check_rounded : Icons.keyboard_double_arrow_right_rounded,
              color: const Color(0xFF101010),
              size: 24.sp,
            ),
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
