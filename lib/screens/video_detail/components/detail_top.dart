import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nungil/models/Video.dart';
import 'package:nungil/providers/auth_provider.dart';
import 'package:nungil/theme/common_theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

// 상단부
class DetailTop extends ConsumerStatefulWidget {
  final Video item;

  const DetailTop({required this.item, super.key});

  @override
  _DetailTopState createState() => _DetailTopState();
}

class _DetailTopState extends ConsumerState<DetailTop> {
  bool isLiked = false;
  bool disLiked = false;
  Future<void> _toggleLike(WidgetRef ref) async {
    final String? videoId = widget.item.id; // Video 모델의 ID 사용
    final userId = ref.read(userIdProvider);

    if (userId == null) {
      print("Please log in first");
      return;
    }
    final String url = isLiked
        ? "http://13.239.238.92:8080/$videoId/unlike?userId=$userId" // unlike API 호출
        : "http://13.239.238.92:8080/$videoId/like?userId=$userId"; // like API 호출

    try {
      final response = isLiked
          ? await http.delete(Uri.parse(url)) // unlike일 때 DELETE 요청
          : await http.post(Uri.parse(url)); // like일 때 POST 요청

      if (response.statusCode == 200) {
        setState(() {
          isLiked = !isLiked; // 상태 토글
        });
        print(isLiked ? "Liked successfully" : "Unliked successfully");
      } else {
        print("Failed to toggle like: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _toggleDisLike(WidgetRef ref) async {
    final String? videoId = widget.item.id; // Video 모델의 ID 사용
    final userId = ref.read(userIdProvider);

    if (userId == null) {
      print("Please log in first");
      return;
    }
    final String url = disLiked
        ? "http://13.239.238.92:8080/$videoId/undislike?userId=$userId" // unlike API 호출
        : "http://13.239.238.92:8080/$videoId/dislike?userId=$userId"; // like API 호출

    try {
      final response = disLiked
          ? await http.delete(Uri.parse(url)) // unlike일 때 DELETE 요청
          : await http.post(Uri.parse(url)); // like일 때 POST 요청

      if (response.statusCode == 200) {
        setState(() {
          disLiked = !disLiked; // 상태 토글
        });
        print(disLiked ? "disLiked successfully" : "Undisliked successfully");
      } else {
        print("Failed to toggle like: ${response.body}");
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
            child: Container(
              height: 422,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black,
                    Colors.transparent,
                    baseBackgroundColor.withOpacity(0.3),
                    baseBackgroundColor.withOpacity(0.7),
                    baseBackgroundColor,
                  ],
                  stops: [0, 0.18, 0.32, 0.45, 0.8],
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
                      child: _buildReactionButton(
                        mIcon: isLiked
                            ? FontAwesomeIcons.solidFaceSmile
                            : FontAwesomeIcons.faceSmile,
                        color: Colors.green,
                        label: "좋아요",
                        // TODO : 좋아요 기능 구현
                        onPressed: () => _toggleLike(ref), // API 호출 추가
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: _buildReactionButton(
                        mIcon: disLiked
                            ? FontAwesomeIcons.solidFaceAngry
                            : FontAwesomeIcons.faceAngry,
                        color: Colors.red,
                        label: "별로예요",
                        // TODO : 별로예요 기능 구현
                        onPressed: () => _toggleDisLike(ref),
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
                        border: Border.all(
                            color: baseBackgroundColor.shade900, width: 0.5),
                        borderRadius: BorderRadius.circular(4.0),
                        color: baseBackgroundColor.shade800),
                    child: Center(
                      child: Text(
                        "광고",
                        style: CustomTextStyle.smallLightNavy,
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
