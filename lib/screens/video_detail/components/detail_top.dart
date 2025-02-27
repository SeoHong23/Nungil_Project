import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nungil/data/objectbox_helper.dart';
import 'package:nungil/models/detail/Movie.dart';
import 'package:nungil/models/detail/Video.dart';
import 'package:nungil/objectbox.g.dart';
import 'package:nungil/screens/video_detail/components/detail_image_zoom_page.dart';
import 'package:nungil/screens/video_detail/components/skeleton.dart';
import 'package:nungil/theme/common_theme.dart';

// 상단부
class DetailTop extends ConsumerStatefulWidget {
  final Video item;

  const DetailTop({required this.item, super.key});

  @override
  _DetailTopState createState() => _DetailTopState();
}

class _DetailTopState extends ConsumerState<DetailTop> {
  final movieBox = ObjectBox().getBox<Movie>();

  bool isPosterLoaded = false;
  bool isStillLoaded = false;
  int stllsIndex = 0;

  Movie? movie = null;

  @override
  void initState() {
    super.initState();
    stllsIndex = Random().nextInt(widget.item.stlls.length);
    _getVideoReaction();
  }

  void _getVideoReaction() async {
    movie = movieBox
            .query(Movie_.videoId.equals(widget.item.id))
            .build()
            .findFirst() ??
        Movie.copyWith(widget.item);
    setState(() {});
  }

  void refresh() {
    movieBox.put(movie!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (movie == null) {
      return SkeletonDetailTop();
    }
    return Stack(
      children: [
        // 배경 이미지 - 스틸컷 리스트 중 택 1
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 400,
            width: double.infinity,
            child: widget.item.stlls.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: widget.item.stlls[stllsIndex],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: CupertinoColors.darkBackgroundGray,
                    ),
                  )
                : Container(
                    color: CupertinoColors.darkBackgroundGray,
                  ),
          ),
        ),
        // 그라데이션
        Positioned(
          bottom: -1,
          left: -1,
          right: -1,
          child: SizedBox(
            height: 430,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black,
                    Colors.transparent,
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.3),
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                  stops: const [0.001, 0.2, 0.35, 0.5, 0.8],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(width: 10),
                    // 포스터 썸네일
                    DetailImage(
                        imgList: widget.item.posters,
                        index: 0,
                        width: 90,
                        height: 120),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 영화 제목
                          Text(widget.item.title,
                              style: Theme.of(context).textTheme.titleLarge),
                          // 영문 제목 - 제작 연도
                          Text(
                              '${widget.item.titleEng} · ${widget.item.prodYear}',
                              style: Theme.of(context).textTheme.labelSmall),
                          const SizedBox(height: 4.0),
                          // 평점
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(CupertinoIcons.star_fill,
                                  size: 14, color: Colors.orangeAccent),
                              const SizedBox(width: 4.0),
                              Text("${widget.item.score}",
                                  style: Theme.of(context).textTheme.labelSmall)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              // 버튼 영역
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        return _buildReactionButton(
                            context: context,
                            mIcon: movie!.isLiked
                                ? FontAwesomeIcons.solidFaceSmile
                                : FontAwesomeIcons.faceSmile,
                            color: Colors.green,
                            label: "좋아요",
                            onPressed: () {
                              movie!.toggleLiked();
                              refresh();
                            } // API 호출 및 상태 변경
                            );
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        return _buildReactionButton(
                            context: context,
                            mIcon: movie!.isDisliked
                                ? FontAwesomeIcons
                                    .solidFaceFrown // "dislike" 상태일 때 아이콘
                                : FontAwesomeIcons.faceFrown,
                            // 기본 상태일 때 아이콘
                            color: Colors.red,
                            label: "별로예요",
                            onPressed: () {
                              movie!.toggleDisliked();
                              refresh();
                            });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMoreActionButton(
                    mIcon: movie!.isBookmarked
                        ? CupertinoIcons.bookmark_fill // 찜 상태일 때 아이콘
                        : CupertinoIcons.bookmark, // 찜 안 된 상태일 때 아이콘
                    context: context,
                    label: "찜하기",
                    onPressed: () {
                      movie!.toggleBookmarked();
                      refresh();
                    },
                  ),
                  _buildMoreActionButton(
                    mIcon: movie!.isWatching
                        ? Icons.remove_red_eye
                        : Icons.remove_red_eye_outlined,
                    context: context,
                    label: "보고 있어요",
                    onPressed: () {
                      movie!.toggleWatching();
                      refresh();
                    },
                  ),
                  _buildMoreActionButton(
                    mIcon: movie!.isWatched
                        ? CupertinoIcons.checkmark_circle_fill
                        : CupertinoIcons.checkmark_alt,
                    context: context,
                    label: "봤어요",
                    onPressed: () {
                      movie!.toggleWatched();
                      refresh();
                    },
                  ),
                  _buildMoreActionButton(
                    mIcon: movie!.isIgnored ? Icons.check_circle : Icons.close,
                    context: context,
                    label: "관심 없어요",
                    onPressed: () {
                      movie!.toggleIgnored();
                      refresh();
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "광고",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

_buildReactionButton(
    {required IconData mIcon,
    required String label,
    required Color color,
    required Function() onPressed,
    required BuildContext context}) {
  return ElevatedButton.icon(
    onPressed: onPressed,
    style: ButtonStyle(
      backgroundColor:
          WidgetStatePropertyAll(Theme.of(context).colorScheme.surface),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
            side: BorderSide(
                width: 0.5, color: Theme.of(context).colorScheme.background)),
      ),
    ),
    icon: Icon(mIcon, color: color, size: 14),
    label: Text(label, style: Theme.of(context).textTheme.labelMedium),
  );
}

_buildMoreActionButton(
    {required IconData mIcon,
    required String label,
    required Function() onPressed,
    required BuildContext context}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: const ButtonStyle(
      backgroundColor: WidgetStateColor.transparent,
      elevation: WidgetStatePropertyAll(0),
      padding: WidgetStatePropertyAll(EdgeInsets.all(8)),
      fixedSize: WidgetStatePropertyAll(Size(80, 60)),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(mIcon, color: Theme.of(context).colorScheme.secondary, size: 17),
        Text(label, style: ColorTextStyle.xSmallNavy(context)),
      ],
    ),
  );
}

