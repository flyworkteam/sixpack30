import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:six_pack_30/Riverpod/Controllers/notification_provider.dart';
import '../../Riverpod/Controllers/locale_provider.dart';
import '../../Core/Localization/translations.dart';

class NotificationsView extends ConsumerStatefulWidget {
  const NotificationsView({super.key});
  @override
  ConsumerState<NotificationsView> createState() => _NotificationsViewState();
}
class _NotificationsViewState extends ConsumerState<NotificationsView> {
  void _deleteAll() {
    ref.read(notificationProvider.notifier).deleteAll();
  }
  void _deleteNotification(String id) {
  }
  @override
  Widget build(BuildContext context) {
    final notificationAsync = ref.watch(notificationProvider);
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
          Translations.translate('notifications', langCode),
          style: GoogleFonts.montserrat(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0D0D0D),
            letterSpacing: -0.011.sp,
            height: 1.5,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete_all') {
                _deleteAll();
              }
            },
            offset: Offset(0, 45.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            icon: Icon(
              Icons.more_vert,
              color: const Color(0xFF373636),
              size: 24.sp,
            ),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'delete_all',
                child: Text(
                  Translations.translate('delete_all', langCode),
                  style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFE92525),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 12.w),
        ],
      ),
      body: notificationAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF06C44F))),
        error: (err, stack) => Center(child: Text('Hata: $err')),
        data: (notifications) {
          if (notifications.isEmpty) {
            return _buildEmptyState(langCode);
          }

          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  ...notifications.map((item) {
                    return _buildNotificationItem(
                      id: item['id'].toString(),
                      title: item['title'],
                      body: item['body'],
                      time: Translations.translate('now', langCode),
                      iconData: Icons.notifications_active_rounded,
                      isToday: true,
                    );
                  }),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String langCode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 40.sp,
              color: const Color(0xFFADADAD),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            Translations.translate('no_notifications', langCode),
            style: GoogleFonts.montserrat(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0D0D0D),
              letterSpacing: -0.011.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            Translations.translate('no_notifications_desc', langCode),
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFADADAD),
              letterSpacing: -0.011.sp,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildNotificationItem({
    required String id,
    required String title,
    required String body,
    required String time,
    required IconData iconData,
    required bool isToday,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      child: Dismissible(
        key: Key(id),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          _deleteNotification(id);
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 15.w),
          child: SvgPicture.network('https://sixpack30.b-cdn.net/images/notification_delete_icon.svg',
            width: 26.w,
            height: 26.w,
          ),
        ),
        child: Container(
          width: 342.w,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFF3F3F3)),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF06C44F),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Center(
                  child: Icon(
                    iconData,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0D0D0D),
                              letterSpacing: -0.011.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          time,
                          style: GoogleFonts.montserrat(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4E4949),
                            letterSpacing: -0.011.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      body,
                      style: GoogleFonts.montserrat(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF4E4949),
                        letterSpacing: -0.011.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
