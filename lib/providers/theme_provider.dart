import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nungil/theme/common_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

///   테마 변경을 관리하는 StateNotifier
class ThemeNotifier extends StateNotifier<bool> {
  static const String _themeKey = 'isDarkMode';
  final SharedPreferences prefs;

  ThemeNotifier(this.prefs) : super(prefs.getBool(_themeKey) ?? false);

  Future<void> toggleTheme() async {
    state = !state; // 상태 변경
    await prefs.setBool(_themeKey, state); // 변경된 값 저장
  }

  ThemeData get currentTheme => state ? dTheme() : mTheme();
}

///   전역 Provider 선언
final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  throw UnimplementedError('main.dart에서 override 해주세요.');
});