class SkeletonDetailTop extends StatelessWidget {
  const SkeletonDetailTop({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 배경 이미지 - 스틸컷 리스트 중 택 1
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Container(
            height: 400,
            width: double.infinity,
            color: CupertinoColors.darkBackgroundGray,
          ),
        ),
        // 그라데이션
        Positioned(
          bottom: -1,
          left: -1,
          right: -1,
          child: SizedBox(
            height: 430,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    DefaultColors.black,
                    Colors.transparent,
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.3),
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                  stops: const [0, 0.18, 0.35, 0.5, 0.8],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    // 포스터 썸네일
                    ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: const ShimmerBox(height: 120, width: 95)),
                    const SizedBox(
                      width: 10,
                    ),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerBox(height: 30, width: 120),
                          SizedBox(height: 4.0),
                          ShimmerTextPlaceholder(
                            lineCount: 1,
                            maxWidth: 300,
                            lineHeight: 12,
                          ),
                          SizedBox(height: 3.0),
                          ShimmerTextPlaceholder(
                            lineCount: 1,
                            maxWidth: 100,
                            lineHeight: 14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 4,
              ),

              // 버튼 영역
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(child: ShimmerBox(height: 40, width: 14)),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(child: ShimmerBox(height: 40, width: 14)),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ShimmerBox(height: 60, width: 80),
                  ShimmerBox(height: 60, width: 80),
                  ShimmerBox(height: 60, width: 80),
                  ShimmerBox(height: 60, width: 80),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "광고",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
