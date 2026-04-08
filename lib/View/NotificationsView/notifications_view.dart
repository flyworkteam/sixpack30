import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});
  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}
class _NotificationsViewState extends State<NotificationsView> {
  List<Map<String, dynamic>> todayNotifications = [
    {
      'id': '1',
      'title': 'Spor saatin geldi',
      'body': 'Bugün antrenman günün 💪 Hedefine bir adım daha yaklaşma zamanı.',
      'time': '12:00',
      'icon': Icons.sports_gymnastics,
    },
    {
      'id': '2',
      'title': 'Son 2 set',
      'body': 'Şimdiye kadar harikasın. Devam et! Yanma hissi = gelişim.',
      'time': '2 saat önce',
      'icon': Icons.fitness_center,
    },
    {
      'id': '3',
      'title': 'İlerleme',
      'body': '5 gündür üst üste aktif! Kendinle gurur duyma zamanı.',
      'time': '6 saat önce',
      'icon': Icons.trending_up,
    },
  ];
  List<Map<String, dynamic>> yesterdayNotifications = [
    {
      'id': '4',
      'title': 'Harekete Geç',
      'body': '10 dakika bile yeter. Başla. Bugün kendin için bir şey yap.',
      'time': '1 gün önce',
      'icon': Icons.directions_run,
    },
    {
      'id': '5',
      'title': 'Bugünün Görevleri Tamamlandı',
      'body': 'Günün tüm sorumluluklarını tamamladın, şimdi dinlenme zamanı.',
      'time': '1 gün önce',
      'icon': Icons.check_circle_outline,
    },
    {
      'id': '6',
      'title': 'Motivasyon',
      'body': 'Ertelemek mi, başlamak mı? Seçim senin. Güç, konfor alanının dışında.',
      'time': '1 gün önce',
      'icon': Icons.sports_martial_arts,
    },
  ];
  void _deleteAll() {
    setState(() {
      todayNotifications.clear();
      yesterdayNotifications.clear();
    });
  }
  void _deleteNotification(String id, bool isToday) {
    setState(() {
      if (isToday) {
        todayNotifications.removeWhere((item) => item['id'] == id);
      } else {
        yesterdayNotifications.removeWhere((item) => item['id'] == id);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
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
          'Bildirimler',
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
                  'Tümünü sil',
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
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15.h),
              SizedBox(height: 20.h),
              if (todayNotifications.isNotEmpty) ...[
                Text(
                  'Bugün',
                  style: GoogleFonts.nunito(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0D0D0D),
                    letterSpacing: -0.011.sp,
                  ),
                ),
                SizedBox(height: 15.h),
                ...todayNotifications.map((item) {
                  return _buildNotificationItem(
                    id: item['id'],
                    title: item['title'],
                    body: item['body'],
                    time: item['time'],
                    iconData: item['icon'],
                    isToday: true,
                  );
                }),
                SizedBox(height: 15.h),
              ],
              if (yesterdayNotifications.isNotEmpty) ...[
                Text(
                  'Dün',
                  style: GoogleFonts.nunito(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0D0D0D),
                    letterSpacing: -0.011.sp,
                  ),
                ),
                SizedBox(height: 15.h),
                ...yesterdayNotifications.map((item) {
                  return _buildNotificationItem(
                    id: item['id'],
                    title: item['title'],
                    body: item['body'],
                    time: item['time'],
                    iconData: item['icon'],
                    isToday: false,
                  );
                }),
                SizedBox(height: 30.h),
              ],
            ],
          ),
        ),
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
          _deleteNotification(id, isToday);
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 15.w),
          child: SvgPicture.asset(
            'assets/images/notification_delete_icon.svg',
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
