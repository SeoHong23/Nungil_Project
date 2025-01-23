import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'email_login/email_login.dart';
import 'term/term.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/app.svg',
                width: 270,
                height: 270,
              ),
              SizedBox(height: 12),
              Text(
                '최근에 이메일로 로그인했어요!',
              ),
              SizedBox(height: 30),
              SizedBox(
                width: 350,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Color(0xFFF8E300),
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
                          color: const Color(0xFFF8E300), // 이미지 배경색 설정
                          borderRadius: BorderRadius.circular(6), // 배경의 둥근 모서리
                        ),
                        child: Image.asset(
                          'assets/images/login_icons/kakao_bubble.png',
                          width: 23,
                          height: 23,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Text(
                              '카카오로 시작하기',
                              style: TextStyle(
                                color: Colors.black, // 글자 색상 설정
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 350,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Text(
                              '네이버로 시작하기',
                              style: TextStyle(
                                color: Colors.white, // 글자 색상 설정
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
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
                    child: Text(
                      '이메일 로그인    ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                    child: Text(
                      '   이메일 회원가입',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
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
