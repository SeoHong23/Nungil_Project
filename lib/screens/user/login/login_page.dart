import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nungil/screens/user/login/email_login.dart';
import 'package:nungil/screens/user/login/kakao_login.dart';
import 'package:nungil/screens/user/term/term.dart';
import 'package:nungil/theme/common_theme.dart';

import 'package:nungil/providers/auth_provider.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ 올바른 Ref 타입 사용
    final kakaoLoginService = ref.read(kakaoLoginProvider);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/app.svg',
                width: 270,
                height: 270,
              ),
              const SizedBox(height: 12),
              const Text(
                '최근에 이메일로 로그인했어요!',
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 350, // 기존 버튼과 동일한 크기 유지
                child: GestureDetector(
                  onTap: () async {
                    print('✅ 로그인 버튼 클릭됨!'); // 로그 추가
                    bool token = await kakaoLoginService.kakaoLogin();
                    if (token != null) {
                      print("카카오 로그인 성공 : $token");
                      // TODO: 서버 토큰 전송
                    } else {
                      print("카카오 로그인 실패");
                    }
                  },
                  child: Image.asset(
                    'assets/images/login_icons/kakao_login_medium_wide.png',
                    fit: BoxFit.cover, // 이미지가 버튼 크기에 맞게 조정됨
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 350,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Color(0xFF00D070),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.only(left: 10.0), // 이미지 주변에 여백 추가
                        decoration: BoxDecoration(
                          color: const Color(0xFF00D070), // 이미지 배경색 설정
                          borderRadius: BorderRadius.circular(6), // 배경의 둥근 모서리
                        ),
                        child: Image.asset(
                          'assets/images/login_icons/naver_logo.jpg',
                          width: 26,
                          height: 26,
                        ),
                      ),
                      const Expanded(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(right: 20.0),
                            child: Text(
                              '네이버 로그인',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white, // 글자 색상 설정
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EmailLogin(), // Term 화면
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '이메일 로그인',
                        style: ColorTextStyle.mediumNavy(context),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '|',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // 이메일 회원가입 클릭 시 Term 화면으로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Term(), // Term 화면
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('이메일 회원가입',
                          style: ColorTextStyle.mediumNavy(context)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
