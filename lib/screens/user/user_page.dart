import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nungil/data/repository/user_movie_repository.dart';
import 'package:nungil/providers/auth_provider.dart';
import 'package:nungil/screens/main_screen.dart';
import 'package:nungil/screens/user/login/login_page.dart';
import 'package:nungil/screens/user/more/watched_page.dart';
import 'package:nungil/theme/common_theme.dart';

class UserPage extends ConsumerWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId =
        ref.watch(authProvider.select((state) => state.user?.userId));

    final nickName = ref.watch(authProvider.select((state) {
      if (state.user?.nickname == null) return '';

      final originalNickname = state.user!.nickname;

      try {
        final List<int> latin1Bytes = latin1.encode(originalNickname);
        return utf8.decode(latin1Bytes, allowMalformed: true);
      } catch (e) {
        return originalNickname;
      }
    }));

    final watchedCount = getWatchedMovie().length;
    final watchingCount = getWatchingMovie().length;
    final bookmarkedCount = getBookmarkedMovie().length;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          actions: [
            userId != null
                ? IconButton(
                    icon: const Icon(Icons.logout_rounded),
                    onPressed: () async {
                      final authNotifier = ref.read(authProvider.notifier);

                      await authNotifier.logout();

                      if (context.mounted) {
                        await authNotifier.checkLoginStatus();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainScreen()),
                        );
                      }
                    },
                  )
                : IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    icon: const Icon(Icons.login_rounded)),
            // 고객센터(도움말) 아이콘
            IconButton(
              icon: const Icon(Icons.help_outline), // 도움말 아이콘
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
              icon: const Icon(Icons.settings), // 설정 아이콘
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
            const SizedBox(height: 32), // 상단 여백 추가

            // 닉네임 (클릭 가능한 버튼)
            GestureDetector(
              onTap: () {},
              child: Text(
                userId == null ? '로그인 후 이용 가능합니다' : '안녕하세요, $nickName 님!',
                style: ColorTextStyle.largeNavy(context),
              ),
            ),

            const SizedBox(height: 16), // 닉네임 아래 여백
            // 구분선
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor, // 연한 회색 배경색
                  borderRadius: BorderRadius.circular(8.0), // 둥근 모서리
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 균등 정렬
                  children: [
                    _buildCategoryItem(bookmarkedCount, "찜했어요", context),
                    VerticalDivider(
                      color: Theme.of(context).colorScheme.secondary,
                      indent: 15,
                      endIndent: 15,
                    ),
                    _buildCategoryItem(watchingCount, "보는중", context),
                    VerticalDivider(
                      color: Theme.of(context).colorScheme.secondary,
                      indent: 15,
                      endIndent: 15,
                    ),
                    _buildCategoryItem(watchedCount, "봤어요", context),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WatchedPage()),
                    );
                  },
                  child: Text(
                    '본 작품 통계 >',
                    style: ColorTextStyle.largeNavy(context),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8.0), // 둥근 모서리
                ),
                child: Column(
                  children: [
                    // "작성한 리뷰 0 >"
                    _buildRowItem("작성한 리뷰", "0", context),

                    Divider(
                        color: Theme.of(context).colorScheme.secondary,
                        indent: 15,
                        endIndent: 15),

                    // "구독중인 서비스 >"
                    _buildRowItem("구독중인 서비스", "", context),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(int count, String label, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // 내용 중앙 정렬
      children: [
        Text(
          '$count',
          style: ColorTextStyle.largeNavy(context),
        ),
        Text(
          label,
          style: ColorTextStyle.mediumLightNavy(context),
        ),
      ],
    );
  }

  Widget _buildRowItem(String label, String count, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 항목들을 양쪽 끝으로 배치
        children: [
          Text(
            label,
            style: ColorTextStyle.largeNavy(context),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                count,
                style: ColorTextStyle.mediumNavy(context),
              ),
              const SizedBox(width: 8.0), // "0"과 ">" 사이 간격
              Text(
                ">",
                style: ColorTextStyle.mediumNavy(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
