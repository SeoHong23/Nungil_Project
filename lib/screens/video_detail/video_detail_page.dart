import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nungil/models/Video.dart';
import 'package:nungil/screens/video_detail/components/detail_tap_bar.dart';
import 'package:nungil/screens/video_detail/components/detail_top.dart';
import 'package:nungil/theme/common_theme.dart';

/// 생성일시 : 2025-01-21 김주경
///
/// updated
/// 250121 - 상단부
/// 250122 - 상단부 수정

class VideoDetailPage extends StatelessWidget {
  final Video item;

  const VideoDetailPage({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: ListView(
          children: [
            // 상단부
            DetailTop(item),
            DetailTapBar(item: item)
          ],
        ),
      ),
    );
  }
}
