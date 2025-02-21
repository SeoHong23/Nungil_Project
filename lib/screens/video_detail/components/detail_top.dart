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
    setState(() {
    final url = "http://13.239.238.92:8080/$videoId/like-status?userId=$userId";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final isDisLiked = json
            .decode(response.body)['isDisliked']; // 서버 응답으로 'true' or 'false'
        ref.read(isDisLikedProvider.state).state = isDisLiked;
        print("Fetched disLike status: $isDisLiked");
      } else {
        print("Failed to fetch dislike status: ${response.body}");
      }
    } catch (e) {
      print("Error fetching like status: $e");
    }
  }

  Future<void> _toggleLike(WidgetRef ref) async {
    final isLiked = ref.read(isLikedProvider);
    final isDisLiked = ref.read(isDisLikedProvider);
    final String? videoId = widget.item.id; // Video 모델의 ID 사용
    final userId = ref.read(userIdProvider);

    if (userId == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("로그인 상태가 아닙니다"),
            actions: <Widget>[
              TextButton(
                child: Text("확인"),
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
              ),
            ],
          );
        },
      );
      return;
    }

    if (isDisLiked) {
      // AlertDialog로 경고 메시지 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("별로예요 상태에서는 좋아요를 누를 수 없습니다."),
            actions: <Widget>[
              TextButton(
                child: Text("확인"),
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
              ),
            ],
          );
        },
      );
      return; // "좋아요"를 클릭하지 않도록 처리
    }

    // 상태를 먼저 업데이트
    ref.watch(isLikedProvider.state).state = !isLiked;

    final String url = isLiked
        ? "http://13.239.238.92:8080/$videoId/unlike?userId=$userId" // unlike API 호출
        : "http://13.239.238.92:8080/$videoId/like?userId=$userId"; // like API 호출

    try {
      final response = isLiked
          ? await http.delete(Uri.parse(url)) // unlike일 때 DELETE 요청
          : await http.post(Uri.parse(url)); // like일 때 POST 요청

      if (response.statusCode == 200) {
        print(isLiked ? "Unliked successfully" : "Liked successfully");
      } else {
        // 서버에서 실패한 경우 상태를 다시 원래대로 복구
        ref.read(isLikedProvider.state).state = isLiked;
        print("Failed to toggle like: ${response.body}");
      }
    } catch (e) {
      // 오류가 발생한 경우 상태를 다시 원래대로 복구
      ref.read(isLikedProvider.state).state = isLiked;
      print("Error: $e");
    }
  }

  Future<void> _toggleDisLike(WidgetRef ref) async {
    final isLiked = ref.read(isLikedProvider);
    final isDisLiked = ref.read(isDisLikedProvider);
    final String? videoId = widget.item.id; // Video 모델의 ID 사용
    final userId = ref.read(userIdProvider);

    if (userId == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("로그인 상태가 아닙니다"),
            actions: <Widget>[
              TextButton(
                child: Text("확인"),
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
              ),
            ],
          );
        },
      );
      return;
    }

    if (isLiked) {
      // AlertDialog로 경고 메시지 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("좋아요 상태에서는 별로예요를 누를 수 없습니다."),
            actions: <Widget>[
              TextButton(
                child: Text("확인"),
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
              ),
            ],
          );
        },
      );
      return; // "별로예요"를 클릭하지 않도록 처리
    }
    ref.watch(isDisLikedProvider.state).state = !isDisLiked;
    final String url = isDisLiked
        ? "http://13.239.238.92:8080/$videoId/undislike?userId=$userId" // 취소(dislike 취소) API 호출
        : "http://13.239.238.92:8080/$videoId/dislike?userId=$userId"; // dislike API 호출

    try {
      final response = isDisLiked
          ? await http.delete(Uri.parse(url)) // dislike 취소할 때 DELETE 요청
          : await http.post(Uri.parse(url)); // dislike할 때 POST 요청

      if (response.statusCode == 200) {
        // 성공적으로 상태 변경
        ref.read(isDisLikedProvider.state).state = !isDisLiked; // 상태 토글
        print(isDisLiked ? "Undisliked successfully" : "Disliked successfully");
      } else {
        print("Failed to toggle dislike: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _toggleFavorite(WidgetRef ref) async {
    print("로그인된 유저 아이디: ${ref.read(userIdProvider)}");
    final String? videoId = widget.item.id; // 현재 비디오 ID
    final userId = ref.read(userIdProvider); // 로그인한 사용자 ID 가져오기
    if (userId == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(side: BorderSide.none),
            content: const Text("로그인 상태가 아닙니다"),
            actions: <Widget>[
              TextButton(
                child: const Text("확인"),
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
              ),
            ],
          );
        },
      );
      return;
    }

    final isFavorited = ref.read(isFavoritedProvider.state).state;
    final url = isFavorited
        ? "http://13.239.238.92:8080/favorite/remove" // 찜 삭제 API URL
        : "http://13.239.238.92:8080/favorite"; // 찜 추가 API URL

    final body = json.encode({
      'userId': userId.toString(),
      'videoId': videoId,
    });

    print("Request URL: $url");
    print("Request Headers: {'Content-Type': 'application/json'}");
    print("Request Body: $body");

    try {
      // 찜 상태에 따라 POST 또는 DELETE 요청
      final response = isFavorited
          ? await http.delete(
              Uri.parse(url),
              headers: {'Content-Type': 'application/json'},
              body: body,
            )
          : await http.post(
              Uri.parse(url),
              headers: {'Content-Type': 'application/json'},
              body: body,
            );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // 응답 처리: 서버에서 반환된 값을 확인
        final Map<String, dynamic> responseData = json.decode(response.body);

        // 서버에서 반환하는 값에 따라 찜 상태 업데이트
        final bool newFavoriteStatus = responseData['isFavorited'] ?? false;

        // 찜 상태를 토글 (서버와 동기화 후 상태 갱신)
        ref.read(isFavoritedProvider.state).state = newFavoriteStatus;

        print(newFavoriteStatus
            ? "Favorite added successfully!"
            : "Favorite removed successfully!");

        ref.invalidate(favoriteCountProvider);

        _loadFavoriteStatus();
      } else {
        print("Failed to toggle favorite: ${response.body}");
      }
    } catch (e) {
      print("Error toggling favorite: $e");
    }
  }

  Future<void> _loadFavoriteStatus() async {
    final String? videoId = widget.item.id;
    final userId = ref.read(userIdProvider);

    if (userId == null) {
      print("Please log in first");
      return;
    }

    final url =
        "http://13.239.238.92:8080/favorite/$videoId/like-status?userId=$userId";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(response.body); // 응답을 Map으로 파싱
        final bool isFavorited =
            responseData['isFavorited'] ?? false; // 'isFavorited' 값을 bool로 추출

        // 상태 갱신
        ref.read(isFavoritedProvider.state).state = isFavorited; // 상태 갱신

        print("Fetched Favorite status: $isFavorited");

        // UI 리프레시를 위해 setState 호출
        setState(() {}); // UI 갱신
      } else {
        print("Failed to fetch favorite status: ${response.body}");
      }
    } catch (e) {
      print("Error fetching favorite status: $e");
    }

    });

  }

  void refresh(){
    movieBox.put(movie!);
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    if(movie==null){
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
                          }
                        );
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
