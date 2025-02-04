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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'nungil',
      debugShowCheckedModeBanner: false,
      darkTheme: dTheme(),
      theme: mTheme(),
      themeMode: ThemeMode.light,
      home: const MainScreen(),
    );
  }
}
