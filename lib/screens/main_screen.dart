import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nungil/providers/auth_provider.dart';
import 'package:nungil/screens/home/home_page.dart';
import 'package:nungil/screens/list/list_page.dart';
import 'package:nungil/screens/ranking/ranking_page.dart';
import 'package:nungil/screens/user/login/login_page.dart';
import 'package:nungil/screens/user/user_page.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'admin/admin_page.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final PageController _pageController = PageController();

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // 로그인 상태를 확인합니다.
    ref.read(authProvider.notifier).checkLoginStatus();
  }

  void changePages(int index) {
    setState(
      () {
        _selectedIndex = index;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 로그인 여부를 확인합니다.
    final isLoggedIn =
        ref.watch(authProvider.select((state) => state.isAuthenticated));
    final isAdmin =
        ref.watch(authProvider.select((state) => state.isAdmin)) ?? false;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 700,
            ),
            child: Scaffold(
              body: PageView(
                controller: _pageController,
                onPageChanged: (value) => changePages(value),
                children: [
                  const HomePage(),
                  const RankingPage(),
                  const ListPage(),
                  isAdmin ? const AdminPage() : const UserPage()
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: _selectedIndex,
                onTap: (index) {
                  changePages(index);
                  _pageController.jumpToPage(_selectedIndex);
                },
                items: [
                  const BottomNavigationBarItem(
                    label: '홈',
                    icon: Icon(CupertinoIcons.house_fill),
                  ),
                  const BottomNavigationBarItem(
                    label: ' 랭킹',
                    icon: Icon(FontAwesomeIcons.rankingStar),
                  ),
                  const BottomNavigationBarItem(
                    label: '리스트',
                    icon: Icon(CupertinoIcons.square_list_fill),
                  ),
                  isAdmin
                      ? const BottomNavigationBarItem(
                          label: '관리자',
                          icon: Icon(FontAwesomeIcons.solidStar),
                        )
                      : const BottomNavigationBarItem(
                          label: '유저',
                          icon: Icon(FontAwesomeIcons.solidUser),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
