import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nungil/models/Video.dart';
import 'package:nungil/screens/video_detail/components/detail_tap_bar.dart';
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(
                  minWidth: 100,
                  maxWidth: 900,
                ),
                child: Expanded(
                  child: ListView(
                    children: [
                      // 상단부
                      _buildDetailTop(item, context),
                      DetailTapBar(item: item)
                    ],
                  ),
                ),
              ),
            ]
        ),
      ),
    );
  }

  _buildDetailTop(Video item, BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width > 900
        ? 900
        : MediaQuery.of(context).size.width;

    return Expanded(
      child: Stack(
        children: [
          // 배경 이미지 - 스틸컷 리스트 중 택 1
          Expanded(
            child: Image.network(
              item.stlls[0],
              fit: BoxFit.cover,
              width: double.infinity,
              height: 300,
            ),
          ),
          // 그라데이션
          Container(
            width: double.infinity,
            height: 320,
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
          Positioned(
            top: 115,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // 포스터 썸네일
                Image.network(
                  item.posters[0],
                  width: 70,
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
                    Icon(
                      CupertinoIcons.star_fill,
                      size: 12,
                      color: Colors.orangeAccent,
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "${item.score}",
                      style: textTheme().labelMedium,
                    )
                  ],
                ),
                // 버튼 영역
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildReactionButton(
                        mIcon: FontAwesomeIcons.faceSmile,
                        color: Colors.green,
                        label: "좋아요",
                        height: screenHeight / 20.0,
                        width: screenWidth / 2.0),
                    _buildReactionButton(
                        mIcon: FontAwesomeIcons.faceAngry,
                        color: Colors.red,
                        label: "별로예요",
                        height: screenHeight / 20.0,
                        width: screenWidth / 2.0),
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
    required double height,
    required double width,
  }) {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size(width, 50)),
        backgroundColor: WidgetStatePropertyAll(Colors.white),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
              side:
                  BorderSide(width: 0.5, color: baseBackgroundColor.shade900)),
        ),
      ),
      icon: Icon(mIcon, color: color, size: 14),
      label: Text(label, style: textTheme().labelSmall),
    );
  }
}
