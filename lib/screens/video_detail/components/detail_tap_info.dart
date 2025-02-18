import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nungil/models/Video.dart';
import 'package:nungil/screens/video_detail/components/detail_cast_list_page.dart';
import 'package:nungil/screens/video_detail/components/detail_image_zoom_page.dart';
import 'package:nungil/screens/video_detail/components/skeleton.dart';
import 'package:nungil/theme/common_theme.dart';

class DetailTapInfo extends StatelessWidget {
  final Video item;
  final Function(int) changeTab;

  const DetailTapInfo({required this.item, required this.changeTab, super.key});

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('출연진 ${item.cast.length}',
                  style: ColorTextStyle.mediumNavy(context)),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailCastListPage(item: item),
                    ),
                  );
                },
                icon: const Icon(Icons.chevron_right_rounded),
                tooltip: "더보기",
              )
            ],
          ),
          const SizedBox(height: 16),
          _buildCast(context),
          const SizedBox(height: 16),
          _ExpandableCast(item: item),
          const SizedBox(height: 24),
          Text('이미지 ${item.mediaList.length}',
              style: ColorTextStyle.mediumNavy(context)),
          const SizedBox(height: 16),
          BuildExpandImages(
            item: item,
          ),
          const SizedBox(height: 16),
          _buildExpandButton(
              context: context,
              onPressed: () {
                changeTab(2);
              },
              children: [
                const Text("더보기"),
                const Icon(Icons.chevron_right_rounded),
              ]),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInfoTable(BuildContext context) {
    return InfoTable(
      data: {
        '장르': item.genre.join(", "),
        '개봉일': item.releaseDate,
        if (item.rating != "") '연령등급': item.rating,
        '러닝타임': '${item.runtime}분',
        '제작국가': item.nation,
        '제작연도': '${item.prodYear}년',
      },
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
                      '${item.cast[index].staffRole}',
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

// 줄거리 설명 확장
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
                : (widget.text.length < 150
                    ? widget.text
                    : '${widget.text.substring(0, maxLength)}... '),
          ),
          widget.text.length > 150
              ? TextSpan(
                  text: isExpanded ? '' : ' 더보기',
                  style: ColorTextStyle.mediumLightNavy(context),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                )
              : const TextSpan(),
        ],
      ),
    );
  }
}

// 제작진 확장
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
      firstChild: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoTable(data: widget.item.directors),
              const SizedBox(height: 4.0),
              Divider(color: Theme.of(context).primaryColor.withOpacity(0.3)),
            ],
          ),
          Positioned(
            child: _buildExpandButton(
                children: [const Icon(Icons.expand_more_rounded)],
                onPressed: onPressed,
                context: context),
          ),
        ],
      ),
      secondChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoTable(data: widget.item.directors),
          const SizedBox(height: 4.0),
          Divider(color: Theme.of(context).primaryColor.withOpacity(0.3)),
          const SizedBox(height: 4.0),
          InfoTable(data: widget.item.makers ?? {}),
          const SizedBox(
            height: 16,
          ),
          _buildExpandButton(children: [
            const Icon(Icons.expand_less_rounded),
          ], onPressed: onPressed, context: context),
        ],
      ),
      crossFadeState:
          isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
    );
  }
}

class InfoTable extends StatelessWidget {
  final Map<String, dynamic> data;

  const InfoTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      runAlignment: WrapAlignment.start,
      spacing: 8.0,
      runSpacing: 8.0,
      children: data.entries.map((entry) {
        return _buildRow(entry.key, entry.value, context);
      }).toList(),
    );
  }

  Widget _buildRow(String label, String value, BuildContext context) {
    return SizedBox(
      width: 300,
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: ColorTextStyle.smallLightNavy(context),
            ),
          ),
          SizedBox(
            width: 200,
            child: Text(value, style: ColorTextStyle.smallNavy(context)),
          ),
        ],
      ),
    );
  }
}

class BuildExpandImages extends StatefulWidget {
  final Video item;
  final bool isExpand;

  const BuildExpandImages(
      {required this.item, this.isExpand = false, super.key});

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
          runAlignment: WrapAlignment.start,
          spacing: 10,
          runSpacing: 10,
          children: [
            ...List.generate(
              widget.isExpand
                  ? widget.item.mediaList.length
                  : (widget.item.mediaList.length > 4
                      ? 4
                      : widget.item.mediaList.length),
              (index) => DetailImage(
                radius: 4.0,
                imgList: widget.item.mediaList,
                index: index,
                width: 180,
                height: 100,
              ),
            ),
          ],
        ),
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
        gradient: LinearGradient(colors: [
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
        ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
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

  Widget _buildTableRow(
    int key,
    int value,
  ) {
    return SizedBox(
      width: 300,
      child: Row(
        children: [
          SizedBox(
              width: 100,
              child: Row(children: [
                ShimmerBox(
                  width: 20.0 * key,
                  height: 15,
                )
              ])),
          SizedBox(
              width: 200,
              child: Row(children: [
                ShimmerBox(
                  width: 20.0 * value,
                  height: 15,
                )
              ]))
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
          children: List.generate(
            6,
            (index) => const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShimmerBox(radius: 30, width: 60, height: 60),
                SizedBox(height: 8),
                ShimmerBox(width: 70, height: 12),
                SizedBox(height: 4),
                ShimmerBox(width: 70, height: 12),
              ],
            ),
          ).toList()),
    );
  }

  Widget _buildGalley() {
    return Wrap(
      alignment: WrapAlignment.spaceAround,
      direction: Axis.horizontal,
      spacing: 10,
      runSpacing: 10,
      children: [
        ...List.generate(
            4,
            (index) => const ShimmerBox(
                  width: 180,
                  height: 100,
                )),
      ],
    );
  }
}
