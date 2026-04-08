import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../TrainingActiveView/training_active_view.dart';
class TrainingDetailView extends StatelessWidget {
  final String gender;
  const TrainingDetailView({super.key, this.gender = 'woman'});
  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 280.h,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.r),
                  bottomRight: Radius.circular(15.r),
                ),
              ),
              clipBehavior: Clip.hardEdge,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/detayantrenman.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFF323232),
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.white54,
                        size: 40.sp,
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.black.withValues(alpha: 0.38),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(height: 247.h),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.r),
                        topRight: Radius.circular(15.r),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '1.Gün: Aktivasyon',
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20.sp,
                                  color: const Color(0xFF100F0F),
                                  height: 1.1,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: SvgPicture.asset(
                                  'assets/images/detail_close_icon.svg',
                                  width: 24.w,
                                  height: 24.w,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildBadge(
                                iconData: Icons.access_time,
                                iconAsset: 'assets/images/detail_clock_icon.svg',
                                text: '30 Dakika',
                              ),
                              _buildBadge(
                                iconData: Icons.fitness_center,
                                iconAsset: 'assets/images/detail_abs_zone_icon.svg',
                                text: 'Bölge: Karın',
                              ),
                              _buildBadge(
                                iconData: Icons.accessibility_new,
                                iconAsset: 'assets/images/detail_exercise_icon.svg',
                                text: '8 Egzersiz',
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          Text(
                            'Program',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600,
                              fontSize: 20.sp,
                              color: const Color(0xFF100F0F),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          ...List.generate(
                            exercises.length,
                            (index) {
                              final ex = exercises[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => TrainingActiveView(
                                          gender: gender,
                                          initialIndex: index,
                                        ),
                                      ),
                                    );
                                  },
                                  child: _buildExerciseCard(
                                    title: ex['name']!,
                                    sets: ex['sets']!,
                                    rest: 'Set arası: ${ex['rest']}',
                                    imagePath: 'assets/images/${ex['name']} $gender.png',
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 24.h),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => TrainingActiveView(
                                      gender: gender,
                                      initialIndex: 0,
                                    ),
                                  ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 44.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFF00EF5B),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Antrenmana Başla',
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.sp,
                                      color: const Color(0xFF0A0A0A),
                                      letterSpacing: -0.011,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 18.sp,
                                    color: const Color(0xFF0A0A0A),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 50.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 74.h,
            left: 25.w,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.85),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_back_ios_sharp,
                  size: 12.sp,
                  color: const Color(0xFF0D0D0D),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildBadge({
    required IconData iconData,
    required String iconAsset,
    required String text,
  }) {
    return Container(
      width: 108.w,
      height: 34.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        border: Border.all(color: const Color(0xFFEBEBEB)),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconAsset.endsWith('.svg')
              ? SvgPicture.asset(
                  iconAsset,
                  width: 16.w,
                  height: 16.w,
                )
              : Image.asset(
                  iconAsset,
                  width: 16.w,
                  height: 16.w,
                  color: const Color(0xFF06C44F),
                  errorBuilder: (context, error, stackTrace) => Icon(
                    iconData,
                    size: 14.sp,
                    color: const Color(0xFF06C44F),
                  ),
                ),
          SizedBox(width: 6.w),
          Text(
            text,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              fontSize: 11.sp,
              color: const Color(0xFF100F0F),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildExerciseCard({
    required String title,
    required String sets,
    required String rest,
    required String imagePath,
  }) {
    return Container(
      width: 342.w,
      height: 70.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: const Color(0xFFEBEBEB)),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 9.w,
            top: 4.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.asset(
                imagePath,
                width: 81.w,
                height: 61.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _tryAlternativeImage(imagePath, context);
                },
              ),
            ),
          ),
          Positioned(
            left: 99.w,
            top: 0,
            bottom: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                    color: const Color(0xFF100F0F),
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  sets,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp,
                    color: const Color(0xFF100F0F),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  rest,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp,
                    color: const Color(0xFF686868),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _tryAlternativeImage(String imagePath, BuildContext context) {
    String noSpacePath = imagePath.replaceFirst(' woman.png', 'woman.png')
                                  .replaceFirst(' man.png', 'man.png');

    if (noSpacePath != imagePath) {
      return Image.asset(
        noSpacePath,
        width: 81.w,
        height: 61.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _tryInvisibleCharacters(imagePath, context),
      );
    }
    return _tryInvisibleCharacters(imagePath, context);
  }

  Widget _tryInvisibleCharacters(String imagePath, BuildContext context) {
    String withSepPath = imagePath.replaceFirst(' woman.png', '  woman.png')
                                  .replaceFirst(' man.png', '  man.png');

    if (withSepPath != imagePath) {
      return Image.asset(
        withSepPath,
        width: 81.w,
        height: 61.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _tryWomenVariant(imagePath, context),
      );
    }
    return _tryWomenVariant(imagePath, context);
  }

  Widget _tryWomenVariant(String imagePath, BuildContext context) {
    if (imagePath.contains('woman.png')) {
      String womenPath = imagePath.replaceFirst('woman.png', 'women.png');
      return Image.asset(
        womenPath,
        width: 81.w,
        height: 61.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 81.w,
      height: 61.h,
      color: const Color(0xFFD9D9D9),
      child: Icon(Icons.fitness_center, size: 24.sp, color: Colors.white),
    );
  }
}
