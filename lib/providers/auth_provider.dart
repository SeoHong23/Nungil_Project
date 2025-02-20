import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nungil/models/user/user_model.dart';
import 'package:nungil/screens/user/login/kakao_login.dart';

// AuthState 데이터 모델 (로그인 상태 저장)
class AuthState {
  final bool isAuthenticated;
  final UserModel? user;
  final bool? isAdmin;


  AuthState({required this.isAuthenticated, this.user, this.isAdmin});

  AuthState copyWith({bool? isAuthenticated, UserModel? user}) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
    );
  }
}

// StateNotifier를 사용하는 AuthProvider
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(isAuthenticated: false));

  Future<void> login(int userId, String nickname, String email, bool admin) async {
    final user = UserModel(
      userId: userId,
      nickname: nickname,
      email: email,
    );
    state = AuthState(isAuthenticated: true, user: user);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setInt('userId', userId); // userId 저장
    await prefs.setString('userEmail', email);
    await prefs.setString('nickname', nickname);
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final userId = prefs.getInt('userId'); // userId 가져오기
    final nickname = prefs.getString('nickname');
    final email = prefs.getString('userEmail');

    if (nickname == null || email == null) {
      print("🚨 저장된 사용자 데이터가 손상됨! 기본값으로 설정합니다.");
      await prefs.clear(); // 손상된 데이터 삭제
      return;
    }

    if (isLoggedIn && userId != null && email != null && nickname != null) {
      state = AuthState(
        isAuthenticated: true,
        user: UserModel(userId: userId, email: email, nickname: nickname),
      );
    }
  }

  Future<void> logout() async {
    state = AuthState(isAuthenticated: false, user: null);

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
final kakaoLoginProvider = Provider((ref) => KakaoLoginService(ref));
