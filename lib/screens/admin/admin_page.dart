import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nungil/providers/auth_provider.dart';
import 'package:nungil/screens/main_screen.dart';
import 'package:nungil/screens/user/user_page.dart';

import 'component/admin_body_component.dart';

class AdminPage extends ConsumerWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("관리자"),
        centerTitle: true,
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
                MaterialPageRoute(builder: (context) => UserPage()),
              );
            },
          ),
        ],
      ),
      body: const AdminBodyComponent(),
    );
  }
}
