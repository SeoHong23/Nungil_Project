import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:nungil/providers/theme_provider.dart';
import 'package:nungil/screens/main_screen.dart';
import 'package:nungil/theme/common_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
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
      home: MainScreen(),
    );
  }
}
