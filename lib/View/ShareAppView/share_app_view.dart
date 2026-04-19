import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Riverpod/Controllers/locale_provider.dart';
import '../../Core/Localization/translations.dart';
class ShareAppView extends ConsumerWidget {
  const ShareAppView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langCode = ref.watch(localeProvider).languageCode;
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      appBar: AppBar(
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
          Translations.translate('share_app_title', langCode),
          style: GoogleFonts.montserrat(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0D0D0D),
            letterSpacing: -0.011.sp,
            height: 1.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 60.h),
            _buildIllustration(),
            SizedBox(height: 43.h),
            Column(
              children: [
                Text(
                  Translations.translate('invite_friends_title', langCode),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0D0D0D),
                    height: 29 / 24,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  Translations.translate('invite_friends_desc', langCode),
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
            SizedBox(height: 24.h),
            _buildShareLink(context, langCode),
            SizedBox(height: 24.h),
            _buildSocialLinks(),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
  Widget _buildIllustration() {
    return SizedBox(
      width: 217.w,
      height: 196.22.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 190.w,
            height: 190.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFF3F3F3), width: 1.w),
            ),
          ),
          Container(
            width: 140.w,
            height: 140.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF00EF5B).withValues(alpha: 0.5),
                width: 12.w,
              ),
            ),
          ),
          Container(
            width: 90.w,
            height: 90.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFF3F3F3), width: 1.w),
            ),
          ),
          Container(
            width: 45.w,
            height: 45.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFF3F3F3), width: 1.w),
            ),
          ),
          Positioned(
            top: 20.h,
            left: 15.w,
            child: _buildAvatar('assets/images/avatar_1.png', 48.w),
          ),
          Positioned(
            top: 15.h,
            right: 30.w,
            child: _buildAvatar('assets/images/avatar_2.png', 40.w),
          ),
          Positioned(
            top: 85.h,
            left: 5.w,
            child: _buildAvatar('assets/images/avatar_3.png', 36.w),
          ),
          Positioned(
            bottom: 25.h,
            left: 20.w,
            child: _buildAvatar('assets/images/avatar_4.png', 42.w),
          ),
          Positioned(
            bottom: 30.h,
            right: 80.w,
            child: _buildAvatar('assets/images/avatar_5.png', 46.w),
          ),
          Positioned(
            bottom: 60.h,
            right: 5.w,
            child: _buildAvatar('assets/images/avatar_6.png', 44.w),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String asset, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        asset,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.person, size: size * 0.6, color: Colors.white),
      ),
    );
  }
  Widget _buildShareLink(BuildContext context, String langCode) {
    const String link = 'https://sixpack30.com';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Translations.translate('share_link', langCode),
          style: GoogleFonts.montserrat(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF0D0D0D),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: 342.w,
          height: 44.h,
          decoration: BoxDecoration(
            color: const Color(0xFFFEFEFE),
            border: Border.all(color: const Color(0xFFF3F3F3)),
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          clipBehavior: Clip.hardEdge,
          child: Row(
            children: [
              SizedBox(width: 15.w),
              Expanded(
                child: Text(
                  link,
                  style: GoogleFonts.montserrat(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF4E4949),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(const ClipboardData(text: link));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(Translations.translate('link_copied', langCode)),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  width: 110.w,
                  height: 44.h,
                  padding: EdgeInsets.symmetric(vertical: 11.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0A0A),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15.r),
                      bottomRight: Radius.circular(15.r),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      Translations.translate('copy', langCode),
                      style: GoogleFonts.montserrat(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildSocialLinks() {
    return Container(
      width: 342.w,
      height: 110.h,
      padding: EdgeInsets.symmetric(horizontal: 29.5.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFEFEFE),
        border: Border.all(color: const Color(0xFFF3F3F3)),
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildSocialItem('Instagram', 'assets/images/mdi_instagram.png', 71.59.w),
          _buildSocialItem('Linkedln', 'assets/images/mdi_linkedin.png', 52.22.w),
          _buildSocialItem('WhatsApp', 'assets/images/ri_whatsapp-fill.png', 71.59.w),
          _buildSocialItem('Twitter', 'assets/images/prime_twitter.png', 52.22.w),
        ],
      ),
    );
  }
  Widget _buildSocialItem(String name, String imagePath, double totalWidth) {
    return SizedBox(
      width: totalWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40.43.w,
            height: 40.43.w,
            decoration: BoxDecoration(
              color: const Color(0xFFEFEFEF),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                width: 28.64.w,
                height: 28.64.w,
                color: const Color(0xFF212121),
              ),
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            name,
            style: GoogleFonts.montserrat(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0D0D0D),
            ),
          ),
        ],
      ),
    );
  }
}
