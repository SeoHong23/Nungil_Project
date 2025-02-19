class Review {
  final int reviewId;
  final int userId;
  final int movieId;
  final String nick; // 작성자 닉네임
  final String content; // 리뷰 내용
  final double rating; // 평점
  final String createdAt;
  final int likeCount; // 좋아요 수
  final bool isLiked; // 좋아요 눌렸는지 유무확인

  Review(
      {required this.reviewId,
      required this.userId,
      required this.movieId,
      required this.nick,
      required this.content,
      required this.rating,
      required this.createdAt,
      required this.likeCount,
      required this.isLiked});
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json['reviewId'],
      userId: json['userId'],
      nick: json['nick'],
      movieId: json['movieId'],
      content: json['content'],
      rating: json['rating'].toDouble(),
      createdAt: json['createdAt'],
      likeCount: json['likeCount'],
      isLiked: json['isLiked'],
    );
  }
}
