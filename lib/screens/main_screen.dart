import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nungil/models/Video.dart';
import 'package:nungil/screens/home/home_page.dart';
import 'package:nungil/screens/list/list_page.dart';
import 'package:nungil/screens/ranking/ranking_page.dart';
import 'package:nungil/screens/user/user_page.dart';
import 'package:nungil/screens/video_detail/video_detail_page.dart';
import 'package:nungil/theme/common_theme.dart';

/*
2025-01-21 강중원 - 생성
2025-01-21 강중원 - 스택페이지에서 페이지뷰 형식으로 바꿈

 */

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController();

  int _selectedIndex = 0;

  List<Widget> _screens = [
    HomePage(),
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
    return SafeArea(
      child: Container(
        color: baseBackgroundColor,
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
                  HomePage(),
                  RankingPage(),
                  ListPage(),
                  UserPage(),
                  VideoDetailPage(item: dummyVideo)
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
                    label: '_상세화면',
                    icon: Icon(FontAwesomeIcons.film),
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
