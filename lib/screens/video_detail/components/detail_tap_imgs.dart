import 'package:flutter/material.dart';
import 'package:nungil/models/Video.dart';
import 'package:nungil/screens/video_detail/components/detail_tap_info.dart';
import 'package:nungil/theme/common_theme.dart';

class DetailTapImgs extends StatelessWidget {
  final Video item;
  const DetailTapImgs({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text('영상 0',
            style: ColorTextStyle.mediumNavy(context)),
        const SizedBox(height: 16),

        const SizedBox(height: 16),
        Divider(color: Theme.of(context).primaryColor.withOpacity(0.3)),
        const SizedBox(height: 16),
        Text('이미지 ${item.mediaList.length}',
            style: ColorTextStyle.mediumNavy(context)),
        const SizedBox(height: 16),
        BuildExpandImages(item: item, isExpand: true,),
        const SizedBox(height: 24),
      ],
    );
  }
}
