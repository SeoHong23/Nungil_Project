import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:nungil/models/detail/Video.dart';
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
  final ScrollController _scrollController = ScrollController();
  final String currentUser = "홍합";
  final List<Map<String, dynamic>> _reviews = [];

  @override
  void initState() {
    super.initState();
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

  void _toggleLike(int index) {
    setState(() {
      _reviews[index]['liked'] = !(_reviews[index]['liked'] ?? false);
      _reviews[index]['good'] = _reviews[index]['liked']
          ? (_reviews[index]['good'] ?? 0) + 1
          : (_reviews[index]['good'] ?? 1) - 1;
    });
  }

  void _editReview(Map<String, dynamic> review, int index) {
    _reviewController.text = review['review'];
    _selectedRating = review['rating'];
    setState(() {});

    // 스크롤을 맨 위로 이동
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _deleteReview(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('리뷰 삭제'),
        content: const Text('리뷰를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _reviews.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                controller: _scrollController,
                children: [
                  // 별점 입력 영역
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            controller: _reviewController,
                            maxLines: 4,
                            style: ColorTextStyle.mediumNavy(context),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface,
                              hintText: '작품에 대한 솔직한 리뷰를 남겨주세요',
                              hintStyle:
                                  ColorTextStyle.mediumLightNavy(context),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '리뷰 ${_reviews.length}',
                      style: ColorTextStyle.mediumNavy(context),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 리뷰 목록
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _reviews.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final review = _reviews[index];
                      final isCurrentUser = review['username'] == currentUser;

                      return Container(
                        padding: const EdgeInsets.all(16),
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
                                Text(
                                  review['username'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: DefaultColors.navy,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                RatingBarIndicator(
                                  rating: review['rating'] ?? 0,
                                  itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.amber),
                                  itemCount: 5,
                                  itemSize: 16.0,
                                ),
                                if (isCurrentUser) ...[
                                  const Spacer(),
                                  PopupMenuButton<String>(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(Icons.more_vert, size: 20),
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        _editReview(review, index);
                                      } else if (value == 'delete') {
                                        _deleteReview(index);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem<String>(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit, size: 20),
                                            SizedBox(width: 8),
                                            Text('수정하기'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete,
                                                size: 20, color: Colors.red),
                                            SizedBox(width: 8),
                                            Text('삭제하기',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(review['review']),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  review['date'] ?? '',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        review['liked'] ?? false
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        size: 18,
                                        color: review['liked'] ?? false
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                      onPressed: () => _toggleLike(index),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                    Text(
                                      '${review['good'] ?? 0}',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
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
