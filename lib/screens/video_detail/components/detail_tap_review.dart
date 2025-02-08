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
  final String currentUser = "홍합"; // testid 나중엔 api
  final List<Map<String, dynamic>> _reviews = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '나의 리뷰',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        '이 작품 어떠셨나요?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: DefaultColors.black,
                        ),
                      ),
                      SizedBox(height: 24),
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
                  SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _reviewController,
                          maxLines: 5,
                          style: TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            hintText: '작품에 대한 솔직한 리뷰를 남겨주세요',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.blue[400]!),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
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
                              backgroundColor: Colors.blue[400],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              _reviews.any((r) => r['username'] == currentUser)
                                  ? '수정하기'
                                  : '리뷰 등록하기',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                SizedBox(height: 32),
                Text(
                  '모든 리뷰',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _reviews.length,
                  separatorBuilder: (context, index) => Divider(height: 32),
                  itemBuilder: (context, index) {
                    final review = _reviews[index];
                    return Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey[200],
                                child: Text(
                                  review['username'][0],
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    review['username'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${review['rating']}⭐',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Text(
                                review['date'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            review['review'],
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.favorite,
                                        color: _reviews[index]['liked'] == true
                                            ? Colors.red
                                            : Colors.grey),
                                    onPressed: () {
                                      print('좋아요버튼눌림');
                                      setState(() {
                                        if (_reviews[index]['liked'] == true) {
                                          _reviews[index]['good'] =
                                              (_reviews[index]['good'] ?? 0) -
                                                  1;

                                          _reviews[index]['liked'] = false;
                                        } else {
                                          _reviews[index]['good'] =
                                              (_reviews[index]['good'] ?? 0) +
                                                  1;
                                          _reviews[index]['liked'] = true;
                                        }
                                      });
                                      print('현재 좋아요 상태: ${_reviews[index]}');
                                    },
                                  ),
                                  Text('${_reviews[index]['good'] ?? 0} '),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
