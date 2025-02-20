import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nungil/screens/main_screen.dart';
import 'package:nungil/providers/auth_provider.dart';
import 'package:nungil/screens/user/services/favorite_service.dart';
import 'package:nungil/screens/user/services/not_interested_service.dart';
import 'package:nungil/screens/user/services/watched_service.dart';
import 'package:nungil/screens/user/services/watching_service.dart';
import 'package:nungil/theme/common_theme.dart';

final favoriteCountProvider = FutureProvider<int>((ref) async {
  final authState = ref.watch(authProvider);
  final userId = authState.user?.userId;

  if (userId == null) return 0; // 로그인 안 됐을 경우 0

  final favoriteService = FavoriteService();
  return await favoriteService.getFavoriteCount(userId);
});

final watchedCountProvider = FutureProvider<int>((ref) async {
  final authState = ref.watch(authProvider);
  final userId = authState.user?.userId;

  if (userId == null) return 0; // 로그인 안 됐을 경우 0

  final watchedService = WatchedService();
  return await watchedService.getWatchedCount(userId);
});

final watchingCountProvider = FutureProvider<int>((ref) async {
  final authState = ref.watch(authProvider);
  final userId = authState.user?.userId;

  if (userId == null) return 0; // 로그인 안 됐을 경우 0

  final watchingService = WatchingService();
  return await watchingService.getWatchingCount(userId);
});

final notinterestedCountProvider = FutureProvider<int>((ref) async {
  final authState = ref.watch(authProvider);
  final userId = authState.user?.userId;

  if (userId == null) return 0; // 로그인 안 됐을 경우 0

  final notinterestedService = NotInterestedService();
  return await notinterestedService.getNotInterestedCount(userId);
});

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

    final favoriteCount = ref.watch(favoriteCountProvider).maybeWhen(
          data: (count) => count.toString(),
          orElse: () => "0", // 로딩 중이면 0 표시
        );

    final watchedCount = ref.watch(watchedCountProvider).maybeWhen(
          data: (count) => count.toString(),
          orElse: () => "0", // 로딩 중이면 0 표시
        );

    final watchingCount = ref.watch(watchingCountProvider).maybeWhen(
          data: (count) => count.toString(),
          orElse: () => "0", // 로딩 중이면 0 표시
        );

    final notinterestedCount = ref.watch(notinterestedCountProvider).maybeWhen(
          data: (count) => count.toString(),
          orElse: () => "0", // 로딩 중이면 0 표시
        );

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
            const SizedBox(height: 32), // 상단 여백 추가

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
                '안녕하세요, $nickName 님!',
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
                  borderRadius: BorderRadius.circular(12), // 둥근 모서리
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 균등 정렬
                  children: [
                    _buildCategoryItem(favoriteCount, "찜했어요",context),
                    Container(
                      width: 1, // 구분선의 두께
                      height: 40, // 구분선의 높이
                      color: Theme.of(context).colorScheme.secondary, // 구분선 색상
                    ),
                    _buildCategoryItem(watchingCount, "보는중",context),
                    Container(
                      width: 1, // 구분선의 두께
                      height: 40, // 구분선의 높이
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    _buildCategoryItem(watchedCount, "봤어요",context),
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
                  borderRadius: BorderRadius.circular(12), // 둥근 모서리
                ),
                child: Column(
                  children: [
                    // "작성한 리뷰 0 >"
                    _buildRowItem("작성한 리뷰", "0",context),

                    Divider(color: Theme.of(context).colorScheme.secondary,
                    indent: 15,endIndent: 15,),

                    // "관심없어요 0 >"
                    _buildRowItem("관심없어요", notinterestedCount,context),

                    Divider(color: Theme.of(context).colorScheme.secondary,
                      indent: 15,endIndent: 15,),
                    // "구독중인 서비스 >"
                    _buildRowItem("구독중인 서비스", "",context),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget _buildCategoryItem(String count, String label, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // 내용 중앙 정렬
      children: [
        Text(
          count,
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


