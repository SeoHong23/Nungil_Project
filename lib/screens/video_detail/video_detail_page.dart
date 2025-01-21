import 'package:flutter/material.dart';
import 'package:nungil/models/Video.dart';
import 'package:nungil/theme/common_theme.dart';


/// 생성일시 : 2025-01-21 김주경
///
/// updated
/// 250121 - 헤더

class VideoDetailPage extends StatelessWidget {
  final Video item;

  const VideoDetailPage({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Expanded(
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
                // 그라데이션 (수정예정)
                Container(
                  width: double.infinity,
                  height: 320,
                  decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.white,Colors.white,Colors.white60,Colors.white30,Colors.transparent],begin: Alignment.bottomCenter,end: Alignment.topCenter)),
                ),
                Positioned(
                  top: 120,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Image.network(item.posters[0], width: 70,),
                      const SizedBox(height: 10,),
                      Text(item.title, style: textTheme().displayMedium,),
                      Text('${item.titleEng} · ${item.prodYear}', style: textTheme().labelSmall,)
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
