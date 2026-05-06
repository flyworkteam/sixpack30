import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Riverpod/Controllers/locale_provider.dart';
import '../../Core/Localization/translations.dart';
class RateAppView extends ConsumerStatefulWidget {
  const RateAppView({super.key});
  @override
  ConsumerState<RateAppView> createState() => _RateAppViewState();
}
class _RateAppViewState extends ConsumerState<RateAppView> {
  int _rating = 4;
  @override
  Widget build(BuildContext context) {
    final langCode = ref.watch(localeProvider).languageCode;
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      appBar: AppBar(
        toolbarHeight: 80.h,
        backgroundColor: const Color(0xFFFEFEFE),
        elevation: 0,
        centerTitle: true,
        leading: UnconstrainedBox(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: EdgeInsets.only(left: 24.w),
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: const Color(0xFFEDEDED).withValues(alpha: 0.85),
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
        title: Text(
          Translations.translate('rate_app_title', langCode),
          style: GoogleFonts.montserrat(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0D0D0D),
            letterSpacing: -0.011.sp,
            height: 1.5,
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const Spacer(flex: 2),
                      Column(
                        children: [
                          Text(
                            'SixPack30',
                            style: GoogleFonts.manrope(
                              fontSize: 28.64.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF000000),
                              height: 39 / 28.64,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          SizedBox(
                            width: 228.w,
                            height: 244.h,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 28.w,
                                  top: 0,
                                  child: Container(
                                    width: 200.w,
                                    height: 221.h,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEDFCF3),
                                      borderRadius: BorderRadius.circular(3.r),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 16.w,
                                  top: 12.h,
                                  child: Container(
                                    width: 195.w,
                                    height: 219.h,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFCFEBDA),
                                      borderRadius: BorderRadius.circular(3.r),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  top: 23.h,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3.r),
                                    child: CachedNetworkImage(imageUrl: 'https://sixpack30.b-cdn.net/images/agirlik.png',
                                      width: 200.w,
                                      height: 221.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),
                      Column(
                        children: [
                          Column(
                            children: [
                              Text(
                                Translations.translate('do_you_like_sixpack30', langCode),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0D0D0D),
                                  height: 24 / 20,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                Translations.translate('your_feedback_valuable', langCode),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF4E4949),
                                  height: 20 / 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 39.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              final bool isSelected = index < _rating;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _rating = index + 1;
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                                  child: CachedNetworkImage(imageUrl: 'https://sixpack30.b-cdn.net/images/yildiz.png',
                                    width: 44.w,
                                    height: 44.w,
                                    color: isSelected
                                        ? const Color(0xFF06C44F)
                                        : const Color(0xFFC9C9C9),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                      const Spacer(flex: 3),
                      SizedBox(
                        width: double.infinity,
                        height: 44.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00EF5B),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            Translations.translate('send', langCode),
                            style: GoogleFonts.montserrat(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF000000),
                              height: 20 / 16,
                              letterSpacing: -0.011.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
