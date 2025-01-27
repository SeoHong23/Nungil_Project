import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nungil/models/Video.dart';
import 'package:nungil/screens/video_detail/components/detail_app_bar.dart';
import 'package:nungil/screens/video_detail/components/detail_tap_bar.dart';
import 'package:nungil/theme/common_theme.dart';

class VideoDetailPage extends StatefulWidget {
  final Video item;

  const VideoDetailPage({required this.item, super.key});

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            CupertinoIcons.left_chevron,
            color: iconThemeColor.shade900,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.search,
              color: iconThemeColor.shade900,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert_outlined,
              color: iconThemeColor.shade900,
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            toolbarHeight: 50.0,
            pinned: true,
            expandedHeight: 300.0,
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [_buildDetailTop(widget.item)],
              ),
            ),
          ),
        ],
        body: DetailTap(controller: _tabController, item: widget.item),
      ),
    );
  }
}

_buildDetailTop(Video item) {
  return Container(
    child: Stack(
      children: [
        // 배경 이미지 - 스틸컷 리스트 중 택 1
        SizedBox(
          height: 350,
          width: double.infinity,
          child: Image.network(
            item.stlls[0],
            fit: BoxFit.cover,
          ),
        ),
        // 그라데이션
        Positioned(
          left: -10,
          right: -10,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 351,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      baseBackgroundColor,
                      baseBackgroundColor,
                      baseBackgroundColor.withOpacity(0.7),
                      baseBackgroundColor.withOpacity(0.3),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 351,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      baseBackgroundColor,
                      baseBackgroundColor.withOpacity(0.5),
                    ],
                    stops: [0.05,0.1],
                    begin: Alignment.centerLeft,
                    end: Alignment.center,
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            children: [
              // 포스터 썸네일
              Image.network(
                item.posters[0],
                width: 100,
              ),
              const SizedBox(
                height: 10,
              ),
              // 영화 제목
              Text(item.title, style: textTheme().titleLarge),
              // 영문 제목 - 제작 연도
              Text('${item.titleEng} · ${item.prodYear}',
                  style: textTheme().labelSmall),
              const SizedBox(
                height: 4.0,
              ),
              // 평점
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.star_fill,
                      size: 12, color: Colors.orangeAccent),
                  const SizedBox(width: 4.0),
                  Text("${item.score}", style: textTheme().labelMedium)
                ],
              ),
              // 버튼 영역
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: _buildReactionButton(
                      mIcon: FontAwesomeIcons.faceSmile,
                      color: Colors.green,
                      label: "좋아요",
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: _buildReactionButton(
                    mIcon: FontAwesomeIcons.faceAngry,
                    color: Colors.red,
                    label: "별로예요",
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              )
            ],
          ),
        )
      ],
    ),
  );
}

// 버튼
_buildReactionButton({
  required IconData mIcon,
  required String label,
  required Color color,
}) {
  return ElevatedButton.icon(
    onPressed: () {},
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(baseBackgroundColor.shade50),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
            side: BorderSide(width: 0.5, color: baseBackgroundColor.shade900)),
      ),
    ),
    icon: Icon(mIcon, color: color, size: 14),
    label: Text(label, style: textTheme().labelMedium),
  );
}
