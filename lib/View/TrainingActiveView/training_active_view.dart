import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../BreakView/break_view.dart';
import '../MotivationView/motivation_view.dart';

class TrainingActiveView extends StatefulWidget {
  final String gender;
  final int initialIndex;
  const TrainingActiveView({super.key, this.gender = 'woman', this.initialIndex = 0});
  @override
  State<TrainingActiveView> createState() => _TrainingActiveViewState();
}

class _TrainingActiveViewState extends State<TrainingActiveView> {
  double progress = 0.55;
  bool isPlaying = true;
  late int currentIndex;
  final List<Map<String, String>> exercises = [
    {
      "name": "Crunch",
      "sets": "3 Set × 20 Tekrar",
      "rest": "20 - 30 sn",
    },
    {
      "name": "Toe Touch Crunch",
      "sets": "3 Set × 15 Tekrar",
      "rest": "20 - 30 sn",
    },
    {
      "name": "Bent Knee Leg Raise",
      "sets": "3 Set × 15 Tekrar",
      "rest": "30 sn",
    },
    {
      "name": "Lying Knee Raise",
      "sets": "3 Set × 15 Tekrar",
      "rest": "30 sn",
    },
    {
      "name": "Heel Touch",
      "sets": "3 Set × 20 Tekrar",
      "rest": "20 - 30 sn",
    },
    {
      "name": "Standing Side Crunch",
      "sets": "3 Set × 20 Tekrar",
      "rest": "20 - 30 sn",
    },
    {
      "name": "Forearm Plank",
      "sets": "3 Set × 30 Tekrar",
      "rest": "30 sn",
    },
    {
      "name": "Mountain Climber",
      "sets": "3 Set × 30 Tekrar",
      "rest": "30 sn",
    },
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void _nextExercise() async {
    if (currentIndex < exercises.length - 1) {
      bool wasPlaying = isPlaying;
      setState(() => isPlaying = false);
      int halfWayMark = (exercises.length ~/ 2) - 1;
      if (currentIndex == halfWayMark) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const MotivationView(
              userName: 'Sinem',
              completedExercises: 4,
              activeMinutes: 10,
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
          progress = 0;
          isPlaying = wasPlaying;
        });
      }
    }
  }
  void _prevExercise() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        progress = 0;
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
                child: Image.asset(
                  'assets/images/${exercises[currentIndex]['name']} ${widget.gender}.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _tryAlternativeImage(
                    'assets/images/${exercises[currentIndex]['name']} ${widget.gender}.png',
                    context,
                  ),
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
                        exercises[currentIndex]['name']!,
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
              top: 761.h,
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
                    Row(
                      children: [
                        Text(
                          'Sıradaki Hareket',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            color: const Color(0xFF000000),
                            height: 15 / 12,
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
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(3.r),
                                child: Image.asset(
                                  'assets/images/${exercises[currentIndex + 1]['name']} ${widget.gender}.png',
                                  width: 29.w,
                                  height: 21.w,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      _tryAlternativeImageFixedSize(
                                    'assets/images/${exercises[currentIndex + 1]['name']} ${widget.gender}.png',
                                    context,
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                exercises[currentIndex + 1]['name']!.length > 18
                                    ? '${exercises[currentIndex + 1]['name']!.substring(0, 18)}...'
                                    : exercises[currentIndex + 1]['name']!,
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500,
                                fontSize: 10.sp,
                                color: const Color(0xFF100F0F),
                                height: 12 / 10,
                              ),
                            ),
                          ],
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
    );
  }
  Widget _buildProgressBar() {
    return SizedBox(
      height: 18.h,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            height: 12.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFD5D5D5),
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
          FractionallySizedBox(
            widthFactor: progress,
            child: Container(
              height: 12.h,
              decoration: BoxDecoration(
                color: const Color(0xFF06C44F),
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
          Positioned(
            left: (342.w * progress) - 9.w,
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
      ),
    );
  }

  Widget _buildTimerRow() {
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
                  'kalan süre 6:58',
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
                  '10',
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
                  '00',
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
          onTap: () {
            setState(() {
              isPlaying = !isPlaying;
            });
          },
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
          child: SvgPicture.asset(
            'assets/images/next_exercise_button.svg',
            width: 32.w,
            height: 32.w,
          ),
        ),
      ],
    );
  }

  Widget _tryAlternativeImage(String imagePath, BuildContext context) {
    String noSpacePath = imagePath.replaceFirst(' woman.png', 'woman.png')
                                  .replaceFirst(' man.png', 'man.png');

    if (noSpacePath != imagePath) {
      return Image.asset(
        noSpacePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _tryInvisibleCharacters(imagePath, context),
      );
    }
    return _tryInvisibleCharacters(imagePath, context);
  }

  Widget _tryAlternativeImageFixedSize(String imagePath, BuildContext context) {
    String noSpacePath = imagePath.replaceFirst(' woman.png', 'woman.png')
                                  .replaceFirst(' man.png', 'man.png');

    if (noSpacePath != imagePath) {
      return Image.asset(
        noSpacePath,
        width: 29.w,
        height: 21.w,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _tryInvisibleCharactersFixedSize(imagePath, context),
      );
    }
    return _tryInvisibleCharactersFixedSize(imagePath, context);
  }

  Widget _tryInvisibleCharacters(String imagePath, BuildContext context) {
    String withSepPath = imagePath.replaceFirst(' woman.png', '  woman.png')
                                  .replaceFirst(' man.png', '  man.png');

    if (withSepPath != imagePath) {
      return Image.asset(
        withSepPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _tryWomenVariant(imagePath, context),
      );
    }
    return _tryWomenVariant(imagePath, context);
  }

  Widget _tryInvisibleCharactersFixedSize(String imagePath, BuildContext context) {
    String withSepPath = imagePath.replaceFirst(' woman.png', '  woman.png')
                                  .replaceFirst(' man.png', '  man.png');

    if (withSepPath != imagePath) {
      return Image.asset(
        withSepPath,
        width: 29.w,
        height: 21.w,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _tryWomenVariantFixedSize(imagePath, context),
      );
    }
    return _tryWomenVariantFixedSize(imagePath, context);
  }

  Widget _tryWomenVariant(String imagePath, BuildContext context) {
    if (imagePath.contains('woman.png')) {
      String womenPath = imagePath.replaceFirst('woman.png', 'women.png');
      return Image.asset(
        womenPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }
    return _buildPlaceholder();
  }

  Widget _tryWomenVariantFixedSize(String imagePath, BuildContext context) {
    if (imagePath.contains('woman.png')) {
      String womenPath = imagePath.replaceFirst('woman.png', 'women.png');
      return Image.asset(
        womenPath,
        width: 29.w,
        height: 21.w,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholderFixedSize(),
      );
    }
    return _buildPlaceholderFixedSize();
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
