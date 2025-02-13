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
        Future.delayed(Duration(milliseconds: 100), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
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
      backgroundColor: baseBackgroundColor[50],
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '리뷰',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // 🔹 Expanded를 사용하여 화면 높이를 유지하고 ListView 사용 가능하게 함
            Expanded(
              child: ListView(
                controller: _scrollController, // 🔹 스크롤 컨트롤러 추가
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // ⭐ 별점 입력 영역
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: baseBackgroundColor[200]!),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '이 작품 어떠셨나요?',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        SizedBox(height: 20),
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
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: baseBackgroundColor[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: _reviewController,
                            maxLines: 4,
                            style: CustomTextStyle.mediumNavy,
                            decoration: InputDecoration(
                              hintText: '작품에 대한 솔직한 리뷰를 남겨주세요',
                              hintStyle: TextStyle(
                                color: DefaultColors.grey,
                                fontSize: 15,
                                fontFamily: 'Pretendard',
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: baseBackgroundColor[200]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: baseBackgroundColor[200]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: DefaultColors.navy),
                              ),
                              contentPadding: EdgeInsets.all(16),
                            ),
                          ),
                          SizedBox(height: 16),
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
                              backgroundColor: DefaultColors.navy,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              _reviews.any((r) => r['username'] == currentUser)
                                  ? '수정하기'
                                  : '리뷰 등록하기',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'GmarketSans',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '모든 리뷰',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: baseBackgroundColor[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_reviews.length}개',
                          style: CustomTextStyle.smallNavy,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // 🔹 리뷰 목록
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _reviews.length,
                    separatorBuilder: (context, index) => SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final review = _reviews[index];
                      return Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: baseBackgroundColor[200]!),
                        ),
                        child: Text(review['review']),
                      );
                    },
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
