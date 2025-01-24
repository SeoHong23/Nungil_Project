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
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [baseBackgroundColor, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: _buildTabBar(widget.item),
        ),
      ],
    );
  }

  TabBar _buildTabBar(Video item) {
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
      labelColor: iconThemeColor.shade900,
      overlayColor: WidgetStatePropertyAll(iconThemeColor.shade200),
      unselectedLabelColor: iconThemeColor.shade300,
    );
  } // end of _buildTabBar

  TabBarView _buildTabBarView(Video item) {
    return TabBarView(
      controller: _tabController,
      children: [

      ],
    );
  }
}
