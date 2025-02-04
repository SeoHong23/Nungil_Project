import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// User 모델
class User {
  final String email;
  final String nickname;
  User({required this.email, required this.nickname});
}

// AuthState 데이터 모델 (로그인 상태 저장)
class AuthState {
  final bool isAuthenticated;
  final User? user;

  AuthState({required this.isAuthenticated, this.user});

  AuthState copyWith({bool? isAuthenticated, User? user}) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
    );
  }
}

// StateNotifier를 사용하는 AuthProvider
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(isAuthenticated: false));

  Future<void> login(String email, String nickname) async {
    final user = User(email: email, nickname: nickname);
    state = AuthState(isAuthenticated: true, user: user);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userEmail', email);
    await prefs.setString('nickname', nickname);
  }

  Future<void> logout() async {
    state = AuthState(isAuthenticated: false, user: null);

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final email = prefs.getString('userEmail');
    final nickname = prefs.getString('nickname');

    if (isLoggedIn && email != null && nickname != null) {
      state = AuthState(
          isAuthenticated: true, user: User(email: email, nickname: nickname));
    }
  }
}

// Provider 선언
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
