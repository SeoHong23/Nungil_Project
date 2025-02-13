class Review {
  final int reviewId;
  final int userId;
  final int movieId;
  final double rating;
  final String content;

  Review(
      {required this.reviewId,
      required this.userId,
      required this.movieId,
      required this.rating,
      required this.content});
}
