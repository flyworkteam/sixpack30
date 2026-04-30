import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:six_pack_30/Riverpod/Controllers/all_controllers.dart';

class OnboardView extends ConsumerWidget {
  const OnboardView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardState = ref.watch(AllControllers.onboardViewController);
    final onboardController = ref.read(
      AllControllers.onboardViewController.notifier,
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView(
            physics: const ClampingScrollPhysics(),
            controller: onboardController.pageController,
            onPageChanged: onboardController.onPageChanged,
            children: [
              _buildPage(
                context,
                imagePath: 'assets/images/onboard1.png',
                gradientOpacity: 1.0,
                gradientStops: const [0.0, 0.9],
                imageDarkenOpacity: 0.3,
                imageAlignment: const Alignment(-0.27, 1.0),
                titleWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '30 Günde',
                      style: GoogleFonts.montserrat(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF00EF5B),
                        letterSpacing: (30 * -0.011).sp,
                        height: 37 / 30,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Karın Kasına Giden Yol',
                      style: GoogleFonts.montserrat(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: (28 * -0.011).sp,
                        height: 34 / 28,
                      ),
                    ),
                  ],
                ),
                description:
                    'SixPack30, karın kaslarını görünür hale getirmek için özel olarak tasarlanmış 30 günlük ev egzersiz programı sunar. Ekipmansız, kısa ve etkili.',
              ),
              _buildPage(
                context,
                imagePath: 'assets/images/onboard2.png',
                gradientOpacity: 1.0,
                gradientStops: const [0.0, 0.9],
                imageDarkenOpacity: 0.3,
                imageAlignment: const Alignment(-0.26, 1.0),
                titleWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Her Seviyeye Uygun',
                      style: GoogleFonts.montserrat(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: (28 * -0.011).sp,
                        height: 34 / 28,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Akıllı Program',
                      style: GoogleFonts.montserrat(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF00EF5B),
                        letterSpacing: (30 * -0.011).sp,
                        height: 37 / 30,
                      ),
                    ),
                  ],
                ),
                description:
                    'Yapay zekâ, güç seviyeni analiz eder ve günlük antrenman yoğunluğunu sana göre ayarlar. Ne kadar ilerlersen, program seninle birlikte gelişir.',
                descriptionOpacity: 0.8,
              ),
              _buildPage(
                context,
                imagePath: 'assets/images/onboard3.png',
                gradientOpacity: 0.05,
                imageAlignment: const Alignment(0.0, 1.0),
                titleWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Günde Sadece',
                      style: GoogleFonts.montserrat(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: (28 * -0.011).sp,
                        height: 34 / 28,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      '10 Dakika',
                      style: GoogleFonts.montserrat(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF00EF5B),
                        letterSpacing: (30 * -0.011).sp,
                        height: 37 / 30,
                      ),
                    ),
                  ],
                ),
                description:
                    'Kısa ama hedefe odaklı antrenmanlar ile core gücünü artır. Her gün bir adım at, 30 gün sonra sonuçları aynada gör.',
                descriptionOpacity: 0.8,
                descriptionWidth: 299.w,
              ),
            ],
          ),
          if (onboardState.currentIndex < 2)
            Positioned(
              top: 81.h,
              right: 34.w,
              child: GestureDetector(
                onTap: () => onboardController.skip(context),
                child: Center(
                  child: Text(
                    "Atla",
                    style: GoogleFonts.montserrat(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      letterSpacing: 0,
                      height: 22 / 18,
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 67.h,
            left: 32.w,
            right: 32.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (index) {
                    final isActive = onboardState.currentIndex == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.only(right: 4.w),
                      width: isActive ? 36.w : 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFF00EF5B)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 30.h),
                SizedBox(
                  width: 326.w,
                  height: 44.h,
                  child: ElevatedButton(
                    onPressed: () => onboardController.pushNextIndex(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00EF5B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: SizedBox(
                      width: 107.w,
                      height: 20.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            onboardState.currentIndex == 2
                                ? "Başlayın"
                                : "Devam et",
                            style: GoogleFonts.montserrat(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                            size: 20.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(
    BuildContext context, {
    required String imagePath,
    required Widget titleWidget,
    required String description,
    double descriptionOpacity = 1.0,
    double? descriptionWidth,
    double gradientOpacity = 0.6,
    List<double>? gradientStops,
    double imageDarkenOpacity = 0.0,
    Alignment imageAlignment = Alignment.topCenter,
  }) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          imagePath,
          fit: BoxFit.cover,
          alignment: imageAlignment,
          errorBuilder: (context, error, stackTrace) => Container(
            color: const Color(0xFF202020),
            child: Center(
              child: Icon(
                Icons.image_not_supported,
                color: Colors.white54,
                size: 50.sp,
              ),
            ),
          ),
        ),
        if (imageDarkenOpacity > 0)
          Container(
            color: Colors.black.withOpacity(imageDarkenOpacity),
          ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(gradientOpacity),
                Colors.transparent,
              ],
              stops: gradientStops ?? const [0.0, 0.5],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 326.w, child: titleWidget),
              SizedBox(height: 10.h),
              SizedBox(
                width: descriptionWidth ?? 326.w,
                child: Text(
                  description,
                  style: GoogleFonts.montserrat(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(
                      0xFFE4E4E4,
                    ).withOpacity(descriptionOpacity),
                    letterSpacing: (16 * -0.011).sp,
                    height: 21 / 16,
                  ),
                ),
              ),
              SizedBox(height: 179.h),
            ],
          ),
        ),
      ],
    );
  }
}
