import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nungil/models/Video.dart';
import 'package:nungil/screens/video_detail/components/detail_cast_list_page.dart';
import 'package:nungil/screens/video_detail/components/skeleton.dart';
import 'package:nungil/theme/common_theme.dart';

class DetailTapInfo extends StatelessWidget {
  final Video item;

  const DetailTapInfo({required this.item, super.key});

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
          Row(
            children: [
              Text('출연진 ${item.cast.length}',
                  style: ColorTextStyle.mediumNavy(context)),
              IconButton(onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailCastListPage(item: item),
                  ),
                );
              }, icon: Icon(Icons.chevron_right_rounded))
            ],
          ),
          const SizedBox(height: 16),
          _buildCast(context),
          const SizedBox(
            height: 16,
          ),
          _buildTable(item.directors, context),
          const SizedBox(height: 16),
          _ExpandableCast(item: item),
          const SizedBox(height: 24),
          Text('이미지', style: ColorTextStyle.mediumNavy(context)),
          const SizedBox(height: 16),
          BuildExpandImages(
            item: item,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInfoTable(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        _buildTableRow('장르', item.genre.join(", "), context),
        _buildTableRow('개봉일', item.releaseDate, context),
        Visibility(
            visible: item.rating != "",
            child: _buildTableRow('연령등급', item.rating??'',  context)),
        _buildTableRow('러닝타임', '${item.runtime}분', context),
        _buildTableRow('제작국가', item.nation,  context),
        _buildTableRow('제작연도', '${item.prodYear}년', context),
      ],
    );
  }

  Widget _buildTableRow(String label1, String value1, BuildContext context) {
    return SizedBox(
      width: 300,
      child: Row(
        children: [
          SizedBox(
              width: 100,
              child: Text(label1, style: ColorTextStyle.smallLightNavy(context))),
          SizedBox(
              width: 200,
              child: Text(value1, style: ColorTextStyle.smallNavy(context))),
        ],
      ),
    );
  }

  Widget _buildCast(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.spaceBetween,
          spacing: 20,
          runSpacing: 10,
          children: List.generate(
            item.cast.length > 8 ? 8 : item.cast.length,
            (index) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person, size: 30),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 70,
                  child: Text(
                    item.cast[index].staffNm,
                    style: ColorTextStyle.xSmallNavy(context),
                    textAlign: TextAlign.center,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
                Visibility(
                  visible: item.cast[index].staffRole != "",
                  child: SizedBox(
                    width: 70,
                    child: Text(
                      '(${item.cast[index].staffRole} 역)',
                      style: ColorTextStyle.xSmallLightNavy(context),
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
            ),
          ).toList()),
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
                : (widget.text.length<150?widget.text:'${widget.text.substring(0, maxLength)}... '),
          ),
          widget.text.length>150?
          TextSpan(
            text: isExpanded ? ' 접기' : ' 더보기',
            style: ColorTextStyle.mediumLightNavy(context),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
          ):TextSpan(),
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
      duration: const Duration(milliseconds: 200),
      firstChild: _buildExpandButton(children: [
        const Icon(Icons.expand_more_rounded),
        const Text("더보기"),
      ], onPressed: onPressed, context: context),
      secondChild: Column(
        children: [
          Opacity(
            opacity: 0.7,
            child: RichText(
              text: TextSpan(
                children: [
                  ...List.generate(
                    widget.item.cast.length > 8
                        ? widget.item.cast.length - 8
                        : 0,
                    (index) => TextSpan(
                      children: [
                        TextSpan(
                          text: widget.item.cast[index + 8].staffNm
                              .replaceAll("\n", " "),
                          style: ColorTextStyle.xSmallNavy(context),
                        ),
                        TextSpan(
                          text: widget.item.cast[index + 8].staffRole != ""
                              ? '(${widget.item.cast[index + 8].staffRole?.replaceAll("\n", " ")})  '
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
          const SizedBox(
            height: 16,
          ),
          _buildTable(widget.item.makers ?? {}, context),
          const SizedBox(
            height: 16,
          ),
          _buildExpandButton(children: [
            const Icon(Icons.expand_less_rounded),
            const Text("닫기"),
          ], onPressed: onPressed, context: context),
        ],
      ),
      crossFadeState:
          isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
    );
  }
}

Widget _buildTable(Map<String, dynamic> map, BuildContext context) {
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

class BuildExpandImages extends StatefulWidget {
  final Video item;
  final List<Widget> children;

  const BuildExpandImages(
      {required this.item, this.children = const [], super.key});

  @override
  State<BuildExpandImages> createState() => BuildExpandImagesState();
}

class BuildExpandImagesState extends State<BuildExpandImages> {
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
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    )),
            ...List.generate(
                widget.item.posters.length > 4 ? 4 : widget.item.posters.length,
                (index) => ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: Image.network(
                        widget.item.posters[index],
                        width: 180,
                        height: 100,
                        fit: BoxFit.cover,
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
    {required List<Widget> children,
    required VoidCallback onPressed,
    required BuildContext context}) {
  return Container(
    width: double.infinity,
    height: 40,
    decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).colorScheme.primary, width: 0.5),
        borderRadius: BorderRadius.circular(4.0)),
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

class ShimmerInfo extends StatelessWidget {
  const ShimmerInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerTextPlaceholder(
            lineHeight: 14,
            spacing: 8,
            lineCount: 4,
            maxWidth: double.infinity,
          ),
          const SizedBox(height: 24),
          Divider(color: Theme.of(context).primaryColor.withOpacity(0.3)),
          const SizedBox(height: 16),
          _buildInfoTable(),
          const SizedBox(height: 32),
          const ShimmerBox(height: 18, width: 60),
          const SizedBox(height: 16),
          _buildCast(),
          const SizedBox(height: 24),
          const ShimmerBox(height: 18, width: 60),
          const SizedBox(height: 16),
          _buildGalley(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInfoTable() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 16.0,
      children: [
        _buildTableRow(2, 10),
        _buildTableRow(3, 10),
        _buildTableRow(4, 9),
        _buildTableRow(4, 4),
        _buildTableRow(4, 4),
        _buildTableRow(4, 5),
      ],
    );
  }
  Widget _buildTableRow(int key, int value, ) {
    return SizedBox(
      width: 300,
      child: Row(
        children: [
          SizedBox(
              width: 100,
              child: Row(
                  children: [ShimmerBox(width: 20.0*key, height: 15,)])
      ),
          SizedBox(
              width: 200,
              child: Row(
                  children: [ShimmerBox(width: 20.0*value, height: 15,)])
          )
        ],
      ),
    );
  }
  Widget _buildCast() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.spaceBetween,
          spacing: 20,
          runSpacing: 10,
          children: List.generate(6,
                (index) => const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShimmerBox(
                  radius: 30,
                  width: 60,
                  height: 60,
                ),
                SizedBox(height: 8),
                ShimmerBox(
                  width: 70,
                  height: 12,
                ),
                SizedBox(height: 4),
                ShimmerBox(
                  width: 70,
                  height: 12,
                ),
              ],
            ),
          ).toList()),
    );
  }

  Widget _buildGalley(){
    return Wrap(
      alignment: WrapAlignment.spaceAround,
      direction: Axis.horizontal,
      spacing: 10,
      runSpacing: 10,
      children: [
        ...List.generate(4,
                (index) => const ShimmerBox(
                  width: 180,
                  height: 100,
                )),
      ],
    );
  }

}
