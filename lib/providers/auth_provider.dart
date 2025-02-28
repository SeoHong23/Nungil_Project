import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
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

  Future<void> handleKakaoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 1️⃣ 카카오 로그인 진행 후 액세스 토큰 가져오기
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      String accessToken = token.accessToken;

      // 2️⃣ 카카오 사용자 정보 가져오기
      User user = await UserApi.instance.me();
      String kakaoId = user.id.toString();
      String nickname = user.kakaoAccount?.profile?.nickname ?? "카카오 유저";
      String email = user.kakaoAccount?.email ?? "이메일 없음";

      print(
          "✅ 카카오 로그인 성공! (kakaoId: $kakaoId, email: $email, nickname: $nickname)");

      // 3️⃣ 서버로 액세스 토큰 및 사용자 정보 전송
      final response = await http.post(
        Uri.parse('http://13.239.238.92:8080/kakao/login'),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: json.encode({
          'access_token': accessToken, // 🔹 여기에 카카오 액세스 토큰 포함
          'kakaoId': kakaoId,
          'email': email,
          'nickname': nickname,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final data = json.decode(responseBody);

        // ✅ SharedPreferences에 저장
        await prefs.setBool('isLoggedIn', true);
        await prefs.setInt('userId', data['userId']);
        await prefs.setString('userEmail', email);
        await prefs.setString('nickname', nickname);
        await prefs.setString('kakaoId', kakaoId);

        // ✅ 서버 응답에 access_token이 있는지 확인하고 저장
        String? serverToken = data['access_token']; // 서버에서 받은 토큰
        String finalToken = serverToken ?? accessToken; // 서버 토큰이 없으면 카카오 토큰 사용
        await prefs.setString('access_token', finalToken);

        // ✅ 저장된 값 확인
        String? storedToken = prefs.getString('access_token');
        if (storedToken == null || storedToken.isEmpty) {
          print("🚨 토큰 저장 실패! SharedPreferences에 값이 저장되지 않았습니다.");
        } else {
          print("✅ SharedPreferences에 저장된 access_token: $storedToken");
        }

        // 4️⃣ 상태 업데이트
        state = AuthState(
            isAuthenticated: true,
            user: UserModel(
              userId: data['userId'],
              kakaoId: kakaoId,
              email: email,
              nickname: nickname,
            ));
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ 카카오 로그인 에러: $e');
      throw Exception('카카오 로그인 실패');
    }
  }

  Future<void> login(
      int userId, String nickname, String email, bool admin) async {
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
    final kakaoId = prefs.getString('kakaoId');

    if (nickname == null || email == null) {
      print("🚨 저장된 사용자 데이터가 손상됨! 기본값으로 설정합니다.");
      await prefs.clear(); // 손상된 데이터 삭제
      return;
    }

    if (isLoggedIn && userId != null && email != null && nickname != null) {
      state = AuthState(
        isAuthenticated: true,
        user: UserModel(
          userId: userId,
          email: email,
          nickname: nickname,
          kakaoId: kakaoId,
        ),
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
