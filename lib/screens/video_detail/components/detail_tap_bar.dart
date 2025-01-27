import 'package:flutter/material.dart';
import 'package:nungil/models/Video.dart';
import 'package:nungil/theme/common_theme.dart';

class DetailTap extends StatelessWidget {
  const DetailTap({required this.controller, required this.item, super.key});

  final TabController controller;
  final Video item;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          DetailTapBar(controller: controller, item: item),
          Expanded(child: _TabBarView(controller: controller, item: item),),
        ],
      ),
    );
  }
}

class DetailTapBar extends StatelessWidget {
  const DetailTapBar({required this.controller, required this.item, super.key});

  final TabController controller;
  final Video item;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      tabs: [
        Tab(child: Text("작품정보")),
        Tab(child: Text("리뷰 ${item.reviewCnt}")),
        Tab(child: Text("영상/이미지 ${item.stlls.length}"))
      ],
      indicatorColor: iconThemeColor.shade700,
      labelColor: iconThemeColor.shade900,
      overlayColor: WidgetStatePropertyAll(iconThemeColor.shade200),
      unselectedLabelColor: iconThemeColor.shade300,
    );
  }
}

class _TabBarView extends StatelessWidget {
  const _TabBarView({required this.controller, required this.item, super.key});

  final TabController controller;
  final Video item;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller,
      children: [
        ListView(
          children: [
            Container(
              height: 2000,
              width: double.infinity,
              color: Colors.red,
            ),
          ],
        ),
        ListView(
          children: [
            Container(
              height: 2000,
              width: double.infinity,
              color: Colors.yellow,
            ),
          ],
        ),
        ListView(
          children: [
            Container(
              height: 2000,
              width: double.infinity,
              color: Colors.grey,
            ),
          ],
        )
      ],
    );
  }
}
