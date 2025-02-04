import 'package:flutter/material.dart';
import 'package:nungil/models/list/video_list_tmp.dart';

import '../../../theme/common_theme.dart';
import '../../common_components/rate_builder.dart';
import '../../common_components/ranking_list_component.dart';

class RankingBodyComponent extends StatefulWidget {
  const RankingBodyComponent({super.key});

  @override
  State<RankingBodyComponent> createState() => _RankingBodyComponentState();
}

class _RankingBodyComponentState extends State<RankingBodyComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 700),
          child: Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0), // 아이템 간 간격
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: baseBackgroundColor[400],
                            borderRadius: BorderRadius.circular(5), // 모서리 둥글게
                          ),
                          child: Text(
                            '일일',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0), // 아이템 간 간격
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: baseBackgroundColor[400],
                            borderRadius: BorderRadius.circular(5), // 모서리 둥글게
                          ),
                          child: Text(
                            '주간별',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0), // 아이템 간 간격
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: baseBackgroundColor[400],
                            borderRadius: BorderRadius.circular(5), // 모서리 둥글게
                          ),
                          child: Text(
                            '월별',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(// 광고?

                      ),
                  Text("오늘의 박스오피스 랭킹"),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          // 배경 이미지와 그라데이션
                          Stack(
                            children: [
                              Image.asset(
                                'assets/images/tmp/gloryBack.webp',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 300,
                              ),
                              Container(
                                width: double.infinity,
                                height: 300, // 이미지와 동일한 높이로 설정
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      baseBackgroundColor,
                                      baseBackgroundColor,
                                      baseBackgroundColor.withOpacity(0.2),
                                      baseBackgroundColor.withOpacity(0.1),
                                      Colors.transparent,
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                              ),
                              Positioned(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '1',
                                      style: CustomTextStyle.bigLogo,
                                    ),
                                    Text(
                                      videoListTmp[0].name,
                                      style: CustomTextStyle.bigLogo,
                                    ),
                                  ],
                                ),
                                top: 150,
                                left: 20,
                              ),
                              Positioned(
                                right: 20,
                                bottom: 20,
                                child: RateBuilder(rate: videoListTmp[0].rate),
                              ),
                            ],
                          ),

                          // 리스트 영역
                          Column(
                            children: List.generate(
                                10,
                                (index) => index == 0
                                    ? Container()
                                    : RankingListComponent(index: index)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
