import 'package:flutter/material.dart';
import 'package:nungil/models/Video.dart';
import 'package:nungil/theme/common_theme.dart';

class DetailTapBar extends StatefulWidget {
  const DetailTapBar({required this.item, super.key});

  final Video item;

  @override
  State<DetailTapBar> createState() => _DetailTapBarState();
}

class _DetailTapBarState extends State<DetailTapBar>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    print('프로필 탭 내부 클래스 init 호출');

    // length는 탭의 개수를 의미한다.
    // vsync는 자연스러운 애니메이션 전환을 위해서 TivkerProvider를 이용한다.
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTabBar(widget.item),
      ],
    );
  }

  Widget _buildTabBar(Video item) {
    return TabBar(
      controller: _tabController,
      tabs: [
        Tab(
          child: Text("작품정보"),
        ),
        Tab(
          child: Text("리뷰 ${item.review}"),
        ),
        Tab(
          child: Text("영상/이미지 ${item.stlls.length}"),
        )
      ],
      indicatorColor: iconThemeColor.shade700,
      labelColor: iconThemeColor.shade800,
      overlayColor: WidgetStatePropertyAll(iconThemeColor.shade50),
      unselectedLabelColor: iconThemeColor.shade200,
    );
  } // end of _buildTabBar

  Widget _buildTabBarView(Video item) {
    return TabBarView(
      controller: _tabController,
      children: [
        Container(
          width: double.infinity,
          height: 400,
          child: Text("작품정보"),
        ),
        Container(
          width: double.infinity,
          height: 400,
          child: Text("리뷰"),
        ),
        Container(
          width: double.infinity,
          height: 400,
          child: Text("영상/이미지"),
        ),
      ],
    );
  }
}
