import 'package:flutter/material.dart';
import 'package:nungil/models/list/video_list_tmp.dart';
import 'package:nungil/screens/common_components/rate_builder.dart';

class RankingListComponent extends StatelessWidget {
  const RankingListComponent({required this.index, super.key});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 60,
        child: Row(
          children: [
            Container(
              width: 20,
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ), // 등수
            const SizedBox(width: 8),
            Image.asset(
              videoListTmp[index % videoListTmp.length].imgUrl,

              fit: BoxFit.cover,
              width: 40, // 이미지 크기 지정
              height: 50,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                videoListTmp[index % videoListTmp.length].name,
              ),
            ),
            RateBuilder(rate: videoListTmp[index % videoListTmp.length].rate),
          ],
        ),
      ),
    );
  }
}
