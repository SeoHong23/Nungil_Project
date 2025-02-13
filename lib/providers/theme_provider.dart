import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nungil/theme/common_theme.dart';

/// ✅ 테마 변경을 관리하는 StateNotifier
class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false); // 초기값: 라이트 모드 (false)

  void toggleTheme() {
    state = !state;
  }

  ThemeData get currentTheme => state ? dTheme() : mTheme();
}

/// ✅ 전역 Provider 선언
final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});
