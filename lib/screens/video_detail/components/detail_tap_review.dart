import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:nungil/models/Video.dart';
import 'package:nungil/screens/common_components/rating_widget.dart';
import 'package:nungil/theme/common_theme.dart';

class DetailTapReview extends StatefulWidget {
  final Video item;

  const DetailTapReview({required this.item, super.key});

  @override
  State<DetailTapReview> createState() => _DetailTapReviewState();
}

class _DetailTapReviewState extends State<DetailTapReview> {
  double? _selectedRating;
  final TextEditingController _reviewController = TextEditingController();
  final ScrollController _scrollController =
      ScrollController(); // 🔹 스크롤 컨트롤러 추가
  final String currentUser = "홍합";
  final List<Map<String, dynamic>> _reviews = [];

  @override
  void initState() {
    super.initState();

    // 🔹 키보드가 올라올 때 자동 스크롤
    _reviewController.addListener(() {
      if (_reviewController.text.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 🔹 기본 화면 조정 비활성화
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Expanded를 사용하여 화면 높이를 유지하고 ListView 사용 가능하게 함
            Expanded(
              child: ListView(
                children: [
                  // ⭐ 별점 입력 영역
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: Column(
                      children: [
                        Text(
                          '이 작품 어떠셨나요?',
                          style: ColorTextStyle.mediumLightNavy(context),
                        ),
                        const SizedBox(height: 8),
                        RatingExample(
                          onRatingSelected: (rating) {
                            setState(() {
                              _selectedRating = rating;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  if (_selectedRating != null) ...[
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _reviewController,
                          maxLines: 4,
                          style: ColorTextStyle.mediumNavy(context),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface,
                            hintText: '작품에 대한 솔직한 리뷰를 남겨주세요',
                            hintStyle: ColorTextStyle.mediumLightNavy(context),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.background),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.background),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Theme.of(context).colorScheme.primary),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            if (_reviewController.text.isNotEmpty) {
                              setState(() {
                                int existingIndex = _reviews.indexWhere(
                                    (r) => r['username'] == currentUser);

                                if (existingIndex != -1) {
                                  _reviews[existingIndex] = {
                                    'username': currentUser,
                                    'rating': _selectedRating,
                                    'review': _reviewController.text,
                                    'date': DateFormat('yyyy-MM-dd HH:mm')
                                        .format(DateTime.now()),
                                    'good':
                                        _reviews[existingIndex]['good'] ?? 0,
                                    'liked': _reviews[existingIndex]
                                            ['liked'] ??
                                        false,
                                  };
                                } else {
                                  _reviews.add({
                                    'username': currentUser,
                                    'rating': _selectedRating,
                                    'review': _reviewController.text,
                                    'date': DateFormat('yyyy-MM-dd HH:mm')
                                        .format(DateTime.now()),
                                    'good': 0,
                                    'liked': false,
                                  });
                                }
                                _reviewController.clear();
                                _selectedRating = null;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).cardColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            _reviews.any((r) => r['username'] == currentUser)
                                ? '수정하기'
                                : '리뷰 등록하기',
                            style: ColorTextStyle.mediumNavy(context),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 32),
                  Text(
                    '리뷰 ${_reviews.length}',
                    style: ColorTextStyle.mediumNavy(context),
                  ),
                  const SizedBox(height: 16),

                  // 🔹 리뷰 목록
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _reviews.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final review = _reviews[index];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: baseBackgroundColor[200]!),
                        ),
                        child: Text(review['review']),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
