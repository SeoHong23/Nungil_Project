import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nungil/models/home/home_review_tmp.dart';
import 'package:nungil/models/list/video_list_tmp.dart';
import 'package:nungil/screens/list/components/video_list_component.dart';
import 'package:nungil/theme/common_theme.dart';

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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 검색창
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(FontAwesomeIcons.magnifyingGlass),
                fillColor: Theme.of(context).cardColor, // 채우기 색
                filled: true, // 채우기 유무 default = false
                labelStyle: TextStyle(),
              ),
            ),

            SizedBox(height: 16),
            // 오늘 랭킹 3위까지
            // 된다면 주간 월간 랭킹 3초에 한번찍 돌아가며 나오기
            HomeRankingComponent(),
            SizedBox(height: 16),
            //광고
            Container(
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text("광고"),
              ),
            ),

            SizedBox(height: 16),
            // 오늘의 랜덤 추천작
            HomeMovieListComponent(
              title: "오늘의 랜덤 추천작",
            ),
            SizedBox(height: 16),
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
            SizedBox(height: 16),
            // 최신 인기작
            HomeMovieListComponent(title: "최신 인기작"),
          ],
        ),
      ),
    );
  }
}
