import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nungil/models/Video.dart';
import 'package:nungil/theme/common_theme.dart';

class DetailTapInfo extends StatefulWidget {
  final Video item;

  const DetailTapInfo({required this.item, super.key});

  @override
  State<DetailTapInfo> createState() => _DetailTapInfoState();
}

class _DetailTapInfoState extends State<DetailTapInfo> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          color: baseBackgroundColor,
          child: RichText(
            text: isExpanded
                ? TextSpan(
                    children: [
                      TextSpan(
                        text: widget.item.plots[0].plotText,
                        style: CustomTextStyle.mediumNavy,
                      ),
                      TextSpan(
                          text: '  접기',
                          style: CustomTextStyle.mediumLightNavy,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            })
                    ],
                  )
                : TextSpan(
                    children: [
                      TextSpan(
                        text:
                            '${widget.item.plots[0].plotText.substring(0, 150)}... ',
                        style: CustomTextStyle.mediumNavy,
                      ),
                      TextSpan(
                          text: '더보기',
                          style: CustomTextStyle.mediumLightNavy,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            })
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          height: 1,
          decoration:
              BoxDecoration(color: iconThemeColor.shade700.withOpacity(0.3)),
        ),
        const SizedBox(height: 16),
        Table(
          columnWidths: {
            0: FractionColumnWidth(.2),
            1: FractionColumnWidth(.3),
            2: FractionColumnWidth(.2),
            3: FractionColumnWidth(.3),
          },
          children: [
            TableRow(
              children: [
                Text(
                  '장르',
                  style: CustomTextStyle.smallLightNavy,
                ),
                Text(
                  widget.item.genre.join(", "),
                  style:CustomTextStyle.smallNavy,
                ),
                Text(
                  '개봉일',
                  style: CustomTextStyle.smallLightNavy,
                ),
                Text(
                  '${widget.item.releaseDate}',
                  style:CustomTextStyle.smallNavy,
                ),
              ],
            ),
            TableRow(
              children: [
                Text(
                  '연령등급',
                  style: CustomTextStyle.smallLightNavy,
                ),
                Text(
                  widget.item.rating ?? '심의 없음',
                  style:
                  CustomTextStyle.smallNavy,
                ),
                Text(
                  '러닝타임',
                  style: CustomTextStyle.smallLightNavy,
                ),
                Text(
                  '${widget.item.runtime}분',
                  style:
                  CustomTextStyle.smallNavy,
                ),
              ],
            ),
            TableRow(
              children: [
                Text(
                  '제작국가',
                  style: CustomTextStyle.smallLightNavy,
                ),
                Text(
                  widget.item.nation,
                  style:CustomTextStyle.smallNavy,
                ),
                Text(
                  '제작연도',
                  style: CustomTextStyle.smallLightNavy,
                ),
                Text(
                  '${widget.item.prodYear}년',
                  style:CustomTextStyle.smallNavy,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text('출연진')
      ],
    );
  }
}
