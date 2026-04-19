import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:six_pack_30/Core/Config/app_config.dart';
import 'package:six_pack_30/Core/Routes/app_routes.dart';

import 'package:six_pack_30/firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("bbb220aa-bfd2-456b-878d-595b1a3c5193");
  OneSignal.Notifications.requestPermission(true);

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
