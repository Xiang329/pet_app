import 'dart:ui';

import 'package:pet_app/common/app_colors.dart';
import 'package:pet_app/providers/auth_provider.dart';
import 'package:pet_app/providers/common_soon_notify_provider.dart';
import 'package:pet_app/providers/item_provider.dart';
import 'package:pet_app/providers/member_provider.dart';
import 'package:pet_app/providers/pet_admin_provider.dart';
import 'package:pet_app/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    // options: DefaultFirebaseOptions.web,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthModel()),
        ChangeNotifierProvider(create: (context) => CommonSoonNotifyProvider()),
        ChangeNotifierProvider(create: (context) => PetAdminsProvider()),
        ChangeNotifierProvider(create: (context) => ItemProvider()),
        ChangeNotifierProvider(create: (context) => MemberProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 自定義滾動行為
      scrollBehavior: AppScrollBehavior(),
      // 指定Widget使用本地化語言
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // App支援的語言
      supportedLocales: const [
        Locale('zh', 'TW'),
        Locale('en', 'US'),
      ],
      // 初始語言
      locale: const Locale('zh'),
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          scrolledUnderElevation: 0.0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: UiColor.text1_color,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          primary: Colors.black54,
          surface: Colors.white,
          background: Colors.white,
          surfaceTint: Colors.transparent,
        ),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.loadPage,
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

// 讓滑鼠可以觸發滑動行為(Web)
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
