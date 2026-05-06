import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:six_pack_30/Riverpod/Controllers/user_provider.dart';
import 'package:six_pack_30/Riverpod/Controllers/auth_controller.dart';
import 'package:six_pack_30/Riverpod/Controllers/premium_provider.dart';
import 'package:six_pack_30/Riverpod/Controllers/stats_provider.dart';
import 'package:six_pack_30/Core/Routes/app_routes.dart';
import 'package:six_pack_30/main.dart';
import 'profile_edit_view.dart';
import '../LanguageView/language_view.dart';
import '../FaqView/faq_view.dart';
import '../PaywallView/paywall_view.dart';
import '../RateAppView/rate_app_view.dart';
import '../ShareAppView/share_app_view.dart';
import '../../Riverpod/Controllers/locale_provider.dart';
import '../../Core/Services/health_service.dart';
import '../../Core/Localization/translations.dart';

class ProfileView extends ConsumerWidget {
  final bool isPremium;
  final VoidCallback onBackPressed;
  const ProfileView({
    super.key,
    required this.isPremium,
    required this.onBackPressed,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final user = userProfile.value;
    final langCode = ref.watch(localeProvider).languageCode;
    
    final bool isLoading = userProfile.isLoading && user == null;
    final bool isGuest = user == null && !userProfile.isLoading;
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final bool hasNoSession = isGuest && firebaseUser == null;

    if (hasNoSession) {
      return SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_off_outlined, size: 64.sp, color: Colors.grey),
              SizedBox(height: 16.h),
              Text(
                'Profili görüntülemek için giriş yapın',
                style: GoogleFonts.montserrat(fontSize: 16.sp, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              GestureDetector(
                onTap: () {
                  navigatorKey.currentState?.pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00EF5B),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'Giriş Yap',
                    style: GoogleFonts.montserrat(fontSize: 14.sp, fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    final String firebaseDisplayName = firebaseUser?.displayName ?? '';
    final String firebaseEmailPart = firebaseUser?.email != null 
        ? (firebaseUser!.email!.contains('privaterelay.appleid.com') ? '' : firebaseUser.email!.split('@').first) 
        : '';
    final String displayName = isLoading
        ? Translations.translate('loading', langCode)
        : (user?.name != null && user!.name!.trim().isNotEmpty
            ? user.name!
            : (firebaseDisplayName.isNotEmpty 
                ? firebaseDisplayName 
                : (firebaseEmailPart.isNotEmpty 
                    ? firebaseEmailPart 
                    : Translations.translate('guest', langCode))));
        
    final String defaultProfileImage = 'https://sixpack30.b-cdn.net/images/iconstack.io - (User Circle Regular).png';
    final bool effectiveIsPremium = isPremium;

    return SafeArea(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 80.h, top: 20.h),
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
                    child: Text(Translations.translate('profile', langCode),
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
                  backgroundColor: const Color(0xFFF3F3F3),
                  child: ClipOval(
                    child: user?.photoUrl != null
                        ? CachedNetworkImage(
                      imageUrl: user!.photoUrl!,
                      width: 48.w,
                      height: 48.h,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2),
                      errorWidget: (context, url, error) => Icon(
                        Icons.person_rounded,
                        size: 28.sp,
                        color: const Color(0xFFADADAD),
                      ),
                    )
                        : Icon(
                            Icons.person_rounded,
                            size: 28.sp,
                            color: const Color(0xFFADADAD),
                          ),
                  ),
                ),
                SizedBox(width: 10.w),
                Text(displayName,
                    style: GoogleFonts.nunito(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        letterSpacing: -0.11.sp)),
                const Spacer(),
                if (effectiveIsPremium)
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
                        SvgPicture.network('https://sixpack30.b-cdn.net/images/Crown_Premium.svg',
                          width: 24.sp,
                          height: 24.sp,
                          colorFilter: const ColorFilter.mode(
                              Color(0xFFFDFDFD), BlendMode.srcIn),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          Translations.translate('premium', langCode),
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
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Translations.translate('account_settings', langCode),
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
                          iconPath: 'https://sixpack30.b-cdn.net/images/Edit_Profile_Icon_Full.svg',
                          title: Translations.translate('edit_profile', langCode),
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
                          iconPath: 'https://sixpack30.b-cdn.net/images/Notifications_Icon_Full.svg',
                          title: Translations.translate('notifications', langCode),
                          isLast: effectiveIsPremium,
                          isSwitch: true,
                          switchValue: user?.notificationsEnabled ?? true,
                          onToggle: (val) {
                            ref.read(userProfileProvider.notifier).updateProfile({'notificationsEnabled': val});
                          }),
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
                Text(Translations.translate('support_and_other', langCode),
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
                          iconPath: 'https://sixpack30.b-cdn.net/images/Health_Icon_Full.svg',
                          title: Translations.translate('connect_health', langCode),
                          isLast: false,
                          isSwitch: true,
                          switchValue: user?.healthConnected ?? false,
                          onToggle: (val) async {
                            if (val) {
                              if (Platform.isAndroid) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(Translations.translate('apple_health_ios_only', langCode)),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                                return;
                              }
                              final healthService = HealthService();
                              final bool granted = await healthService.requestPermissions();
                              if (granted) {
                                ref.read(userProfileProvider.notifier).updateProfile({'healthConnected': true});
                                await healthService.syncHealthData();
                              }
                            } else {
                              ref.read(userProfileProvider.notifier).updateProfile({'healthConnected': false});
                            }
                          }),
                      _buildSettingsItem(
                          iconPath: 'https://sixpack30.b-cdn.net/images/Language_Icon_Full.svg',
                          title: Translations.translate('language_preferences', langCode),
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
                          iconPath: 'https://sixpack30.b-cdn.net/images/Faq_Icon_Full.svg',
                          title: Translations.translate('faq', langCode),
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
                          iconPath: 'https://sixpack30.b-cdn.net/images/Rate_App_Icon_Full.svg',
                          title: Translations.translate('rate_us', langCode),
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
                          iconPath: 'https://sixpack30.b-cdn.net/images/Share_App_Icon_Full.svg',
                          title: Translations.translate('share_app', langCode),
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
                          iconPath: 'https://sixpack30.b-cdn.net/images/Logout_Icon_Full.svg',
                          title: Translations.translate('logout', langCode),
                          isLast: true,
                          isRed: true,
                          onTap: () async {
                            await ref.read(authControllerProvider.notifier).signOut();
                            ref.invalidate(userProfileProvider);
                            ref.invalidate(statsProvider);
                            if (context.mounted) {
                              navigatorKey.currentState?.pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
                            }
                          }),
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
                Text(
                  Translations.translate('legal', langCode),
                  style: GoogleFonts.montserrat(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      letterSpacing: -0.11.sp),
                ),
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
                          iconPath: 'https://sixpack30.b-cdn.net/images/Faq_Icon_Full.svg',
                          title: Translations.translate('privacy_policy', langCode),
                          isLast: false,
                          onTap: () => launchUrl(
                                Uri.parse('https://fly-work.com/sixpack30/privacy-policy/'),
                                mode: LaunchMode.externalApplication,
                              )),
                      _buildSettingsItem(
                          iconPath: 'https://sixpack30.b-cdn.net/images/Faq_Icon_Full.svg',
                          title: Translations.translate('terms_of_service', langCode),
                          isLast: false,
                          onTap: () => launchUrl(
                                Uri.parse('https://fly-work.com/sixpack30/terms/'),
                                mode: LaunchMode.externalApplication,
                              )),
                      _buildSettingsItem(
                          iconPath: 'https://sixpack30.b-cdn.net/images/Faq_Icon_Full.svg',
                          title: Translations.translate('cookie_policy', langCode),
                          isLast: false,
                          onTap: () => launchUrl(
                                Uri.parse('https://fly-work.com/sixpack30/cookies/'),
                                mode: LaunchMode.externalApplication,
                              )),
                      _buildSettingsItem(
                          iconPath: 'https://sixpack30.b-cdn.net/images/Faq_Icon_Full.svg',
                          title: Translations.translate('csae_policy', langCode),
                          isLast: true,
                          onTap: () => launchUrl(
                                Uri.parse('https://fly-work.com/sixpack30/csae/'),
                                mode: LaunchMode.externalApplication,
                              )),
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
  Widget _buildSettingsItem({
    required String iconPath,
    required String title,
    required bool isLast,
    bool isSwitch = false,
    bool switchValue = false,
    bool isRed = false,
    VoidCallback? onTap,
    ValueChanged<bool>? onToggle,
  }) {
    return GestureDetector(
      onTap: isSwitch ? () => onToggle?.call(!switchValue) : onTap,
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
                ? SvgPicture.network(
                    iconPath,
                    width: 28.w,
                    height: 28.w,
                  )
                : CachedNetworkImage(
                    imageUrl: iconPath,
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
            _buildCustomSwitch(switchValue, onToggle)
          else
            Icon(Icons.chevron_right,
                size: 24.sp, color: Colors.black.withOpacity(0.27)),
        ],
      ),
      ),
    );
  }
  Widget _buildCustomSwitch(bool value, ValueChanged<bool>? onToggle) {
    return Container(
      width: 37.w,
      height: 20.h,
      decoration: BoxDecoration(
        color: value ? const Color(0xF5342F2F) : const Color(0xFFE2E2E2),
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
