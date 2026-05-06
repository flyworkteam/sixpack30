import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../Core/Data/workout_data.dart';
import '../../Core/Localization/translations.dart';
import '../../Riverpod/Controllers/locale_provider.dart';
import '../TrainingActiveView/training_active_view.dart';
import '../../Riverpod/Controllers/workout_progress_provider.dart';

class TrainingDetailView extends ConsumerStatefulWidget {
  final int dayNumber;
  final String title;
  final List<ExerciseInfo> exercises;
  final String gender;

  const TrainingDetailView({
    super.key,
    required this.dayNumber,
    required this.title,
    required this.exercises,
    this.gender = 'woman',
  });

  @override
  ConsumerState<TrainingDetailView> createState() => _TrainingDetailViewState();
}

class _TrainingDetailViewState extends ConsumerState<TrainingDetailView> {
  @override
  Widget build(BuildContext context) {
    final langCode = ref.watch(localeProvider).languageCode;
    final progress = ref.watch(workoutProgressProvider);
    
    
    final currentProgress = (progress != null && progress.dayNumber == widget.dayNumber) ? progress : null;

    final dayNumber = widget.dayNumber;
    final title = widget.title;
    final exercises = widget.exercises;
    final gender = widget.gender;
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      body: SafeArea(
        child: Stack(
          children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 280.h + MediaQuery.of(context).padding.top,
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
                  CachedNetworkImage(imageUrl: 'https://sixpack30.b-cdn.net/images/detayantrenman.jpg',
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    errorWidget: (context, url, error) => Container(
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
                          SizedBox(height: 35.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  '${dayNumber}. ${Translations.translate('workout_day', langCode)}: $title',
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.sp,
                                    color: const Color(0xFF100F0F),
                                    height: 1.1,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: SvgPicture.network('https://sixpack30.b-cdn.net/images/detail_close_icon.svg',
                                  width: 24.w,
                                  height: 24.w,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: [
                              _buildBadge(
                                iconData: Icons.access_time,
                                iconAsset: 'https://sixpack30.b-cdn.net/images/detail_clock_icon.svg',
                                text: exercises.isEmpty ? Translations.translate('rest', langCode) : '10 ${Translations.translate('minutes', langCode)}',
                              ),
                              _buildBadge(
                                iconData: Icons.fitness_center,
                                iconAsset: 'https://sixpack30.b-cdn.net/images/detail_abs_zone_icon.svg',
                                text: '${Translations.translate('focus_area', langCode)}: ${Translations.translate('abs', langCode)}',
                              ),
                              _buildBadge(
                                iconData: Icons.accessibility_new,
                                iconAsset: 'https://sixpack30.b-cdn.net/images/detail_exercise_icon.svg',
                                text: exercises.isEmpty ? Translations.translate('active_rest', langCode) : '${exercises.length} ${Translations.translate('exercises_count', langCode)}',
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          Text(
                            Translations.translate('training', langCode),
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
                                          exercises: exercises,
                                          initialIndex: index,
                                          dayNumber: dayNumber,
                                        ),
                                      ),
                                    );
                                  },
                                  child: _buildExerciseCard(
                                    title: Translations.translateExerciseName(ex.name, langCode),
                                    sets: Translations.translateSets(ex.sets, langCode),
                                    rest: '${Translations.translate('rest', langCode)}: ${Translations.translateSets(ex.rest, langCode)}',
                                    imagePath: ex.getImagePath(gender),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 24.h),
                          if (exercises.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => TrainingActiveView(
                                      gender: gender,
                                      exercises: exercises,
                                      initialIndex: currentProgress?.exerciseIndex ?? 0,
                                      initialSetIndex: currentProgress?.setIndex ?? 0,
                                      dayNumber: dayNumber,
                                      title: title,
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
                                      currentProgress != null 
                                        ? Translations.translate('continue_where_left', langCode)
                                        : Translations.translate('start_workout', langCode),
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
                          if (exercises.isEmpty)
                            Container(
                              padding: EdgeInsets.all(20.r),
                              decoration: BoxDecoration(
                                color: const Color(0xFF06C44F).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(15.r),
                                border: Border.all(
                                    color: const Color(0xFF06C44F)
                                        .withValues(alpha: 0.3)),
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.nightlight_round,
                                      color: const Color(0xFF06C44F), size: 40.sp),
                                  SizedBox(height: 10.h),
                                  Text(
                                    Translations.translate('no_workout_today', langCode),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.sp,
                                      color: const Color(0xFF100F0F),
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    Translations.translate('no_workout_today_desc', langCode),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13.sp,
                                      color: const Color(0xFF6B6B6B),
                                    ),
                                  ),
                                ],
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
            top: MediaQuery.of(context).padding.top + 35.h,
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
      ),
    );
  }
  Widget _buildBadge({
    required IconData iconData,
    required String iconAsset,
    required String text,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        border: Border.all(color: const Color(0xFFEBEBEB)),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconAsset.endsWith('.svg')
              ? SvgPicture.network(
                  iconAsset,
                  width: 16.w,
                  height: 16.w,
                )
              : CachedNetworkImage(
                  imageUrl: iconAsset,
                  width: 16.w,
                  height: 16.w,
                  color: const Color(0xFF06C44F),
                  errorWidget: (context, url, error) => Icon(
                    iconData,
                    size: 14.sp,
                    color: const Color(0xFF06C44F),
                  ),
                ),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              text,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                fontSize: 11.sp,
                color: const Color(0xFF100F0F),
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
              child: CachedNetworkImage(
                imageUrl: imagePath,
                width: 81.w,
                height: 61.h,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => _buildPlaceholder(),
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
  Widget _buildPlaceholder() {
    return Container(
      width: 81.w,
      height: 61.h,
      color: const Color(0xFFD9D9D9),
      child: Icon(Icons.fitness_center, size: 24.sp, color: Colors.white),
    );
  }
}
