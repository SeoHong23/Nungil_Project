import 'package:nungil/data/objectbox_helper.dart';
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
    deleteIfAllFalse();
  }

  void toggleDisliked() {
    isDisliked = !isDisliked;
    if (isDisliked) isLiked = false;
    if (!isWatched && isDisliked) toggleWatched();
    isModified = true;
    deleteIfAllFalse();
  }

  void toggleWatching() {
    isWatching = !isWatching;
    if (isWatched) toggleWatched();
    isModified = true;
    deleteIfAllFalse();
  }

  void toggleWatched() {
    isWatched = !isWatched;
    if (isWatched) isWatching = false;
    if (!isWatched && isLiked) toggleLiked();
    if (!isWatched && isDisliked) toggleDisliked();
    isModified = true;
    deleteIfAllFalse();
  }

  void toggleBookmarked() {
    isBookmarked = !isBookmarked;
    if (isBookmarked) isIgnored = false;
    isModified = true;
    deleteIfAllFalse();
  }

  void toggleIgnored() {
    isIgnored = !isIgnored;
    if (isIgnored) isBookmarked = false;
    isModified = true;
    deleteIfAllFalse();
  }

  // 모든 상태가 false일 경우 객체 삭제
  void deleteIfAllFalse() {
    if (!isLiked &&
        !isDisliked &&
        !isWatching &&
        !isWatched &&
        !isBookmarked &&
        !isIgnored) {
      if (mongoId != "") {
        ObjectBox().getBox<String>().put(mongoId);
      }
      ObjectBox().getBox<VideoReaction>().remove(objectId); // ObjectBox에서 객체 삭제
    }
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
      isLiked: json['isLiked'],
      isDisliked: json['isDisliked'],
      isWatching: json['isWatching'],
      isWatched: json['isWatched'],
      isBookmarked: json['isBookmarked'],
      isIgnored: json['isIgnored'],
      isModified: false,
    );
  }
}

// VideoReaction 클래스에 JSON 변환 메서드 추가
extension VideoReactionJson on VideoReaction {
  // 서버로 전송할 때 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'objectId': objectId,
      'mongoId': mongoId,
      'videoId': videoId,
      'title': title,
      'posterUrl': posterUrl,
      'isLiked': isLiked,
      'isDisliked': isDisliked,
      'isWatching': isWatching,
      'isWatched': isWatched,
      'isBookmarked': isBookmarked,
      'isIgnored': isIgnored,
      'isModified': isModified,
    };
  }
}
