import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nungil/data/repository/Banner_repository.dart';
import 'package:nungil/data/repository/video_list_repository.dart';
import 'package:nungil/models/admin/banner_model.dart';
import 'package:nungil/models/home/home_review_tmp.dart';
import 'package:nungil/models/list/video_list_model.dart';
import 'package:nungil/models/list/video_list_tmp.dart';
import 'package:nungil/models/ranking/video_rank_model.dart';
import 'package:nungil/screens/common_components/video_list_component.dart';
import 'package:nungil/screens/home/components/rank_management.dart';
import 'package:nungil/screens/search/search_page.dart';
import 'package:nungil/theme/common_theme.dart';
import 'package:nungil/util/my_http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common_components/ranking_list_component.dart';
import 'home_Movie_list_component.dart';
import 'home_ranking_component.dart';
import 'home_review_component.dart';

/// 2025-01-27 강중원 컴포넌트 생성
///

class HomeBodyComponent extends StatefulWidget {
  const HomeBodyComponent({super.key});

  @override
  State<HomeBodyComponent> createState() => _HomeBodyComponentState();
}

class _HomeBodyComponentState extends State<HomeBodyComponent> {
  List<VideoRankModel> dailyRanking = [];
  List<VideoRankModel> weeklyRanking = [];
  BannerModel? randomAd;
  List<VideoListModel> randomMovies = [];
  List<VideoListModel> latestMovies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => fetchHomeData());
  }

  void searchTitle(String value) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(keyword: value),
      ),
    );
  }

  Future<void> fetchHomeData() async {
    final repository = VideoListRepository();
    final bannerRepository = BannerRepository();
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];

    setState(() => isLoading = true);

    try {
      // ✅ 캐싱된 데이터 확인 (있으면 바로 적용)
      final cachedDailyRanking =
          loadCachedRanking(prefs, 'daily_ranking_$today');
      if (cachedDailyRanking != null) {
        setState(() => dailyRanking = cachedDailyRanking);
      } else {
        repository.fetchRanksDaily().then((data) {
          setState(() => dailyRanking = data);
          cacheRanking(prefs, 'daily_ranking_$today', data);
        }).catchError((e) => print("Error fetching daily ranks: $e"));
      }

      final cachedWeeklyRanking =
          loadCachedRanking(prefs, 'weekly_ranking_$today');
      if (cachedWeeklyRanking != null) {
        setState(() => weeklyRanking = cachedWeeklyRanking);
      } else {
        repository.fetchRanksWeekly().then((data) {
          setState(() => weeklyRanking = data);
          cacheRanking(prefs, 'weekly_ranking_$today', data);
        }).catchError((e) => print("Error fetching weekly ranks: $e"));
      }

      bannerRepository.randomBanner().then((data) {
        setState(() => randomAd = data);
      }).catchError((e) => print("Error fetching banner: $e"));

      repository.fetchVideosRandom(5).then((data) {
        setState(() => randomMovies = data);
      }).catchError((e) => print("Error fetching random movies: $e"));

      repository
          .fetchVideosWithFilter(0, 10, {}, "DateDESC", false)
          .then((data) {
        setState(() {
          latestMovies = data;
          isLoading = false; // 모든 요청이 끝나면 로딩 종료
        });
      }).catchError((e) {
        print("Error fetching latest movies: $e");
        setState(() => isLoading = false);
      });
    } catch (e) {
      print("Error fetching home data: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String URL = "http://13.239.238.92:8080/api/banner/image/";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 검색창
            ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search,
                        color: Theme.of(context).colorScheme.primary),
                    fillColor: Theme.of(context).cardColor, // 채우기 색
                    filled: true, // 채우기 유무 default = false
                    hintText: dailyRanking.isNotEmpty
                        ? dailyRanking[Random().nextInt(dailyRanking.length)]
                            .title
                        : "",
                    hintStyle:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                    border: InputBorder.none),
                onSubmitted: (value) => searchTitle(value),
              ),
            ),

            const SizedBox(height: 16),
            // 오늘 랭킹 3위까지
            // 된다면 주간 월간 랭킹 3초에 한번찍 돌아가며 나오기
            HomeRankingComponent(
              dailyRanking: dailyRanking,
              weeklyRanking: weeklyRanking,
              isLoading: isLoading,
            ),
            const SizedBox(height: 16),
            //광고

            randomAd != null
                ? Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), // 둥근 모서리
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.network(
                      URL + randomAd!.fileName,
                      fit: BoxFit.fill,
                    ),
                  )
                : Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), // 둥근 모서리
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.asset(
                      "assets/images/banner/banner1.png",
                      fit: BoxFit.fill,
                    ),
                  ),

            const SizedBox(height: 16),
            // 오늘의 랜덤 추천작
            HomeMovieListComponent(
              title: "당신을 위한 랜덤 추천작",
              type: "Random",
              videoList: randomMovies,
            ),
            const SizedBox(height: 16),
            // 최신 리뷰
            Text(
              "최신 리뷰",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Row(
                  children: List.generate(
                    homeReviewTmp.length,
                    (index) => HomeReviewComponent(
                      mName: homeReviewTmp[index].mName,
                      contents: homeReviewTmp[index].contents,
                      uName: homeReviewTmp[index].uName,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 최신 인기작
            HomeMovieListComponent(
              title: "개봉 최신작",
              type: "Least",
              videoList: latestMovies,
            ),
          ],
        ),
      ),
    );
  }
}
