import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:nungil/data/repository/review_repository.dart';
import 'package:nungil/models/detail/Video.dart';
import 'package:nungil/models/review/review_model.dart';
import 'package:nungil/providers/auth_provider.dart';
import 'package:nungil/screens/common_components/rating_widget.dart';
import 'package:nungil/theme/common_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reviewRepositoryProvider = Provider((ref) => ReviewRepository(ref));

final reviewsProvider =
    FutureProvider.family<List<Review>, dynamic>((ref, movieId) async {
  final repository = ref.watch(reviewRepositoryProvider);
  final movieIdInt = movieId is String ? int.tryParse(movieId) ?? 0 : movieId;
  return await repository.getReviews(movieIdInt);
});

class DetailTapReview extends ConsumerStatefulWidget {
  final Video item;
  const DetailTapReview({required this.item, super.key});

  @override
  ConsumerState<DetailTapReview> createState() => _DetailTapReviewState();
}

class _DetailTapReviewState extends ConsumerState<DetailTapReview> {
  double? _selectedRating;
  final TextEditingController _reviewController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isSaving = false;
  String? _editingReviewId;

  // final List<Map<String, dynamic>> _reviews = [];

  @override
  void initState() {
    super.initState();

    _reviewController.addListener(() {
      if (_reviewController.text.isNotEmpty && _scrollController.hasClients) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
  }

  String get _currentUsername {
    final authState = ref.read(authProvider);
    return authState.user!.nickname;
  }

  int get _currentUserId {
    final authState = ref.read(authProvider);
    return authState.user!.userId;
  }

  bool get _isLoggedIn {
    final authState = ref.read(authProvider);
    return authState.isAuthenticated;
  }

  Future<void> _toggleLike(Review review) async {
    if (!_isLoggedIn) {
      _showLoginRequiredDialog();
      return;
    }

    final repository = ref.read(reviewRepositoryProvider);
    final newLikedStatus = !review.isLiked;

    ref.invalidate(reviewsProvider(widget.item.id));

    try {
      final success =
          await repository.toggleLike(review.reviewId, newLikedStatus);

      if (!success) {
        ref.invalidate(reviewsProvider(widget.item.id));
        _showSnackBar('좋아요 업데이트 실패');
      }
    } catch (e) {
      ref.invalidate(reviewsProvider(widget.item.id));
      _showSnackBar('좋아요 업데이트 중 오류 발생');
    }
  }

  void _editReview(Review review) {
    setState(() {
      // _editingReviewId = review.reviewId;
      _reviewController.text = review.content;
      _selectedRating = review.rating;
    });

    // 스크롤을 맨 위로 이동
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(
          milliseconds: 300,
        ),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _deleteReview(Review review) async {
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
            onPressed: () async {
              Navigator.pop(context);
              final repository = ref.read(reviewRepositoryProvider);
              final success = await repository.deleteReview(review.reviewId);

              if (success) {
                ref.invalidate(reviewsProvider(widget.item.id));
                _showSnackBar('리뷰가 삭제되었습니다');
              } else {
                _showSnackBar('리뷰 삭제를 실패했습니다');
              }
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _saveReview() async {
    if (!_isLoggedIn) {
      _showLoginRequiredDialog();
      return;
    }
    if (_selectedRating == null) {
      print('별점을 선택해주세요!');
      return;
    }
    if (_reviewController.text.isEmpty) {
      print('리뷰 내용을 작성해주세요!');
      return;
    }
    setState(() {
      _isSaving = true;
    });

    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);
    final repository = ref.read(reviewRepositoryProvider);
    final userId = _currentUserId;

    if (userId == null) {
      setState(() {
        _isSaving = false;
      });
      _showLoginRequiredDialog();
      return;
    }

    try {
      if (_editingReviewId != null) {
        final updatedReview = Review(
          reviewId: _editingReviewId!,
          userId: userId,
          movieId: widget.item.id,
          nick: _currentUsername,
          content: _reviewController.text,
          rating: _selectedRating!,
          createdAt: formattedDate,
          likeCount: 0,
          isLiked: false,
        );

        final success = await repository.updateReview(updatedReview);

        if (success) {
          ref.invalidate(reviewsProvider(widget.item.id));

          setState(() {
            _reviewController.clear();
            _selectedRating = null;
            _editingReviewId = null;
          });

          _showSnackBar('리뷰가 수정되었습니다.');
        } else {
          _showSnackBar('리뷰 수정을 실패했습니다.');
        }
      } else {
        final newReview = Review(
          reviewId: '',
          userId: userId,
          movieId: widget.item.id,
          nick: _currentUsername,
          content: _reviewController.text,
          rating: _selectedRating!,
          createdAt: formattedDate,
          likeCount: 0,
          isLiked: false,
        );

        final success = await repository.createReview(newReview);

        if (success) {
          ref.invalidate(reviewsProvider(widget.item.id));

          setState(() {
            _reviewController.clear();
            _selectedRating = null;
          });

          _showSnackBar('리뷰가 등록되었습니다');
        } else {
          _showSnackBar('리뷰 등록에 실패했습니다');
        }
      }
    } catch (e) {
      _showSnackBar('리뷰 저장 중 오류가 발생했습니다');
      print('리뷰 저장 오류: $e');
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그인 필요'),
        content: const Text('로그인 필수! 로그인 페이지로 이동하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/login');
            },
            child: const Text('로그인'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemId = int.tryParse(widget.item.id.toString()) ?? 0;
    final reviewsAsyncValue = ref.watch(reviewsProvider(itemId));
    final authState = ref.watch(authProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: reviewsAsyncValue.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('리뷰 불러오는 중 에러 발생 : $error'),
                ),
                data: (reviews) {
                  return ListView(
                    controller: _scrollController,
                    children: [
                      // 별점 입력 영역
                      if (_isLoggedIn) ...[
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
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: _showLoginRequiredDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              '로그인 하고 리뷰작성하기',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],

                      if (_isLoggedIn && _selectedRating != null) ...[
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: TextField(
                                controller: _reviewController,
                                maxLines: 4,
                                style: ColorTextStyle.mediumNavy(context),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor:
                                      Theme.of(context).colorScheme.surface,
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                  contentPadding: const EdgeInsets.all(16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: ElevatedButton(
                                onPressed: _isSaving ? null : _saveReview,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).cardColor,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: _isSaving
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        _editingReviewId != null
                                            ? '수정하기'
                                            : '리뷰 등록하기',
                                        style:
                                            ColorTextStyle.mediumNavy(context),
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
                          '리뷰 ${reviews.length}',
                          style: ColorTextStyle.mediumNavy(context),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 리뷰 목록
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: reviews.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final review = reviews[index];
                          final isCurrentUser = authState.isAuthenticated &&
                              review.userId == authState.user?.userId;

                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: baseBackgroundColor[200]!),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      review.nick,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: DefaultColors.navy,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    RatingBarIndicator(
                                      rating: review.rating,
                                      itemBuilder: (context, index) =>
                                          const Icon(Icons.star,
                                              color: Colors.amber),
                                      itemCount: 5,
                                      itemSize: 16.0,
                                    ),
                                    if (isCurrentUser) ...[
                                      const Spacer(),
                                      PopupMenuButton<String>(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(Icons.more_vert,
                                            size: 20),
                                        onSelected: (value) {
                                          if (value == 'edit') {
                                            _editReview(review);
                                          } else if (value == 'delete') {
                                            _deleteReview(review);
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
                                                    size: 20,
                                                    color: Colors.red),
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
                                Text(review.content),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      review.createdAt,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            review.isLiked
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            size: 18,
                                            color: review.isLiked
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                          onPressed: () => _toggleLike(review),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                        Text(
                                          '${review.likeCount}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
