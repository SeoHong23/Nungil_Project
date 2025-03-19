class Review {
  final String reviewId;
  final int userId;
  final String movieId;
  final String movieTitle;
  final String nick;
  final String content;
  final double rating;
  final String createdAt;
  final int likeCount;
  final bool isLiked;

  Review({
    required this.reviewId,
    required this.userId,
    required this.movieId,
    required this.movieTitle,
    required this.nick,
    required this.content,
    required this.rating,
    required this.createdAt,
    required this.likeCount,
    required this.isLiked,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json['id'] ?? '',
      userId: json['userId'] ?? 0,
      movieId: json['movieId'] ?? '',
      movieTitle: json['movieTitle'] ?? '제목 없음',
      nick: json['nick'] ?? '',
      content: json['content'] ?? '',
      rating: (json['rating'] is int)
          ? (json['rating'] as int).toDouble()
          : (json['rating'] ?? 0.0).toDouble(),
      createdAt: json['createdAt'] ?? '',
      likeCount: json['likeCount'] ?? 0,
      isLiked: json['liked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': reviewId,
      'userId': userId,
      'movieId': movieId,
      'movieTitle': movieTitle,
      'nick': nick,
      'content': content,
      'rating': rating,
      'createdAt': createdAt,
      'likeCount': likeCount,
      'isLiked': isLiked,
    };
  }

  // 수정된 리뷰를 생성하는 메서드 (수정 시 사용)
  Review copyWith({
    String? reviewId,
    int? userId,
    String? movieId,
    String? movieTitle,
    String? nick,
    String? content,
    double? rating,
    String? createdAt,
    int? likeCount,
    bool? isLiked,
  }) {
    return Review(
      reviewId: reviewId ?? this.reviewId,
      userId: userId ?? this.userId,
      movieId: movieId ?? this.movieId,
      movieTitle: movieId ?? this.movieTitle,
      nick: nick ?? this.nick,
      content: content ?? this.content,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
