import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Riverpod/Controllers/locale_provider.dart';
import '../../Core/Localization/translations.dart';
class FaqView extends ConsumerStatefulWidget {
  const FaqView({super.key});
  @override
  ConsumerState<FaqView> createState() => _FaqViewState();
}
class _FaqViewState extends ConsumerState<FaqView> {
  int? _expandedIndex = 0;
  List<Map<String, String>> _getFaqs(String langCode) {
    return List.generate(9, (index) {
      final i = index + 1;
      return {
        'question': Translations.translate('faq_q$i', langCode),
        'answer': Translations.translate('faq_a$i', langCode),
      };
    });
  }
  @override
  Widget build(BuildContext context) {
    final langCode = ref.watch(localeProvider).languageCode;
    final faqs = _getFaqs(langCode);
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      appBar: AppBar(
        toolbarHeight: 80.h,
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
          Translations.translate('faq', langCode),
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
        child: ListView.separated(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 20.h, bottom: 40.h),
          itemCount: faqs.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final faq = faqs[index];
            final bool isExpanded = _expandedIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _expandedIndex = isExpanded ? null : index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: isExpanded
                      ? const Color.fromRGBO(249, 249, 249, 0.57)
                      : Colors.white,
                  border: Border.all(
                    color: isExpanded
                        ? const Color.fromRGBO(78, 73, 73, 0.62)
                        : const Color(0xFFF3F3F3),
                  ),
                  borderRadius: BorderRadius.circular(
                    isExpanded ? 15.r : 10.r,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            faq['question']!,
                            style: GoogleFonts.montserrat(
                              fontSize: isExpanded ? 14.sp : 12.sp,
                              fontWeight: FontWeight.w500,
                              color: isExpanded
                                  ? const Color(0xFF0D0D0D)
                                  : const Color.fromRGBO(0, 0, 0, 0.8),
                              letterSpacing: -0.011.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color.fromRGBO(16, 16, 16, 0.4),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 14.sp,
                              color: const Color.fromRGBO(16, 16, 16, 0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (isExpanded) ...[
                      SizedBox(height: 10.h),
                      Text(
                        faq['answer']!,
                        style: GoogleFonts.montserrat(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF4E4949),
                          letterSpacing: -0.011.sp,
                          height: 1.25,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
