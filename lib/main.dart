import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nungil/providers/auth_provider.dart';
import 'package:nungil/screens/main_screen.dart';
import 'package:nungil/theme/common_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = true; // 다크 모드 여부

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'nungil',
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? dTheme() : mTheme(), // 다크/라이트 테마 적용
      home: MainScreen(toggleTheme: _toggleTheme),
    );
  }
}
