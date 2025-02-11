import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nungil/models/list/video_list_tmp.dart';
import 'package:nungil/models/ranking/video_rank_model.dart';
import 'package:nungil/screens/common_components/rate_builder.dart';
import 'package:nungil/screens/ranking/components/rankIten_component.dart';

import '../../theme/common_theme.dart';
import '../video_detail/video_detail_page.dart';
import 'poster_image_component.dart';

class RankingListComponent extends StatelessWidget {
  const RankingListComponent(
      {required this.index, required this.video, super.key});
  final int index;
  final VideoRankModel video;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoDetailPage(item: video.id),
            ),
          );
        },
        child: Container(
          height: 60,
          child: Row(
            children: [
              Container(
                width: 51,
                child: Column(
                  children: [
                    Expanded(child: Container()),
                    Text(
                      '${index + 1}',
                      style: CustomTextStyle.ranking,
                    ),
                    RankitenComponent(rankInten: video.rankInten)
                  ],
                ),
              ), // 등수
              const SizedBox(width: 8),
              Container(
                width: 40,
                child: video.poster.isNotEmpty
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        clipBehavior: Clip.hardEdge, // 둥근 모서리를 Clip 효과로 적용
                        child: PosterImageComponent(ImgURL: video.poster),
                      )
                    : SvgPicture.asset(
                        'assets/images/app.svg', // 기본 이미지
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  video.title,
                ),
              ),
              const SizedBox(width: 8),
              video.rankOldAndNew == "OLD"
                  ? Container()
                  : Text(
                      "NEW!",
                      style: TextStyle(color: DefaultColors.green),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
