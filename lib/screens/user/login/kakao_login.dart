import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:nungil/providers/auth_provider.dart';
import 'package:dio/dio.dart';

class KakaoLoginService {
  final Ref ref;

  KakaoLoginService(this.ref);

  Future<bool> kakaoLogin() async {
    try {
      // 카카오 로그인 시도
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      print("카카오 로그인 성공: 액세스 토큰 : ${token.accessToken}");

      // 카카오 사용자 정보 가져오기
      User user = await UserApi.instance.me();
      String nickname = user.kakaoAccount?.profile?.nickname ?? "카카오 유저";
      String email = user.kakaoAccount?.email ?? "no-email@example.com";
      String birthDay = user.kakaoAccount?.birthday ?? "";
      String birthYear = user.kakaoAccount?.birthyear ?? "";

      // 성별 정보 처리
      String gender = "MALE"; // 기본값
      if (user.kakaoAccount?.gender != null) {
        gender =
            user.kakaoAccount!.gender.toString().split('.').last.toUpperCase();
      }

      int birthDateInt = 0;

      if (birthYear.isNotEmpty && birthDay.isNotEmpty) {
        // YYYYMMDD 형식으로 변환
        birthDateInt = int.parse(birthYear + birthDay);
      } else if (birthDay.isNotEmpty) {
        // MMDD 형식만 있는 경우 (연도 없음)
        birthDateInt = int.parse(birthDay);
      } else {
        // 생일 정보가 없는 경우 기본값 0 사용
        birthDateInt = 0;
      }

// 디버깅을 위한 로그
      print(
          "카카오 계정 생일 정보: birthYear=$birthYear, birthDay=$birthDay, 변환된 정수=$birthDateInt");

      // 서버에 로그인 요청 보내기
      bool loginResult = await sendTokenToBackend(
          token.accessToken, email, nickname, gender, birthDateInt);
      return loginResult;
    } catch (error) {
      print("카카오 로그인 실패: $error");
      return false;
    }
  }

  Future<bool> sendTokenToBackend(String accessToken, String email,
      String nickname, String gender, int birthDateInt) async {
    try {
      print("서버로 전송할 데이터 준비 중...");

      // 요청 데이터 구성
      Map<String, dynamic> requestData = {
        "accessToken": accessToken,
        "email": email,
        "nickname": nickname,
        "gender": gender,
        "birthDate": birthDateInt
      };

      print("서버로 보낼 데이터: $requestData");
      print("요청 URL: http://13.239.238.92:8080/kakao/login");

      // Dio 인스턴스 생성 및 로깅 설정
      final dio = Dio();
      dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ));

      // 서버에 요청 보내기
      Response response = await dio.post(
        "http://13.239.238.92:8080/kakao/login",
        data: requestData,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
          validateStatus: (status) => true, // 모든 상태 코드 허용
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      print("서버 응답 상태 코드: ${response.statusCode}");
      print("서버 응답 데이터: ${response.data}");

      // 응답 처리
      if (response.statusCode == 200) {
        final responseData = response.data;
        final int userId = responseData['userId'] ?? 0;
        final bool admin = responseData['admin'] ?? false;

        // 로그인 상태 업데이트
        ref.read(authProvider.notifier).login(userId, nickname, email, admin);
        print(
            "카카오 로그인 성공: userId=$userId, nickname=$nickname, email=$email, admin=$admin");
        return true;
      } else {
        print("카카오 로그인 실패: 상태 코드 ${response.statusCode}, 응답: ${response.data}");
        return false;
      }
    } catch (e) {
      print("카카오 로그인 처리 중 오류 발생: $e");

      // Dio 예외인 경우 추가 정보 출력
      if (e is DioException) {
        print("Dio 에러 유형: ${e.type}");
        print("Dio 에러 메시지: ${e.message}");
        if (e.response != null) {
          print("응답 상태 코드: ${e.response?.statusCode}");
          print("응답 데이터: ${e.response?.data}");
        }
        print("요청 URL: ${e.requestOptions.uri}");
        print("요청 데이터: ${e.requestOptions.data}");
      }

      return false;
    }
  }
}

final kakaoLoginServiceProvider = Provider((ref) => KakaoLoginService(ref));
