import 'package:nungil/data/objectbox_helper.dart';
import 'package:nungil/models/detail/VideoReaction.dart';
import 'package:nungil/objectbox.g.dart';
import 'package:nungil/util/logger.dart';
import 'package:nungil/util/my_http.dart';

class VideoReactionRepository {
  // 싱글톤 인스턴스
  static final VideoReactionRepository _instance =
      VideoReactionRepository._internal();

  // factory 생성자 (한 번만 초기화되고 이후 동일한 인스턴스를 반환)
  factory VideoReactionRepository() {
    return _instance;
  }

  // private 생성자
  VideoReactionRepository._internal();

  // ObjectBox의 VideoReaction 박스를 가져오는 getter
  final reactionBox = ObjectBox().getBox<VideoReaction>();

  // isLiked가 true인 영화 리스트 조회
  List<VideoReaction> getLikedMovies() {
    return reactionBox
        .query(VideoReaction_.isLiked.equals(true))
        .build()
        .find();
  }

  // isDisliked가 true인 영화 리스트 조회
  List<VideoReaction> getDislikedMovies() {
    return reactionBox
        .query(VideoReaction_.isDisliked.equals(true))
        .build()
        .find();
  }

  // isIgnored가 true인 영화 리스트 조회
  List<VideoReaction> getIgnoredMovies() {
    return reactionBox
        .query(VideoReaction_.isIgnored.equals(true))
        .build()
        .find();
  }

  // isBookmarked가 true인 영화 리스트 조회
  List<VideoReaction> getBookmarkedMovies() {
    return reactionBox
        .query(VideoReaction_.isBookmarked.equals(true))
        .build()
        .find();
  }

  // isWatched가 true인 영화 리스트 조회
  List<VideoReaction> getWatchedMovies() {
    return reactionBox
        .query(VideoReaction_.isWatched.equals(true))
        .build()
        .find();
  }

  // isWatching이 true인 영화 리스트 조회
  List<VideoReaction> getWatchingMovies() {
    return reactionBox
        .query(VideoReaction_.isWatching.equals(true))
        .build()
        .find();
  }

  // isModified가 true인 영화 리스트 조회
  List<VideoReaction> getModifiedMovies() {
    return reactionBox
        .query(VideoReaction_.isModified.equals(true))
        .build()
        .find();
  }

  // isModified가 true인 영화 삭제
  void removeModifiedMovies() {
    final modifiedMovies = getModifiedMovies();
    for (var movie in modifiedMovies) {
      reactionBox.remove(movie.objectId);
    }
  }

  // VideoReaction 객체를 업데이트 (isModified 값 변경)
  void updateVideoReaction(VideoReaction videoReaction) {
    reactionBox.put(videoReaction);
  }

  Future<void> syncUserReactions(int userId) async {
    if(getModifiedMovies().isEmpty&&ObjectBox().getBox<VideoReaction>().isEmpty()) return;

    try {
      // POST 요청 보내기
      final response = await dio
          .post("/sync/$userId", data: {"reactions": getModifiedMovies(),
        "deletedItems": ObjectBox().getBox<String>().getAll()
      });

      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data;
        List<VideoReaction> updatedReactions =
            responseData.map((data) => VideoReaction.fromJson(data)).toList();
        // 삭제한 데이터 초기화
        ObjectBox().getBox<String>().removeAll();
        logger.i("업데이트된 반응 목록: $updatedReactions");
      } else {
        logger.w("동기화 실패: ${response.statusMessage}");
      }
    } catch (e) {
      logger.e("에러 발생: $e");
    }
  }
}
