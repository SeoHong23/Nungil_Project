import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:nungil/data/objectbox_helper.dart';
import 'package:nungil/notification/notification.dart';
import 'package:nungil/util/call_back_dispatcher.dart';
import 'package:nungil/util/schedule_daily_cache_update.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nungil/providers/theme_provider.dart';
import 'package:nungil/screens/main_screen.dart';
import 'package:nungil/theme/common_theme.dart';
import 'package:nungil/screens/user/user_page.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진 초기화

  final prefs = await SharedPreferences.getInstance();
  final objectBox = ObjectBox();
  await objectBox.init();

  KakaoSdk.init(
      nativeAppKey: "8624912776c557f351ebf004d8aabcf5"); // 카카오 SDK 초기화

  final keyHash = await KakaoSdk.origin;
  print("현재 사용중인 키 해시 : $keyHash");

  //백그라운드 작업 준비
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  // 앱 실행 시, 백그라운드 작업 예약
  scheduleDailyCacheUpdate();

  //로컬 타임존 초기화
  await FlutterLocalNotification.initializeTimezone();
  FlutterLocalNotification.init();

  runApp(
    ProviderScope(
      overrides: [
        themeProvider.overrideWith((ref) => ThemeNotifier(prefs)), // 초기값 적용
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    return MaterialApp(
      title: 'nungil',
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? dTheme() : mTheme(), // 다크/라이트 테마 적용
      home: const MainScreen(),
    );
  }
}
