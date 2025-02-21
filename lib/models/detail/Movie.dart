import 'package:nungil/models/detail/Video.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Movie {
  @Id()
  int id; // 객체의 고유 ID

  String videoId;
  String title;
  String posterUrl;

  bool isLiked;
  bool isDisliked;
  bool isWatching;
  bool isWatched;
  bool isBookmarked;
  bool isIgnored;

  Movie({
    this.id = 0,
    required this.videoId,
    required this.title,
    required this.posterUrl,
    this.isLiked = false,
    this.isDisliked = false,
    this.isWatching = false,
    this.isWatched = false,
    this.isBookmarked = false,
    this.isIgnored = false,
  });

  void toggleLiked() {
    isLiked = !isLiked;
    if (isLiked) isDisliked = false;
    if (!isWatched&&isLiked) toggleWatched();
  }

  void toggleDisliked() {
    isDisliked = !isDisliked;
    if (isDisliked) isLiked = false;
    if (!isWatched&&isDisliked) toggleWatched();
  }

  void toggleWatching() {
    isWatching = !isWatching;
    if (isWatched) toggleWatched();
  }

  void toggleWatched() {
    isWatched = !isWatched;
    if (isWatched) isWatching = false;
    if (!isWatched&&isLiked) toggleLiked();
    if (!isWatched&&isDisliked) toggleDisliked();
  }

  void toggleBookmarked() {
    isBookmarked = !isBookmarked;
    if (isBookmarked) isIgnored = false;
  }

  void toggleIgnored() {
    isIgnored = !isIgnored;
    if (isIgnored) isBookmarked = false;
  }

  static Movie copyWith(Video video){
    return Movie(
      videoId: video.id,
      title: video.title,
      posterUrl: video.posters[0],
    );
  }
}