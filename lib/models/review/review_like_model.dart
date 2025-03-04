class ReviewLike {
  final String id;
  final int userId;
  final String reviewId;
  final String createdAt;

  ReviewLike({
    required this.id,
    required this.userId,
    required this.reviewId,
    required this.createdAt,
  });

  factory ReviewLike.fromJson(Map<String, dynamic> json) {
    return ReviewLike(
      id: json['id'] ?? '',
      userId: json['userId'] ?? 0,
      reviewId: json['reviewId'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'reviewId': reviewId,
      'createdAt': createdAt,
    };
  }
}