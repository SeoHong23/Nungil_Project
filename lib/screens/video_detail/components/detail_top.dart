import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nungil/models/Video.dart';
import 'package:nungil/providers/auth_provider.dart';
import 'package:nungil/theme/common_theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// 상단부
class DetailTop extends ConsumerStatefulWidget {
  final Video item;

  const DetailTop({required this.item, super.key});

  @override
  _DetailTopState createState() => _DetailTopState();
}

class _DetailTopState extends ConsumerState<DetailTop> {
  final isLikedProvider = StateProvider<bool>((ref) => false);
  final isDisLikedProvider = StateProvider<bool>((ref) => false);

  Future<void> _getLikeStatus(WidgetRef ref) async {
    final String? videoId = widget.item.id;
    final userId = ref.read(userIdProvider);

    if (userId == null) {
      print("Please log in first");
      return;
    }

    // 서버에서 좋아요 상태를 가져옴
    final url = "http://13.239.238.92:8080/$videoId/like-status?userId=$userId";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final isLiked =
            json.decode(response.body)['isLiked']; // 'isLiked' 상태 받아오기
        ref.read(isLikedProvider.state).state = isLiked;
        print("Fetched Like status: $isLiked");
      } else {
        print("Failed to fetch like status: ${response.body}");
      }
    } catch (e) {
      print("Error fetching like status: $e");
    }
  }

  Future<void> _getDisLikeStatus(WidgetRef ref) async {
    final String? videoId = widget.item.id; // Video 모델의 ID 사용
    final userId = ref.read(userIdProvider);

    if (userId == null) return;

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
      print("Please log in first");
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
      print("Please log in first");
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          // 배경 이미지 - 스틸컷 리스트 중 택 1
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 400,
              width: double.infinity,
              child: Image.network(
                widget.item.stlls[0],
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 그라데이션
          Positioned(
            bottom: -1,
            left: -1,
            right: -1,
            top: -1,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black,
                    Colors.transparent,
                    baseBackgroundColor.withOpacity(0.3),
                    baseBackgroundColor.withOpacity(0.7),
                    baseBackgroundColor,
                  ],
                  stops: [0, 0.18, 0.35, 0.5, 0.8],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    // 포스터 썸네일
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Image.network(
                        widget.item.posters[0],
                        height: 120, // 포스터 크기 고정
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 영화 제목
                        Text(widget.item.title, style: textTheme().titleLarge),
                        // 영문 제목 - 제작 연도
                        Text(
                            ' ${widget.item.titleEng} · ${widget.item.prodYear}',
                            style: textTheme().labelSmall),
                        const SizedBox(height: 4.0),
                        // 평점
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.star_fill,
                                size: 14, color: Colors.orangeAccent),
                            const SizedBox(width: 4.0),
                            Text("${widget.item.score}",
                                style: textTheme().labelSmall)
                          ],
                        ),
                      ],
                    ),
                  ],
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
                          // 비디오 ID와 사용자 ID를 받아오기
                          final videoId = widget.item.id; // Video 모델의 ID
                          final userId = ref.read(userIdProvider);

                          // 사용자 ID가 없다면 좋아요 상태를 가져올 수 없으므로 초기화
                          if (userId != null) {
                            _getLikeStatus(ref); // 좋아요 상태 초기화
                          }

                          // Riverpod 상태 값 가져오기
                          final isLiked =
                              ref.watch(isLikedProvider.state).state;

                          return _buildReactionButton(
                            mIcon: isLiked
                                ? FontAwesomeIcons.solidFaceSmile
                                : FontAwesomeIcons.faceSmile,
                            color: Colors.green,
                            label: "좋아요",
                            onPressed: () => _toggleLike(ref), // API 호출 및 상태 변경
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
                          final videoId = widget.item.id; // Video 모델의 ID
                          final userId = ref.read(userIdProvider);

                          // 사용자 ID가 없다면 좋아요 상태를 가져올 수 없으므로 초기화
                          if (userId != null) {
                            _getDisLikeStatus(ref); // 좋아요 상태 초기화
                          }
                          final disLiked =
                              ref.watch(isDisLikedProvider.state).state;

                          return _buildReactionButton(
                            mIcon: disLiked
                                ? FontAwesomeIcons
                                    .solidFaceFrown // "dislike" 상태일 때 아이콘
                                : FontAwesomeIcons.faceFrown, // 기본 상태일 때 아이콘
                            color: Colors.red,
                            label: "별로예요",
                            onPressed: () =>
                                _toggleDisLike(ref), // dislike API 호출 및 상태 변경
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
                      mIcon: CupertinoIcons.bookmark_fill,
                      label: "찜하기",
                      // TODO : 찜하기 기능 구현
                      onPressed: () {},
                    ),
                    _buildMoreActionButton(
                      mIcon: Icons.remove_red_eye,
                      label: "보고 있어요",
                      // TODO : 보고 있어요 기능 구현
                      onPressed: () {},
                    ),
                    _buildMoreActionButton(
                      mIcon: CupertinoIcons.checkmark_alt,
                      label: "봤어요",
                      // TODO : 봤어요 기능 구현
                      onPressed: () {},
                    ),
                    _buildMoreActionButton(
                      mIcon: Icons.close,
                      label: "관심 없어요",
                      // TODO : 관심 없어요 기능 구현
                      onPressed: () {},
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
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "광고",
                        style: textTheme().labelSmall,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

_buildReactionButton(
    {required IconData mIcon,
    required String label,
    required Color color,
    required Function() onPressed}) {
  return ElevatedButton.icon(
    onPressed: onPressed,
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(baseBackgroundColor.shade50),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
            side: BorderSide(width: 0.5, color: baseBackgroundColor.shade900)),
      ),
    ),
    icon: Icon(mIcon, color: color, size: 14),
    label: Text(label, style: textTheme().labelMedium),
  );
}

_buildMoreActionButton({
  required IconData mIcon,
  required String label,
  required Function() onPressed,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: const ButtonStyle(
      backgroundColor: WidgetStateColor.transparent,
      elevation: WidgetStatePropertyAll(0),
      padding: WidgetStatePropertyAll(EdgeInsets.all(10)),
      fixedSize: WidgetStatePropertyAll(Size(80, 60)),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(mIcon, color: DefaultColors.navy, size: 17),
        Text(label, style: CustomTextStyle.xSmallNavy),
      ],
    ),
  );
}
