import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nungil/screens/video_detail/video_detail_page.dart';
import '../../../data/repository/video_list_repository.dart';
import '../../../models/ranking/video_rank_model.dart';
import '../../../theme/common_theme.dart';
import '../../common_components/rate_builder.dart';
import '../../common_components/ranking_list_component.dart';

class RankingBodyComponent extends StatefulWidget {
  const RankingBodyComponent({super.key});

  @override
  State<RankingBodyComponent> createState() => _RankingBodyComponentState();
}

class _RankingBodyComponentState extends State<RankingBodyComponent> {
  List<VideoRankModel> videoList = [];
  bool isLoading = true;
  String selectedCategory = "일일"; // ✅ 기본 선택값

  @override
  void initState() {
    super.initState();
    fetchVideos(); // ✅ 초기 데이터는 "일별" 데이터 가져오기
  }

  /// ✅ **선택된 카테고리에 따라 데이터 불러오기**
  Future<void> fetchVideos() async {
    setState(() {
      isLoading = true;
    });

    try {
      const repository = VideoListRepository();
      List<VideoRankModel> videos = selectedCategory == "일일"
          ? await repository.fetchRanksDaily()
          : await repository.fetchRanksWeekly();

      if (!mounted) return;

      setState(() {
        videoList = videos;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching videos: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _rankingCategoryButtons(), // ✅ 카테고리 버튼
              const SizedBox(height: 16),
              Text(selectedCategory == "일일" ? "오늘의 박스오피스 랭킹" : "금주의 박스오피스 랭킹",
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator()) // ✅ 로딩 UI 개선
                    : videoList.isEmpty
                        ? const Center(child: Text("데이터가 없습니다.")) // ✅ 빈 데이터 처리
                        : _buildRankingContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ **카테고리 버튼 UI (일일/주간 선택 가능)**
  Widget _rankingCategoryButtons() {
    List<String> categories = ["일일", "주간별"];

    return Row(
      children: categories.map((category) {
        bool isSelected = category == selectedCategory; // ✅ 현재 선택된 카테고리 확인
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedCategory = category; // ✅ 선택된 카테고리 업데이트
            });
            fetchVideos(); // ✅ 카테고리 변경 시 데이터 새로 불러오기
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).cardColor
                    : Theme.of(context).colorScheme.surface, // ✅ 선택 여부에 따른 색상 변경
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected
                      ? FontWeight.bold
                      : FontWeight.normal, // ✅ 선택된 경우 볼드 처리
                  color: isSelected
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.primary, // ✅ 선택된 경우 텍스트 색상 변경
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// ✅ **랭킹 데이터 리스트 렌더링**
  Widget _buildRankingContent() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          _buildTopRanking(), // ✅ 1위 영화 UI
          ...List.generate(
            videoList.length - 1,
            (index) => RankingListComponent(
              index: index + 1,
              video: videoList[index + 1],
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ **1위 영화 강조 UI**
  Widget _buildTopRanking() {
    final topVideo = videoList[0];

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoDetailPage(item: videoList[0].id),
          ),
        );
      },
      child: Stack(
        children: [
          topVideo.poster.isNotEmpty
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  clipBehavior: Clip.hardEdge, // 둥근 모서리를 Clip 효과로 적용
                  child: Image.network(
                    topVideo.poster,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 290,
                  ),
                )
              : SvgPicture.asset(
                  'assets/images/app.svg', // 기본 이미지
                  fit: BoxFit.cover,
                  height: 290,
                ),
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.2),
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.1),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('1', style: CustomTextStyle.bigLogo),
                Text(topVideo.title, style: topVideo.title.length<8?CustomTextStyle.bigLogo:CustomTextStyle.mediumLogo),
              ],
            ),
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: topVideo.rankOldAndNew == "OLD" ? Container() : Text("NEW"),
          ),
        ],
      ),
    );
  }
}
