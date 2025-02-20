import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nungil/providers/theme_provider.dart';
import 'package:nungil/screens/main_screen.dart';
import 'package:nungil/theme/common_theme.dart';
import 'package:nungil/screens/user/user_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진 초기화

  final prefs = await SharedPreferences.getInstance();


  KakaoSdk.init(
      nativeAppKey: "8624912776c557f351ebf004d8aabcf5"); // 카카오 SDK 초기화


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
