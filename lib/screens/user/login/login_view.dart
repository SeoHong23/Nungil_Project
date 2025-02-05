import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nungil/screens/main_screen.dart';
import 'package:nungil/providers/auth_provider.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // AuthProvider에서 로그인된 사용자 정보를 가져옵니다.
    final userEmail =
        ref.watch(authProvider.select((state) => state.user?.email));
    final nickName = ref.watch(authProvider.select((state) =>
        state.user?.nickname != null
            ? utf8.decode(state.user!.nickname!.codeUnits)
            : '사용자'));

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.logout), // 로그아웃 아이콘
              onPressed: () async {
                // 로그아웃 처리
                await ref.read(authProvider.notifier).logout();

                await ref.read(authProvider.notifier).checkLoginStatus();
                // 로그아웃 후 MainScreen으로 돌아가기
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
              },
            ),
            // 고객센터(도움말) 아이콘
            IconButton(
              icon: Icon(Icons.help_outline), // 도움말 아이콘
              onPressed: () {
                // 고객센터 페이지로 이동하는 기능 추가
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
              },
            ),
            // 설정(톱니바퀴) 아이콘
            IconButton(
              icon: Icon(Icons.settings), // 설정 아이콘
              onPressed: () {
                // 설정 페이지로 이동하는 기능 추가
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(height: 20), // 상단 여백 추가

            // 닉네임 (클릭 가능한 버튼)
            GestureDetector(
              onTap: () {
                print("닉네임 클릭됨!");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
              },
              child: Text(
                nickName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),

            SizedBox(height: 20), // 닉네임 아래 여백
            // 구분선
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  color: Color(0xFFB3E0FF), // 연한 회색 배경색
                  borderRadius: BorderRadius.circular(12), // 둥근 모서리
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 균등 정렬
                  children: [
                    _buildCategoryItem("0", "찜했어요"),
                    Container(
                      width: 1, // 구분선의 두께
                      height: 40, // 구분선의 높이
                      color: Colors.black, // 구분선 색상
                    ),
                    _buildCategoryItem("0", "보는중"),
                    Container(
                      width: 1, // 구분선의 두께
                      height: 40, // 구분선의 높이
                      color: Colors.black, // 구분선 색상
                    ),
                    _buildCategoryItem("0", "봤어요"),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6), // 위쪽 패딩
              child: Align(
                alignment: Alignment.center, // 중앙 정렬
                child: GestureDetector(
                  onTap: () {
                    // 텍스트 클릭 시 실행할 동작 추가
                    print("본 작품 통계 클릭됨!");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()),
                    );
                  },
                  child: Text(
                    '본 작품 통계 >',
                    style: TextStyle(
                      fontSize: 18, // 텍스트 크기
                      fontWeight: FontWeight.bold, // 두꺼운 글씨
                      color: Colors.blue, // 파란색 텍스트
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFB3E0FF), // 연한 파란색 배경색
                  borderRadius: BorderRadius.circular(12), // 둥근 모서리
                ),
                child: Column(
                  children: [
                    // "작성한 리뷰 0 >"
                    _buildRowItem("작성한 리뷰", "0"),

                    Container(
                      width: 310, // 구분선의 두께
                      height: 1, // 구분선의 높이
                      color: Colors.black, // 구분선 색상
                    ),

                    // "관심없어요 0 >"
                    _buildRowItem("관심없어요", "0"),

                    Container(
                      width: 310, // 구분선의 두께
                      height: 1, // 구분선의 높이
                      color: Colors.black, // 구분선 색상
                    ),

                    // "구독중인 서비스 >"
                    _buildRowItem("구독중인 서비스", ""),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildCategoryItem(String count, String label) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center, // 내용 중앙 정렬
    children: [
      Text(
        count,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 4),
      Text(
        label,
        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
      ),
    ],
  );
}

Widget _buildRowItem(String label, String count) {
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // 항목들을 양쪽 끝으로 배치
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Text(
              count,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(width: 4), // "0"과 ">" 사이 간격
            Text(
              ">",
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ],
        ),
      ],
    ),
  );
}
