import 'package:nungil/models/detail/Video.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class VideoReaction {
  @Id()
  int objectId; // 객체의 고유 ID
  String mongoId;

  String videoId;
  String title;
  String posterUrl;

  bool isLiked;
  bool isDisliked;

  bool isWatching;
  bool isWatched;

  bool isBookmarked;
  bool isIgnored;

  bool isModified;

  VideoReaction(
      {this.objectId = 0,
      this.mongoId = "",
      required this.videoId,
      this.title = "",
      this.posterUrl = "",
      this.isLiked = false,
      this.isDisliked = false,
      this.isWatching = false,
      this.isWatched = false,
      this.isBookmarked = false,
      this.isIgnored = false,
      this.isModified = true});

  void toggleLiked() {
    isLiked = !isLiked;
    if (isLiked) isDisliked = false;
    if (!isWatched && isLiked) toggleWatched();
    isModified = true;
  }

  void toggleDisliked() {
    isDisliked = !isDisliked;
    if (isDisliked) isLiked = false;
    if (!isWatched && isDisliked) toggleWatched();
    isModified = true;
  }

  void toggleWatching() {
    isWatching = !isWatching;
    if (isWatched) toggleWatched();
    isModified = true;
  }

  void toggleWatched() {
    isWatched = !isWatched;
    if (isWatched) isWatching = false;
    if (!isWatched && isLiked) toggleLiked();
    if (!isWatched && isDisliked) toggleDisliked();
    isModified = true;
  }

  void toggleBookmarked() {
    isBookmarked = !isBookmarked;
    if (isBookmarked) isIgnored = false;
    isModified = true;
  }

  void toggleIgnored() {
    isIgnored = !isIgnored;
    if (isIgnored) isBookmarked = false;
    isModified = true;
  }
  // 모든 상태가 false일 경우
  bool isAllFalse() {
    return !(isLiked ||
        isDisliked ||
        isWatching ||
        isWatched ||
        isBookmarked ||
        isIgnored);
  }

  static VideoReaction copyWith(Video video) {
    return VideoReaction(
      videoId: video.id,
      title: video.title,
      posterUrl: video.posters[0],
    );
  }

  static VideoReaction copyWithId(String id) {
    return VideoReaction(
      videoId: id,
    );
  }

  // 서버에서 받은 JSON 데이터를 VideoReaction 객체로 변환
  factory VideoReaction.fromJson(Map<String, dynamic> json) {
    return VideoReaction(
      objectId: json['objectId'],
      mongoId: json['mongoId'],
      videoId: json['videoId'],
      title: json['title'],
      posterUrl: json['posterUrl'],
      isLiked: json['isLiked']??false,
      isDisliked: json['isDisliked']??false,
      isWatching: json['isWatching']??false,
      isWatched: json['isWatched']??false,
      isBookmarked: json['isBookmarked']??false,
      isIgnored: json['isIgnored']??false,
      isModified: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'objectId': objectId,
      'mongoId': mongoId,
      'videoId': videoId,
      'userId': 0,
      'title': title,
      'posterUrl': posterUrl,
      'isLiked': isLiked?true:false,
      'isDisliked': isDisliked?true:false,
      'isWatching': isWatching?true:false,
      'isWatched': isWatched?true:false,
      'isBookmarked': isBookmarked?true:false,
      'isIgnored': isIgnored?true:false,
    };
  }

  @override
  String toString() {
    return 'VideoReaction{objectId: $objectId, mongoId: $mongoId, videoId: $videoId, title: $title, posterUrl: $posterUrl, isLiked: $isLiked, isDisliked: $isDisliked, isWatching: $isWatching, isWatched: $isWatched, isBookmarked: $isBookmarked, isIgnored: $isIgnored, isModified: $isModified}';
  }
}
