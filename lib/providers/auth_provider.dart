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

  // Future<void> handleKakaoLogin(
  //     String kakaoId, String email, String nickname) async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //
  //     // 서버로 카카오 로그인 정보 전송
  //     final response = await http.post(
  //       Uri.parse('http://13.239.238.92:8080/kakao/login'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: json.encode({
  //         'kakaoId': kakaoId,
  //         'email': email,
  //         'nickname': nickname,
  //       }),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //
  //       // 서버에서 받은 userId로 UserModel 생성
  //       final user = UserModel(
  //         userId: data['userId'], // 서버에서 생성된 일반 userId
  //         kakaoId: kakaoId, // 카카오 ID 저장
  //         email: email,
  //         nickname: nickname,
  //       );
  //
  //       // 상태 업데이트
  //       state = AuthState(isAuthenticated: true, user: user);
  //
  //       // SharedPreferences에 저장
  //       await prefs.setBool('isLoggedIn', true);
  //       await prefs.setInt('userId', data['userId']);
  //       await prefs.setString('userEmail', email);
  //       await prefs.setString('nickname', nickname);
  //       await prefs.setString('kakaoId', kakaoId); // 카카오 ID도 저장
  //     } else {
  //       throw Exception('Server error: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('카카오 로그인 에러: $e');
  //     throw Exception('카카오 로그인 실패');
  //   }
  // }

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
          'access_token': accessToken, // 액세스 토큰 추가
          'kakaoId': kakaoId,
          'email': email,
          'nickname': nickname,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final data = json.decode(responseBody);

        // 4️⃣ 서버에서 받은 userId로 UserModel 생성
        final user = UserModel(
          userId: data['userId'],
          kakaoId: kakaoId,
          email: email,
          nickname: nickname,
        );

        // 5️⃣ 상태 업데이트
        state = AuthState(isAuthenticated: true, user: user);

        // 6️⃣ SharedPreferences에 저장
        await prefs.setBool('isLoggedIn', true);
        await prefs.setInt('userId', data['userId']);
        await prefs.setString('userEmail', email);
        await prefs.setString('nickname', nickname);
        await prefs.setString('kakaoId', kakaoId);
        await prefs.setString('access_token', accessToken); // 액세스 토큰 저장
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
