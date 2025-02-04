import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PosterImageComponent extends StatelessWidget {
  const PosterImageComponent({required this.ImgURL, super.key});
  final String ImgURL;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      ImgURL,
      fit: BoxFit.cover, // 비율에 맞게 채움
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return SvgPicture.asset(
          'assets/images/app.svg', // 기본 이미지
          fit: BoxFit.cover,
        );
      },
    );
  }
}
