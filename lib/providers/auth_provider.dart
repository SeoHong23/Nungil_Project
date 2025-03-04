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
  final String? accessToken; // 토큰 필드 추가

  AuthState(
      {required this.isAuthenticated,
      this.user,
      this.isAdmin,
      this.accessToken});

  AuthState copyWith(
      {bool? isAuthenticated,
      UserModel? user,
      bool? isAdmin,
      String? accessToken}) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      isAdmin: isAdmin ?? this.isAdmin,
      accessToken: accessToken ?? this.accessToken,
    );
  }
}

// StateNotifier를 사용하는 AuthProvider
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(isAuthenticated: false));

  Future<void> handleKakaoLogin() async {
    try {
      // SharedPreferences 인스턴스 가져오기
      final prefs = await SharedPreferences.getInstance();

      // 이전 로그인 데이터 초기화
      await clearStoredCredentials();

      //   카카오 로그인 진행 후 액세스 토큰 가져오기
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      String accessToken = token.accessToken;
      print("  카카오 로그인 토큰 획득: ${accessToken.substring(0, 10)}...");

      // 카카오 사용자 정보 가져오기
      User user = await UserApi.instance.me();
      String kakaoId = user.id.toString();
      String nickname = user.kakaoAccount?.profile?.nickname ?? "카카오 유저";
      String email = user.kakaoAccount?.email ?? "이메일 없음";

      print(
          "  카카오 로그인 성공! (kakaoId: $kakaoId, email: $email, nickname: $nickname)");

      // 서버로 액세스 토큰 및 사용자 정보 전송
      final response = await http.post(
        Uri.parse('http://13.239.238.92:8080/kakao/login'),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: json.encode({
          'access_token': accessToken, // 카카오 액세스 토큰 포함
          'kakaoId': kakaoId,
          'email': email,
          'nickname': nickname,
        }),
      );

      print("  서버 요청 완료, 상태 코드: ${response.statusCode}");
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        print("  서버 응답 원본: $responseBody");

        final data = json.decode(responseBody);
        print("  서버 응답 데이터: $data");

        // 응답에서 userId와 토큰 확인
        if (data['userId'] == null) {
          print(" 서버 응답에 userId가 없습니다!");
          throw Exception('서버 응답에 userId가 없습니다');
        }

        int userId = data['userId'];
        // 서버에서 온 토큰 또는 카카오 토큰
        String finalToken = data['access_token'] ?? accessToken;
        print("  최종 사용 토큰: ${finalToken.substring(0, 10)}...");

        //   새로운 저장 방식 적용
        await storeCredentials(
          isLoggedIn: true,
          userId: userId,
          email: email,
          nickname: nickname,
          kakaoId: kakaoId,
          accessToken: finalToken,
        );

        // 토큰이 저장되었는지 즉시 확인
        final storedToken = prefs.getString('access_token');
        print(
            "  저장 직후 토큰 확인: ${storedToken != null ? '있음 (${storedToken.substring(0, 10)}...)' : '없음'}");

        if (storedToken == null || storedToken.isEmpty) {
          // 토큰 저장 실패 시 다시 시도
          print(" 토큰 저장 실패! 다시 시도합니다...");
          bool tokenSaved = await prefs.setString('access_token', finalToken);
          print("  토큰 재저장 결과: $tokenSaved");

          // 다시 확인
          final retryToken = prefs.getString('access_token');
          print("  재시도 후 토큰 확인: ${retryToken != null ? '있음' : '없음'}");
        }

        // 상태 업데이트
        state = AuthState(
          isAuthenticated: true,
          user: UserModel(
            userId: userId,
            kakaoId: kakaoId,
            email: email,
            nickname: nickname,
          ),
          isAdmin: data['admin'] ?? false,
          accessToken: finalToken, // 토큰을 상태에 저장
        );

        print(
            "  로그인 상태 업데이트 완료: ${state.isAuthenticated}, 토큰: ${state.accessToken != null ? '있음' : '없음'}");
      } else {
        print(" 서버 응답 오류: ${response.statusCode}, 응답: ${response.body}");
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print(' 카카오 로그인 에러: $e');
      state = AuthState(isAuthenticated: false, user: null, accessToken: null);
      await clearStoredCredentials();
      throw Exception('카카오 로그인 실패: $e');
    }
  }

  // 인증 정보 저장 함수 분리 (코드 재사용성 증가)
  Future<bool> storeCredentials({
    required bool isLoggedIn,
    required int userId,
    required String email,
    required String nickname,
    String? kakaoId,
    required String accessToken,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 모든 저장 작업이 성공적으로 완료되었는지 확인
      bool isLoggedInSaved = await prefs.setBool('isLoggedIn', isLoggedIn);
      bool userIdSaved = await prefs.setInt('userId', userId);
      bool emailSaved = await prefs.setString('userEmail', email);
      bool nicknameSaved = await prefs.setString('nickname', nickname);

      // 옵셔널 필드는 존재할 때만 저장
      bool kakaoIdSaved = true;
      if (kakaoId != null) {
        kakaoIdSaved = await prefs.setString('kakaoId', kakaoId);
      }

      // 액세스 토큰 저장 - 중요!!
      bool tokenSaved = await prefs.setString('access_token', accessToken);

      print("  SharedPreferences 저장 결과:");
      print("- isLoggedIn: $isLoggedInSaved");
      print("- userId: $userIdSaved");
      print("- email: $emailSaved");
      print("- nickname: $nicknameSaved");
      print("- kakaoId: $kakaoIdSaved");
      print("- accessToken: $tokenSaved");

      // 모든 중요 값이 저장되었는지 확인
      bool allSaved = isLoggedInSaved &&
          userIdSaved &&
          emailSaved &&
          nicknameSaved &&
          tokenSaved;

      if (!allSaved) {
        print(" 일부 데이터 저장 실패!");
      }

      return allSaved;
    } catch (e) {
      print(" 인증 정보 저장 오류: $e");
      return false;
    }
  }

  // 저장된 인증 정보 초기화
  Future<void> clearStoredCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 로그인 관련 모든 키 제거
      await prefs.remove('isLoggedIn');
      await prefs.remove('userId');
      await prefs.remove('userEmail');
      await prefs.remove('nickname');
      await prefs.remove('kakaoId');
      await prefs.remove('access_token');

      print("  저장된 인증 정보 초기화 완료");
    } catch (e) {
      print(" 인증 정보 초기화 오류: $e");
    }
  }

  Future<void> login(int userId, String nickname, String email, bool admin,
      String accessToken) async {
    try {
      // 이전 데이터 초기화
      await clearStoredCredentials();

      // 새 데이터 저장
      bool stored = await storeCredentials(
        isLoggedIn: true,
        userId: userId,
        email: email,
        nickname: nickname,
        accessToken: accessToken,
      );

      if (!stored) {
        print(" 로그인 정보 저장 실패!");
        throw Exception('로그인 정보 저장 실패');
      }

      // 상태 업데이트
      final user = UserModel(
        userId: userId,
        nickname: nickname,
        email: email,
      );

      state = AuthState(
          isAuthenticated: true,
          user: user,
          isAdmin: admin,
          accessToken: accessToken // 토큰을 상태에 저장
          );

      print("  로그인 완료: userId=$userId, 토큰 있음=${accessToken.isNotEmpty}");
    } catch (e) {
      print(' 로그인 오류: $e');
      state = AuthState(isAuthenticated: false, user: null, accessToken: null);
      throw Exception('로그인 실패: $e');
    }
  }

  Future<void> checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 저장된 모든 인증 정보 가져오기
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      final userId = prefs.getInt('userId');
      final nickname = prefs.getString('nickname');
      final email = prefs.getString('userEmail');
      final kakaoId = prefs.getString('kakaoId');
      final accessToken = prefs.getString('access_token');

      print("  저장된 로그인 정보 확인:");
      print("- isLoggedIn: $isLoggedIn");
      print("- userId: $userId");
      print("- nickname: $nickname");
      print("- email: $email");
      print("- kakaoId: $kakaoId");
      print(
          "- accessToken: ${accessToken != null ? '있음 (${accessToken.length} 글자)' : '없음'}");

      if (!isLoggedIn || userId == null) {
        print(" 로그인 정보가 없거나 userId가 없습니다. 로그아웃 상태로 설정합니다.");
        state =
            AuthState(isAuthenticated: false, user: null, accessToken: null);
        return;
      }

      if (accessToken == null || accessToken.isEmpty) {
        print("⚠️ 토큰이 없지만 다른 정보는 있습니다. 부분 로그인 상태입니다.");
        if (nickname != null && email != null) {
          // 토큰이 없어도 다른 정보로 로그인 상태 유지 (제한된 기능만 사용 가능)
          state = AuthState(
            isAuthenticated: true,
            user: UserModel(
              userId: userId,
              email: email,
              nickname: nickname,
              kakaoId: kakaoId,
            ),
            accessToken: null, // 토큰 없음
          );
          print("  제한된 로그인 상태로 복원됨 (토큰 없음)");
          return;
        }
      }

      if (nickname == null || email == null) {
        print(" 저장된 사용자 데이터가 손상되었습니다! 기본값으로 설정합니다.");
        await clearStoredCredentials();
        state =
            AuthState(isAuthenticated: false, user: null, accessToken: null);
        return;
      }

      // 유효한 상태로 복원
      state = AuthState(
        isAuthenticated: true,
        user: UserModel(
          userId: userId,
          email: email,
          nickname: nickname,
          kakaoId: kakaoId,
        ),
        accessToken: accessToken, // 토큰을 상태에 저장
      );

      print(
          "  로그인 상태 복원 완료: ${state.isAuthenticated}, userId: ${state.user?.userId}, 토큰 있음=${state.accessToken != null}");
    } catch (e) {
      print(' 로그인 상태 확인 에러: $e');
      state = AuthState(isAuthenticated: false, user: null, accessToken: null);
      // 오류 발생 시 로그인 정보 초기화
      await clearStoredCredentials();
    }
  }

  Future<void> logout() async {
    try {
      await clearStoredCredentials();
      state = AuthState(isAuthenticated: false, user: null, accessToken: null);
      print("  로그아웃 완료 및 SharedPreferences 초기화됨");
    } catch (e) {
      print(' 로그아웃 에러: $e');
      // 오류가 발생해도 상태는 로그아웃으로 변경
      state = AuthState(isAuthenticated: false, user: null, accessToken: null);
    }
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

// 토큰 프로바이더 추가
final accessTokenProvider = Provider<String?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.accessToken;
});

final kakaoLoginProvider = Provider((ref) => KakaoLoginService(ref));
