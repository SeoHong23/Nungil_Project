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
          Divider(color: Theme.of(context).primaryColor.withOpacity(0.3)),
          const SizedBox(height: 16),
          _buildInfoTable(context),
          const SizedBox(height: 24),
          Text('출연진', style: ColorTextStyle.mediumNavy(context)),
          const SizedBox(height: 16),
          _buildCast(context),
          const SizedBox(height: 16),
          _ExpandableCast(item: item),
          const SizedBox(height: 24),
          Text('이미지', style: ColorTextStyle.mediumNavy(context)),
          const SizedBox(height: 16),
          buildExpandImages(item: item,),
          const SizedBox(height: 24),
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
        _buildTableRow(
            '장르', item.genre.join(", "), '개봉일', item.releaseDate, context),
        _buildTableRow('연령등급', item.rating ?? '심의 없음', '러닝타임',
            '${item.runtime}분', context),
        _buildTableRow(
            '제작국가', item.nation, '제작연도', '${item.prodYear}년', context),
      ],
    );
  }

  Widget _buildCast(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          spacing: 20,
          runSpacing: 10,
          children: List.generate(
            item.cast.length > 8 ? 8 : item.cast.length,
            (index) => Column(
              children: [
                const CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person, size: 30),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 80,
                  child: Text(
                    item.cast[index].staffNm,
                    style: ColorTextStyle.smallNavy(context),
                    textAlign: TextAlign.center,
                  ),
                ),
                Visibility(
                  visible: item.cast[index].staffRole != "",
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
            ),
          ).toList()),
    );
  }

  TableRow _buildTableRow(String label1, String value1, String label2,
      String value2, BuildContext context) {
    return TableRow(
      children: [
        Text(label1, style: ColorTextStyle.smallLightNavy(context)),
        Text(value1, style: ColorTextStyle.smallNavy(context)),
        Text(label2, style: ColorTextStyle.smallLightNavy(context)),
        Text(value2, style: ColorTextStyle.smallNavy(context)),
      ],
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

class _ExpandableCast extends StatefulWidget {
  final Video item;

  const _ExpandableCast({required this.item, super.key});

  @override
  State<_ExpandableCast> createState() => _ExpandableCastState();
}

class _ExpandableCastState extends State<_ExpandableCast> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    onPressed() {
      setState(() {
        isExpanded = !isExpanded;
      });
    }

    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 300),
      firstChild: _buildExpandButton(
        children: [
          const Icon(Icons.expand_more_rounded),
          const Text("더보기"),
        ],
        onPressed: onPressed,
        context: context
      ),
      secondChild: Column(
        children: [
          Opacity(
            opacity: 0.7,
            child: RichText(
              text: TextSpan(
                children: [
                  ...List.generate(
                    widget.item.cast.length>8?widget.item.cast.length - 8:0,
                    (index) => TextSpan(
                      children: [
                        TextSpan(
                          text: widget.item.cast[index + 8].staffNm,
                          style: ColorTextStyle.xSmallNavy(context),
                        ),
                        TextSpan(
                          text: widget.item.cast[index + 8].staffRole != ""
                              ? '(${widget.item.cast[index + 8].staffRole}) '
                              : '',
                          style: ColorTextStyle.xSmallLightNavy(context),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16,),
          _buildTable(widget.item.directors),
          const SizedBox(height: 8,),
          Divider(color: Theme.of(context).primaryColor.withOpacity(0.3)),
          const SizedBox(height: 8,),
          _buildTable(widget.item.makers??{}),
          const SizedBox(height: 16,),
          _buildExpandButton(
            children: [
              const Icon(Icons.expand_less_rounded),
              const Text("닫기"),
            ],
            onPressed: onPressed,
            context: context
          ),
        ],
      ),
      crossFadeState:
          isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
    );
  }

  _buildTable(Map<String, dynamic> map) {
    return Table(
        columnWidths: const {
          0: FractionColumnWidth(.2),
          1: FractionColumnWidth(.8),
        },
        children: map.entries.map((entry) {
          return TableRow(
            children: [
              Text(entry.key, style: ColorTextStyle.smallLightNavy(context)),
              Text(entry.value.toString(),
                  style: ColorTextStyle.smallNavy(context)),
            ],
          );
        }).toList());
  }
}

class buildExpandImages extends StatefulWidget {
  final Video item;
  final List<Widget> children;
  const buildExpandImages({required this.item,this.children=const[],super.key});

  @override
  State<buildExpandImages> createState() => buildExpandImagesState();
}

class buildExpandImagesState extends State<buildExpandImages> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.spaceAround,
          direction: Axis.horizontal,
          spacing: 10,
          runSpacing: 10,
          children: [
            ...List.generate(
                widget.item.stlls.length > 4 ? 4 : widget.item.stlls.length,
                    (index) => ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: Image.network(
                    widget.item.stlls[index],
                    width: 180,
                  ),
                ))
          ],
        ),
        ...widget.children
      ],
    );
  }
}


Widget _buildExpandButton(
    {required List<Widget> children, required VoidCallback onPressed, required BuildContext context}) {
  return Container(
    width: double.infinity,
    height: 40,
    decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary,width: 0.5),
        borderRadius: BorderRadius.circular(4.0)

    ),
    child: Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: const ButtonStyle(
              backgroundColor: WidgetStateColor.transparent,
              elevation: WidgetStatePropertyAll(0),
              padding: WidgetStatePropertyAll(EdgeInsets.all(5)),
              fixedSize: WidgetStatePropertyAll(Size(80, 60)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          ),
        ),
      ],
    ),
  );
}
