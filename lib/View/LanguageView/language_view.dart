import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Riverpod/Controllers/locale_provider.dart';
import '../../Core/Localization/translations.dart';

class LanguageModel {
  final String flag;
  final String code;
  final String name;
  LanguageModel(this.flag, this.code, this.name);
}

class LanguageView extends ConsumerStatefulWidget {
  const LanguageView({super.key});
  @override
  ConsumerState<LanguageView> createState() => _LanguageViewState();
}

class _LanguageViewState extends ConsumerState<LanguageView> {
  final List<LanguageModel> languages = [
    LanguageModel('🇺🇸', 'en', 'English'),
    LanguageModel('🇹🇷', 'tr', 'Türkçe'),
    LanguageModel('🇪🇸', 'es', 'Español'),
    LanguageModel('🇵🇹', 'pt', 'Português'),
    LanguageModel('🇫🇷', 'fr', 'Français'),
    LanguageModel('🇮🇹', 'it', 'Italiano'),
    LanguageModel('🇩🇪', 'de', 'Deutsch'),
    LanguageModel('🇷🇺', 'ru', 'Русский'),
    LanguageModel('🇯🇵', 'ja', '日本語'),
    LanguageModel('🇰🇷', 'ko', '한국어'),
    LanguageModel('🇮🇳', 'hi', 'हिन्दी'),
  ];

  late String _selectedLanguageCode;

  @override
  void initState() {
    super.initState();
    _selectedLanguageCode = ref.read(localeProvider).languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final langCode = ref.watch(localeProvider).languageCode;
    
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFEFEFE),
        surfaceTintColor: Colors.transparent,
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
          Translations.translate('language_preferences', langCode),
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Expanded(
                child: ListView.separated(
                  physics: const ClampingScrollPhysics(),
                  itemCount: languages.length,
                  separatorBuilder: (context, index) => SizedBox(height: 10.h),
                  itemBuilder: (context, index) {
                    final lang = languages[index];
                    final isSelected = _selectedLanguageCode == lang.code;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedLanguageCode = lang.code;
                        });
                      },
                      child: Container(
                        height: 48.h,
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEFEFE),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF4E4949).withValues(alpha: 0.62)
                                : const Color(0xFFDDDDDD),
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          children: [
                            Text(
                              lang.flag,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              lang.name,
                              style: GoogleFonts.montserrat(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                letterSpacing: -0.011.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10.h),
              GestureDetector(
                onTap: () async {
                  await ref.read(localeProvider.notifier).setLocale(_selectedLanguageCode);
                  if (mounted) Navigator.pop(context);
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
                      SvgPicture.asset(
                        'assets/images/Save_Icon_Language.svg',
                        width: 20.sp,
                        height: 20.sp,
                        colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        Translations.translate('save', langCode),
                        style: GoogleFonts.montserrat(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          letterSpacing: -0.011.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
