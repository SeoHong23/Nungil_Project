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
  final String currentUser = "홍합";
  final List<Map<String, dynamic>> _reviews = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseBackgroundColor[50],
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: [
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '리뷰',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            SizedBox(height: 24),

            // 별점 섹션
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
                          borderSide:
                              BorderSide(color: baseBackgroundColor[200]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: baseBackgroundColor[200]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: DefaultColors.navy),
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
                                'good': _reviews[existingIndex]['good'] ?? 0,
                                'liked':
                                    _reviews[existingIndex]['liked'] ?? false,
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
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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

            // 리뷰 목록
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: baseBackgroundColor[100],
                            child: Text(
                              review['username'][0],
                              style: TextStyle(
                                color: DefaultColors.navy,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'GmarketSans',
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review['username'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 16,
                                      color: DefaultColors.yellow,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      review['rating'].toString(),
                                      style: CustomTextStyle.smallLightNavy,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Text(
                            review['date'],
                            style: CustomTextStyle.xSmallNavy,
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        review['review'],
                        style: CustomTextStyle.mediumNavy,
                      ),
                      SizedBox(height: 12),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (_reviews[index]['liked'] == true) {
                              _reviews[index]['good'] =
                                  (_reviews[index]['good'] ?? 0) - 1;
                              _reviews[index]['liked'] = false;
                            } else {
                              _reviews[index]['good'] =
                                  (_reviews[index]['good'] ?? 0) + 1;
                              _reviews[index]['liked'] = true;
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _reviews[index]['liked'] == true
                                ? baseBackgroundColor[100]
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _reviews[index]['liked'] == true
                                  ? DefaultColors.navy
                                  : baseBackgroundColor[200]!,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _reviews[index]['liked'] == true
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 18,
                                color: _reviews[index]['liked'] == true
                                    ? DefaultColors.navy
                                    : DefaultColors.grey,
                              ),
                              SizedBox(width: 8),
                              Text(
                                '${_reviews[index]['good'] ?? 0}',
                                style: _reviews[index]['liked'] == true
                                    ? CustomTextStyle.smallNavy
                                    : CustomTextStyle.smallLightNavy,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
