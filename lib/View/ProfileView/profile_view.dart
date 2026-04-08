import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../FaqView/faq_view.dart';
import '../LanguageView/language_view.dart';
import '../RateAppView/rate_app_view.dart';
import '../ShareAppView/share_app_view.dart';
import 'profile_edit_view.dart';
class ProfileView extends StatelessWidget {
  final bool isPremium;
  final VoidCallback onBackPressed;
  const ProfileView({
    super.key,
    required this.isPremium,
    required this.onBackPressed,
  });
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 80.h, top: 73.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onBackPressed,
                  child: Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(237, 237, 237, 0.85),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(Icons.arrow_back_ios_new, size: 14.sp, color: Colors.black),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text('Profil',
                        style: GoogleFonts.montserrat(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            letterSpacing: -0.11.sp)),
                  ),
                ),
                SizedBox(width: 24.w),
              ],
            ),
          ),
          SizedBox(height: 36.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24.r,
                  backgroundColor: const Color(0xFFD9D9D9),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/genderWOMAN.png',
                      width: 100.w,
                      height: 100.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Text('Sinem Akın',
                    style: GoogleFonts.nunito(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        letterSpacing: -0.11.sp)),
                const Spacer(),
                if (isPremium)
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
                          colorFilter: const ColorFilter.mode(
                              Color(0xFFFDFDFD), BlendMode.srcIn),
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
            ),
          ),
          SizedBox(height: 48.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hesap Ayarları',
                    style: GoogleFonts.montserrat(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        letterSpacing: -0.11.sp)),
                SizedBox(height: 10.h),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFF3F3F3)),
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildSettingsItem(
                          iconPath: 'assets/images/Edit_Profile_Icon_Full.svg',
                          title: 'Profili Düzenle',
                          isLast: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfileEditView(),
                              ),
                            );
                          }),
                      _buildSettingsItem(
                          iconPath: 'assets/images/Notifications_Icon_Full.svg',
                          title: 'Bildirimler',
                          isLast: isPremium,
                          isSwitch: true,
                          switchValue: true),
                      if (!isPremium)
                        _buildSettingsItem(
                            iconPath: 'assets/images/iconstack.io - (Certificate Badge   Svg).png',
                            title: 'Premium',
                            isLast: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Destek & Diğer',
                    style: GoogleFonts.montserrat(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        letterSpacing: -0.11.sp)),
                SizedBox(height: 10.h),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFF3F3F3)),
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildSettingsItem(
                          iconPath: 'assets/images/Health_Icon_Full.svg',
                          title: 'App Sağlık ile Bağlan',
                          isLast: false,
                          isSwitch: true,
                          switchValue: false),
                      _buildSettingsItem(
                          iconPath: 'assets/images/Language_Icon_Full.svg',
                          title: 'Dil Tercihleri',
                          isLast: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LanguageView(),
                              ),
                            );
                          }),
                      _buildSettingsItem(
                          iconPath: 'assets/images/Faq_Icon_Full.svg',
                          title: 'Sıkça Sorulan Sorular',
                          isLast: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FaqView(),
                              ),
                            );
                          }),
                      _buildSettingsItem(
                          iconPath: 'assets/images/Rate_App_Icon_Full.svg',
                          title: 'Bizi Değerlendir',
                          isLast: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RateAppView(),
                              ),
                            );
                          }),
                      _buildSettingsItem(
                          iconPath: 'assets/images/Share_App_Icon_Full.svg',
                          title: 'Uygulamayı Paylaş',
                          isLast: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ShareAppView(),
                              ),
                            );
                          }),
                      _buildSettingsItem(
                          iconPath: 'assets/images/Logout_Icon_Full.svg',
                          title: 'Çıkış Yap',
                          isLast: true,
                          isRed: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSettingsItem({
    required String iconPath,
    required String title,
    required bool isLast,
    bool isSwitch = false,
    bool switchValue = false,
    bool isRed = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFFE2E2E2))),
      ),
      child: Row(
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              color: iconPath.endsWith('.svg') ? Colors.transparent : (isRed ? null : const Color(0xFFEFEFEF)),
              gradient: isRed
                  ? const LinearGradient(
                      colors: [Color(0xFFE61317), Color(0xFFFB989A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight)
                  : null,
              borderRadius: BorderRadius.circular(3.r),
            ),
            child: iconPath.endsWith('.svg')
                ? SvgPicture.asset(
                    iconPath,
                    width: 28.w,
                    height: 28.w,
                  )
                : Image.asset(
                    iconPath,
                    width: 20.w,
                    height: 20.h,
                    color: isRed ? Colors.white : Colors.black87,
                  ),
          ),
          SizedBox(width: 8.w),
          Text(title,
              style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isRed ? const Color(0xFFE61317) : Colors.black,
                  letterSpacing: -0.11.sp)),
          const Spacer(),
          if (isRed)
            const SizedBox.shrink()
          else if (isSwitch)
            _buildCustomSwitch(switchValue)
          else
            Icon(Icons.chevron_right,
                size: 24.sp, color: Colors.black.withOpacity(0.27)),
        ],
      ),
      ),
    );
  }
  Widget _buildCustomSwitch(bool value) {
    return Container(
      width: 37.w,
      height: 20.h,
      decoration: BoxDecoration(
        color: value ? const Color.fromRGBO(52, 47, 47, 0.96) : const Color(0xFFE2E2E2),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: value ? null : 1.58.w,
            right: value ? 1.58.w : null,
            child: Container(
              width: 16.w,
              height: 16.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
