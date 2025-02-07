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
            color: baseBackgroundColor,
            child: ExpandableText(text: item.plots),
          ),
          const SizedBox(height: 24),
          Divider(color: iconThemeColor.shade700.withOpacity(0.3)),
          const SizedBox(height: 16),
          _buildInfoTable(),
          const SizedBox(height: 20),
          Text('출연진', style: CustomTextStyle.mediumNavy),
          const SizedBox(height: 10),
          _buildStaffGrid(),
        ],
      ),
    );
  }

  Widget _buildInfoTable() {
    return Table(
      columnWidths: {
        0: FractionColumnWidth(.2),
        1: FractionColumnWidth(.3),
        2: FractionColumnWidth(.2),
        3: FractionColumnWidth(.3),
      },
      children: [
        _buildTableRow('장르', item.genre.join(", "), '개봉일', item.releaseDate),
        _buildTableRow('연령등급', item.rating ?? '심의 없음', '러닝타임', '${item.runtime}분'),
        _buildTableRow('제작국가', item.nation, '제작연도', '${item.prodYear}년'),
      ],
    );
  }

  TableRow _buildTableRow(String label1, String value1, String label2, String value2) {
    return TableRow(
      children: [
        Text(label1, style: CustomTextStyle.mediumLightNavy),
        Text(value1, style: CustomTextStyle.mediumNavy),
        Text(label2, style: CustomTextStyle.mediumLightNavy),
        Text(value2, style: CustomTextStyle.mediumNavy),
      ],
    );
  }

  Widget _buildStaffGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // 내부에서 스크롤을 방지
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3 / 4,
      ),
      itemCount: item.cast.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            const CircleAvatar(
              radius: 30,
              child: Icon(Icons.person, size: 30),
            ),
            const SizedBox(height: 8),
            Text(
              item.cast[index].staffNm,
              style: CustomTextStyle.smallNavy,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
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
        style: CustomTextStyle.mediumNavy,
        children: [
          TextSpan(
            text: isExpanded
                ? widget.text
                : '${widget.text.substring(0, maxLength)}... ',
          ),
          TextSpan(
            text: isExpanded ? ' 접기' : ' 더보기',
            style: CustomTextStyle.mediumLightNavy,
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
