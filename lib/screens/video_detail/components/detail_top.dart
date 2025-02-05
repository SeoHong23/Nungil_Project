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
            bottom: 20,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 400,
              width: double.infinity,
              child: Image.network(
                item.stlls[0],
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 그라데이션
          Positioned(
            bottom: -1,
            left: -1,
            right: -1,
            top: -1,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black,
                    Colors.transparent,
                    baseBackgroundColor.withOpacity(0.3),
                    baseBackgroundColor.withOpacity(0.7),
                    baseBackgroundColor,
                  ],
                  stops: [0, 0.18, 0.35, 0.5, 0.8],
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    // 포스터 썸네일
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Image.network(
                        item.posters[0],
                        height: 120, // 포스터 크기 고정
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 영화 제목
                        Text(item.title, style: textTheme().titleLarge),
                        // 영문 제목 - 제작 연도
                        Text(' ${item.titleEng} · ${item.prodYear}',
                            style: textTheme().labelSmall),
                        const SizedBox(height: 4.0),
                        // 평점
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.star_fill,
                                size: 12, color: Colors.orangeAccent),
                            const SizedBox(width: 4.0),
                            Text("${item.score}", style: textTheme().labelSmall)
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
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
                          // TODO : 좋아요 기능 구현
                          onPressed: () {}),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: _buildReactionButton(
                            mIcon: FontAwesomeIcons.faceAngry,
                            color: Colors.red,
                            label: "별로예요",
                            // TODO : 별로예요 기능 구현
                            onPressed: () {})),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMoreActionButton(
                      mIcon: CupertinoIcons.bookmark_fill,
                      label: "찜하기",
                      // TODO : 찜하기 기능 구현
                      onPressed: () {},
                    ),
                    _buildMoreActionButton(
                      mIcon: Icons.remove_red_eye,
                      label: "보고 있어요",
                      // TODO : 보고 있어요 기능 구현
                      onPressed: () {},
                    ),
                    _buildMoreActionButton(
                      mIcon: CupertinoIcons.checkmark_alt,
                      label: "봤어요",
                      // TODO : 봤어요 기능 구현
                      onPressed: () {},
                    ),
                    _buildMoreActionButton(
                      mIcon: Icons.close,
                      label: "관심 없어요",
                      // TODO : 관심 없어요 기능 구현
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text("광고",style: textTheme().labelSmall,),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

_buildReactionButton(
    {required IconData mIcon,
    required String label,
    required Color color,
    required Function() onPressed}) {
  return ElevatedButton.icon(
    onPressed: onPressed,
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

_buildMoreActionButton({
  required IconData mIcon,
  required String label,
  required Function() onPressed,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: const ButtonStyle(
      backgroundColor: WidgetStateColor.transparent,
      elevation: WidgetStatePropertyAll(0),
      padding: WidgetStatePropertyAll(EdgeInsets.all(10)),
      fixedSize: WidgetStatePropertyAll(Size(80, 60)),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(mIcon, color: DefaultColors.navy, size: 17),
        Text(label, style: CustomTextStyle.xSmallNavy),
      ],
    ),
  );
}
