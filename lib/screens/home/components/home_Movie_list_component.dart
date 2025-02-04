import 'package:flutter/material.dart';

import '../../../data/repository/video_list_repository.dart';
import '../../../models/list/video_list_model.dart';
import '../../../models/list/video_list_tmp.dart';
import '../../../theme/common_theme.dart';
import '../../list/components/video_list_component.dart';

class HomeMovieListComponent extends StatefulWidget {
  final String title;
  const HomeMovieListComponent({required this.title, super.key});

  @override
  State<HomeMovieListComponent> createState() => _HomeMovieListComponentState();
}

class _HomeMovieListComponentState extends State<HomeMovieListComponent> {
  List<VideoListModel> videoList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    try {
      final repository = VideoListRepository();
      final videos = await repository.fetchVideos(0, 10); // page 0, size 10
      setState(() {
        videoList = videos;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching videos: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: textTheme().titleLarge,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Row(
              children: List.generate(
                videoList.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Container(
                    width: 170,
                    height: 300,
                    child: VideoListComponent(
                      imgUrl: videoList[index].poster ?? '', // null 체크
                      name: videoList[index].title ?? '제목 없음',
                      rate: 80.0, // 예제에서는 80.0 고정, 필요하면 API 값 사용
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
