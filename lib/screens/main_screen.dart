import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nungil/models/Video.dart';
import 'package:nungil/providers/auth_provider.dart';
import 'package:nungil/screens/home/home_page.dart';
import 'package:nungil/screens/list/list_page.dart';
import 'package:nungil/screens/ranking/ranking_page.dart';
import 'package:nungil/screens/user/login/login_view.dart';
import 'package:nungil/screens/user/user_page.dart';
import 'package:nungil/screens/video_detail/video_detail_page.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nungil/theme/common_theme.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key, this.toggleTheme});

  final VoidCallback? toggleTheme; // 🔥 임시 테마 변경 함수

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

  List<Widget> _screens = [
    // HomePage(),
    RankingPage(),
    ListPage(),
    UserPage(),
  ];

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

    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 700,
              ),
              child: Scaffold(
                body: PageView(
                  controller: _pageController,
                  onPageChanged: (value) => changePages(value),
                  children: [
                    HomePage(toggleTheme: widget.toggleTheme ?? () => {}),
                    RankingPage(),
                    ListPage(),
                    isLoggedIn ? LoginView() : UserPage(),
                    VideoDetailPage(item: "679c5eec7cf2875815230726"),
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
                    BottomNavigationBarItem(
                      label: '홈',
                      icon: Icon(CupertinoIcons.house_fill),
                    ),
                    BottomNavigationBarItem(
                      label: ' 랭킹',
                      icon: Icon(FontAwesomeIcons.rankingStar),
                    ),
                    BottomNavigationBarItem(
                      label: '리스트',
                      icon: Icon(CupertinoIcons.square_list_fill),
                    ),
                    BottomNavigationBarItem(
                      label: '유저',
                      icon: Icon(FontAwesomeIcons.solidUser),
                    ),
                    BottomNavigationBarItem(
                      label: '상세화면',
                      icon: Icon(FontAwesomeIcons.film),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
