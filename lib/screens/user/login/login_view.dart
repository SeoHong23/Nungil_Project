import 'package:flutter/material.dart';
import 'package:nungil/providers/auth_provider.dart';
import 'package:nungil/screens/main_screen.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    // AuthProvider에서 로그인된 사용자 정보를 가져옵니다.
    final userEmail = Provider.of<AuthProvider>(context).userEmail;
    final nickName = Provider.of<AuthProvider>(context).nickname;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.logout), // 로그아웃 아이콘
              onPressed: () async {
                // 로그아웃 처리
                await Provider.of<AuthProvider>(context, listen: false)
                    .logout();

                await Provider.of<AuthProvider>(context, listen: false)
                    .checkLoginStatus();
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
        body: Center(
          child: userEmail != null && userEmail.isNotEmpty
              ? Text(
                  '로그인된 사용자: $nickName', // 로그인된 이메일을 출력
                  style: TextStyle(fontSize: 20),
                )
              : Text(
                  '로그인되지 않았습니다.',
                  style: TextStyle(fontSize: 20),
                ),
        ),
      ),
    );
  }
}
