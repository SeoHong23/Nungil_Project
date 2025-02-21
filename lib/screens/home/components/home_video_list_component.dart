import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nungil/screens/common_components/poster_image_component.dart';
import 'package:nungil/screens/common_components/rate_builder.dart';
import 'package:nungil/screens/video_detail/video_detail_page.dart';
import 'package:nungil/theme/common_theme.dart';

/// 2025-01-23 강중원 - 생성
/// 2025-01-24 강중원 - 임시 모델로 불러오도록 설정

class HomeVideoListComponent extends StatelessWidget {
  final String imgUrl;
  final String id;

  const HomeVideoListComponent({
    super.key,
    required this.id,
    required this.imgUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.hardEdge,
              child: imgUrl.isNotEmpty
                  ? PosterImageComponent(ImgURL: imgUrl)
                  : SvgPicture.asset(
                      'assets/images/app.svg',
                      fit: BoxFit.cover,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
