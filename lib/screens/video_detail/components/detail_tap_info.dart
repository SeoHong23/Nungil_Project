import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nungil/models/Video.dart';
import 'package:nungil/theme/common_theme.dart';

class DetailTapInfo extends StatelessWidget {
  final Video item;

  const DetailTapInfo({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: ExpandableText(text: item.plots),
          ),
          const SizedBox(height: 24),
          Divider(color: iconThemeColor.shade700.withOpacity(0.3)),
          const SizedBox(height: 16),
          _buildInfoTable(context),
          const SizedBox(height: 20),
          Text('출연진', style: ColorTextStyle.mediumNavy(context)),
          const SizedBox(height: 10),
          _buildStaffGrid(context),
        ],
      ),
    );
  }

  Widget _buildInfoTable(BuildContext context) {
    return Table(
      columnWidths: {
        0: FractionColumnWidth(.2),
        1: FractionColumnWidth(.3),
        2: FractionColumnWidth(.2),
        3: FractionColumnWidth(.3),
      },
      children: [
        _buildTableRow('장르', item.genre.join(", "), '개봉일', item.releaseDate, context),
        _buildTableRow(
            '연령등급', item.rating ?? '심의 없음', '러닝타임', '${item.runtime}분', context),
        _buildTableRow('제작국가', item.nation, '제작연도', '${item.prodYear}년', context),
      ],
    );
  }

  TableRow _buildTableRow(
      String label1, String value1, String label2, String value2, BuildContext context) {
    return TableRow(
      children: [
        Text(label1, style: ColorTextStyle.smallLightNavy(context)),
        Text(value1, style: ColorTextStyle.smallNavy(context)),
        Text(label2, style: ColorTextStyle.smallLightNavy(context)),
        Text(value2, style: ColorTextStyle.smallNavy(context)),
      ],
    );
  }

  Widget _buildStaffGrid(BuildContext context) {
    return Center(
      child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          spacing: 20,
          runSpacing: 10,
          children: [
            ...List.generate(
                item.cast.length > 8 ? 8 : item.cast.length,
                (index) => Column(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          child: Icon(Icons.person, size: 30),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 50,
                          child: Text(
                            item.cast[index].staffNm,
                            style: ColorTextStyle.smallNavy(context),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Visibility(
                          visible: item.cast[index].staffRole!="",
                          child: SizedBox(
                            width: 80,
                            child: Text(
                              '(${item.cast[index].staffRole} 역)',
                              style: ColorTextStyle.xSmallLightNavy(context),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ))
          ]),
    );
  }
}

class ExpandableText extends StatefulWidget {
  final String text;

  const ExpandableText({required this.text, super.key});

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    const int maxLength = 150;
    return RichText(
      text: TextSpan(
        style: ColorTextStyle.mediumNavy(context),
        children: [
          TextSpan(
            text: isExpanded
                ? widget.text
                : '${widget.text.substring(0, maxLength)}... ',
          ),
          TextSpan(
            text: isExpanded ? ' 접기' : ' 더보기',
            style: ColorTextStyle.mediumLightNavy(context),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
          ),
        ],
      ),
    );
  }
}
