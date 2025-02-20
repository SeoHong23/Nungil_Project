import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:nungil/providers/auth_provider.dart';

class KakaoLoginService {
  final Ref ref;
  KakaoLoginService(this.ref);

  Future<bool> kakaoLogin() async {
    try {
      OAuthToken token;
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      User user = await UserApi.instance.me();
      String nickname = user.kakaoAccount?.profile?.nickname ?? "카카오 유저";
      String email = user.kakaoAccount?.email ?? "이메일 없음";

      ref.read(authProvider.notifier).login(
            user.id?.toInt() ?? 0,
            nickname,
            email,
            false
          );

      return true; // 토큰 반환
    } catch (error) {
      print("카카오 로그인 실패: $error");
      return false;
    }
  }
}

final kakaoLoginProvider = Provider((ref) => KakaoLoginService(ref));
