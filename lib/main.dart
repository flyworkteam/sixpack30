import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:six_pack_30/Core/Config/app_config.dart';
import 'package:six_pack_30/Core/Routes/app_routes.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() {
  runApp(const ProviderScope(child: MyApp()));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: AppConfig.appName,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFFF2F5FC),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
            textTheme: GoogleFonts.nunitoSansTextTheme(
              Theme.of(context).textTheme,
            ),
            useMaterial3: true,
          ),
          initialRoute: AppRoutes.initial,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
