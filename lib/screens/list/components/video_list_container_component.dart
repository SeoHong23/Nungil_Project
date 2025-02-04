import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nungil/data/gvm/video_list_GVM.dart';
import 'package:nungil/models/list/video_list_tmp.dart';

import 'video_list_component.dart';

class VideoListContainerComponent extends ConsumerStatefulWidget {
  const VideoListContainerComponent({super.key});

  @override
  ConsumerState<VideoListContainerComponent> createState() =>
      _VideoListContainerComponentState();
}

class _VideoListContainerComponentState
    extends ConsumerState<VideoListContainerComponent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // 최초 10개 로드
    Future.microtask(
        () => ref.read(videoNotifierProvider.notifier).fetchMoreVideos());
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // 끝에 도달하면 추가 데이터 요청
      ref.read(videoNotifierProvider.notifier).fetchMoreVideos();
    }
  }

  @override
  Widget build(BuildContext context) {
    final videoList = ref.watch(videoNotifierProvider);

    // 화면 크기에 따른 열 개수 조절
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;
    if (screenWidth > 600)
      crossAxisCount = 4;
    else if (screenWidth > 450) crossAxisCount = 3;

    return Expanded(
      child: GridView.builder(
        controller: _scrollController, // 스크롤 컨트롤러 추가
        itemCount: videoList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          mainAxisExtent: 310,
        ),
        itemBuilder: (context, index) {
          final video = videoList[index];
          return VideoListComponent(
            imgUrl: video.poster,
            name: video.title,
            rate: 80.0,
          );
        },
      ),
    );
  }
}
