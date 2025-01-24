import 'package:flutter/material.dart';
import 'package:nungil/models/list/video_list_tmp.dart';

import 'video_list_component.dart';

class VideoListContainerComponent extends StatefulWidget {
  const VideoListContainerComponent({super.key});

  @override
  State<VideoListContainerComponent> createState() =>
      _VideoListContainerComponentState();
}

class _VideoListContainerComponentState
    extends State<VideoListContainerComponent> {
  @override
  Widget build(BuildContext context) {
    // 화면의 가로 크기 가져오기
    final screenWidth = MediaQuery.of(context).size.width;

    // 가로 크기에 따른 열 개수 계산
    int crossAxisCount = 1; // 기본 2열
    if (screenWidth > 600) {
      crossAxisCount = 4; // 가로 600px 이상일 경우 4열
    } else if (screenWidth > 450) {
      crossAxisCount = 3; // 가로 450px 이상일 경우 3열
    } else if (screenWidth > 275) {
      crossAxisCount = 2; // 가로 450px 이상일 경우 3열
    }

    return Expanded(
      child: GridView.builder(
        itemCount: 20,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          mainAxisExtent: 310,
        ),
        itemBuilder: (context, index) {
          int _index = (index % videoListTmp.length);
          return VideoListComponent(
            imgUrl: videoListTmp[_index].imgUrl,
            name: videoListTmp[_index].name,
            rate: videoListTmp[_index].rate,
          );
        },
      ),
    );
  }
}
