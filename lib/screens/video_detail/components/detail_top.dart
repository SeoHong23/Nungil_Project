import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nungil/models/Video.dart';
import 'package:nungil/theme/common_theme.dart';

// 상단부
class DetailTop extends StatelessWidget {
  final Video item;
  const DetailTop({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          // 배경 이미지 - 스틸컷 리스트 중 택 1
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 350,
              width: double.infinity,
              child: Image.network(
                item.stlls[0],
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 그라데이션
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 350, // 그라데이션 영역 크기 지정
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black,
                    Colors.transparent,
                    baseBackgroundColor.withOpacity(0.3),
                    baseBackgroundColor.withOpacity(0.7),
                    baseBackgroundColor,
                  ],
                  stops: [0, 0.2, 0.5, 0.6, 0.75],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
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
                  width: 100, // 포스터 크기 고정
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
}

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
