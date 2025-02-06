import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PosterImageComponent extends StatelessWidget {
  const PosterImageComponent({required this.ImgURL, super.key});
  final String ImgURL;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: ImgURL,
      fit: BoxFit.cover,
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(), // 로딩 상태
      ),
      errorWidget: (context, url, error) {
        print('Image load failed for URL: $url'); // 에러 로그 출력
        return SvgPicture.asset(
          'assets/images/app.svg', // 기본 이미지
          fit: BoxFit.cover,
        );
      },
    );
  }
}
