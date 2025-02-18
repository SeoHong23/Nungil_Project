import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nungil/util/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

// User 모델
class User {
  final int userId;
  final String nickname;
  final String email;
  final bool admin;

  User(
      {required this.userId,
      required this.nickname,
      required this.email,
      required this.admin});
}

// AuthState 데이터 모델 (로그인 상태 저장)
class AuthState {
  final bool isAuthenticated;
  final bool? isAdmin;
  final User? user;

  AuthState({required this.isAuthenticated, this.user, this.isAdmin});

  AuthState copyWith({bool? isAuthenticated, User? user, bool? isAdmin}) {
    return AuthState(
        isAuthenticated: isAuthenticated ?? this.isAuthenticated,
        user: user ?? this.user,
        isAdmin: isAdmin ?? this.isAdmin);
  }
}

// StateNotifier를 사용하는 AuthProvider
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(isAuthenticated: false));

  Future<void> login(
      int userId, String nickname, String email, bool admin) async {
    final user = User(
      userId: userId,
      nickname: nickname,
      email: email,
      admin: admin,
    );
    state = AuthState(isAuthenticated: true, user: user, isAdmin: admin);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setInt('userId', userId); // userId 저장
    await prefs.setString('userEmail', email);
    await prefs.setString('nickname', nickname);
    await prefs.setBool('admin', admin);
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final userId = prefs.getInt('userId'); // userId 가져오기
    final nickname = prefs.getString('nickname');
    final email = prefs.getString('userEmail');
    final admin = prefs.getBool('admin');

    if (isLoggedIn && userId != null && email != null && nickname != null) {
      state = AuthState(
          isAuthenticated: true,
          user: User(
              userId: userId,
              email: email,
              nickname: nickname,
              admin: admin ?? false),
          isAdmin: admin ?? false);
      // 🔥 UI 갱신을 위해 추가
      WidgetsBinding.instance.addPostFrameCallback((_) {
        state = state.copyWith();
      });
    }
  }

  Future<void> logout() async {
    state = AuthState(isAuthenticated: false, user: null, isAdmin: false);

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

// Provider 선언
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

final userIdProvider = Provider<int?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.isAuthenticated ? authState.user?.userId : null;
});
