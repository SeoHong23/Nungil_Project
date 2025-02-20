import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nungil/providers/theme_provider.dart';
import 'package:nungil/screens/main_screen.dart';
import 'package:nungil/theme/common_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 초기화

  final prefs = await SharedPreferences.getInstance();

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
