import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
class InitialView extends StatefulWidget {
  const InitialView({super.key});
  @override
  State<InitialView> createState() => _InitialViewState();
}
class _InitialViewState extends State<InitialView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboard');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 154.w,
              height: 154.w,
              decoration: BoxDecoration(
                color: const Color(0xFF43A047),
                borderRadius: BorderRadius.circular(24.r),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Text(
                    "Logo",
                    style: TextStyle(color: Colors.white, fontSize: 24.sp),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "SixPack30",
              style: GoogleFonts.nunitoSans(
                fontSize: 34.sp,
                fontWeight: FontWeight.w800,
                color: Colors.black,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
