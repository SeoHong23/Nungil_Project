import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:nungil/providers/auth_provider.dart';
import 'package:dio/dio.dart';

class KakaoLoginService {
  final Ref ref;
  KakaoLoginService(this.ref);

  Future<bool> kakaoLogin() async {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      print("카카오 로그인 성공: 액세스 토큰 : ${token.accessToken}");
      // if (await isKakaoTalkInstalled()) {
      //   token = await UserApi.instance.loginWithKakaoTalk();
      // } else {
      //   token = await UserApi.instance.loginWithKakaoAccount();
      // }

      User user = await UserApi.instance.me();
      String kakaoId = user.id.toString();
      String nickname = user.kakaoAccount?.profile?.nickname ?? "카카오 유저";
      String email = user.kakaoAccount?.email ?? "이메일 없음";
      await sendTokenToBackend(token.accessToken, kakaoId, email, nickname);

      // ref.read(authProvider.notifier).login(
      //       user.id?.toInt() ?? 0,
      //       nickname,
      //       email,
      //       false,
      //     );

      return true;
    } catch (error) {
      print("카카오 로그인 실패: $error");
      return false;
    }
  }

  Future<void> sendTokenToBackend(
      String accessToken, String kakaoId, String email, String nickname) async {
    try {
      Response response = await Dio().post(
        "http://13.239.238.92:8080/auth/kakao",
        data: {
          "access_token": accessToken,
          "kakaoId": kakaoId,
          "email": email,
          "nickname": nickname,
        },
      );
      final responseData = response.data;
      final int userId = responseData['userId'] ?? 0;
      final bool admin = responseData['admin'] ?? false;

      ref.read(authProvider.notifier).login(userId, nickname, email, admin);
      print("백엔드 로그인 : userId=$userId, nickname=$nickname, email=$email");
    } catch (e) {
      print("에러 :$e");
    }
  }
}

final kakaoLoginProvider = Provider((ref) => KakaoLoginService(ref));
