import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nungil/data/repository/video_list_repository.dart';
import 'package:nungil/models/ranking/video_rank_model.dart';
import 'package:nungil/theme/common_theme.dart';
import '../../common_components/ranking_list_component.dart';

class HomeRankingComponent extends StatefulWidget {
  const HomeRankingComponent({super.key});

  @override
  State<HomeRankingComponent> createState() => _HomeRankingComponentState();
}

class _HomeRankingComponentState extends State<HomeRankingComponent> {
  List<VideoRankModel> dailyVideoList = [];
  List<VideoRankModel> weeklyVideoList = [];
  bool isDailyLoading = true;
  bool isWeeklyLoading = true;
  final PageController _pageController = PageController(viewportFraction: 1);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchDailyVideos();
    fetchWeeklyVideos();
    startAutoPageChange();
  }

  /// ✅ **개별 로딩: 일일 랭킹 데이터**
  Future<void> fetchDailyVideos() async {
    try {
      final repository = VideoListRepository();
      final dailyVideos = await repository.fetchRanksDaily();
      setState(() {
        dailyVideoList = dailyVideos;
        isDailyLoading = false;
      });
    } catch (e) {
      print("Error fetching daily videos: $e");
      setState(() {
        isDailyLoading = false;
      });
    }
  }

  /// ✅ **개별 로딩: 주간 랭킹 데이터**
  Future<void> fetchWeeklyVideos() async {
    try {
      final repository = VideoListRepository();
      final weeklyVideos = await repository.fetchRanksWeekly();
      setState(() {
        weeklyVideoList = weeklyVideos;
        isWeeklyLoading = false;
      });
    } catch (e) {
      print("Error fetching weekly videos: $e");
      setState(() {
        isWeeklyLoading = false;
      });
    }
  }

  /// 3초마다 자동으로 페이지 변경하는 함수
  void startAutoPageChange() {
    _timer = Timer.periodic(Duration(seconds: 6), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % 2; // 0 → 1 → 0 → 1 반복
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentPage = nextPage;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel(); // 타이머 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      child: PageView.builder(
        controller: _pageController,
        itemCount: 2, // 2개의 페이지 (Daily & Weekly)
        itemBuilder: (context, pageIndex) {
          return _buildRankingPage(pageIndex);
        },
      ),
    );
  }

  Widget _buildRankingPage(int pageIndex) {
    bool isLoading = (pageIndex == 0) ? isDailyLoading : isWeeklyLoading;
    List<VideoRankModel> videoList =
        (pageIndex == 0) ? dailyVideoList : weeklyVideoList;
    String title = (pageIndex == 0) ? "오늘의 랭킹" : "주간 랭킹";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme().titleLarge,
        ),
        SizedBox(height: 10),
        isLoading
            ? Center(child: CircularProgressIndicator())
            : Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 3, // 페이지당 3개씩 표시
                  itemBuilder: (context, index) {
                    if (index >= videoList.length) return SizedBox();
                    return RankingListComponent(
                      index: index,
                      video: videoList[index],
                    );
                  },
                ),
              ),
      ],
    );
  }
}
