import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nungil/screens/video_detail/video_detail_page.dart';
import 'package:nungil/theme/common_theme.dart';

import '../../../models/Video.dart';
import '../../common_components/poster_image_component.dart';
import '../../common_components/rate_builder.dart';

/// 2025-01-23 강중원 - 생성
/// 2025-01-24 강중원 - 임시 모델로 불러오도록 설정

class VideoListComponent extends StatelessWidget {
  final String imgUrl;
  final String name;
  final double rate;
  final String id;

  const VideoListComponent(
      {super.key,
      required this.id,
      required this.imgUrl,
      required this.name,
      required this.rate});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 0,
            blurRadius: 5.0,
            offset: Offset(0, 1),
          ),
        ],
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoDetailPage(item: id),
            ),
          );
        },
        child: Column(
          children: [
            Container(
              width: double.infinity, // 부모 위젯의 너비를 명시적으로 설정
              height: 250, // 고정된 높이
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), // 둥근 모서리
              ),
              clipBehavior: Clip.hardEdge, // 둥근 모서리를 Clip 효과로 적용
              child: imgUrl.isNotEmpty
                  ? PosterImageComponent(ImgURL: imgUrl)
                  : SvgPicture.asset(
                      'assets/images/app.svg', // 기본 이미지
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(height: 5),
            Text(
              name,
              maxLines: 1, // 한 줄까지만 표시
              overflow: TextOverflow.ellipsis, // 넘칠 경우 '...' 표시
              style: TextStyle(
                fontSize: 14, // 원하는 폰트 크기 지정
                fontWeight: FontWeight.w500, // 폰트 가중치 설정
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RateBuilder(
                      rate: rate,
                    ),
                    InkWell(
                      onTap: () {
                        // 버튼 클릭 시 실행될 동작
                      },
                      child: Icon(
                        Icons.add_circle_outline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
