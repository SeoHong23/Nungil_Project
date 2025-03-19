import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nungil/models/review/review_model.dart';
import 'package:nungil/providers/auth_http_service.dart';
import 'package:nungil/providers/auth_provider.dart';
import 'package:nungil/providers/auth_http_service.dart';
import 'package:nungil/util/my_http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReviewRepository {
  final Ref _ref;

  ReviewRepository(this._ref);

  // 토큰 확인 기능 (디버깅 용도)
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final isLoggedIn = prefs.getBool('isLoggedIn');
    final userId = prefs.getInt('userId');

    print('🔍 토큰 디버깅 정보:');
    print('로그인 상태: $isLoggedIn');
    print('UserId: $userId');
    print('토큰 존재 여부: ${token != null}');
    print('토큰 길이: ${token?.length}');

    if (token != null && token.isNotEmpty) {
      final truncatedToken =
          token.length > 20 ? '${token.substring(0, 10)}...' : token;
      print('토큰 내용: $truncatedToken');
    } else {
      print('토큰 내용: 토큰 없음');
      print('! 저장된 토큰이 없습니다. 로그인 상태를 확인하세요!');
    }

    if (token == null || token.isEmpty) {
      return {
        'Content-Type': 'application/json; charset=utf-8',
      };
    }

    return {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer $token',
    };
  }

// 영화별 리뷰 목록
  Future<Map<String, dynamic>> getReviews(String movieId) async {
    try {
      final headers = await _getHeaders();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      String url = '$baseUrl/api/movie/reviews/$movieId';
      if (userId != null && userId > 0) {
        url += '?userId=$userId';
      }

      print('📢 사용자 ID: $userId');
      print('📢 리뷰 목록 요청 URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print("📢 API 응답 코드: ${response.statusCode}");
      print("📢 API 응답 본문: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));

        if (decoded is Map) {

          print("✅ 리뷰 개수 포함 응답 처리.");

          int reviewCount = decoded['count'];

          List<Review> reviews = (decoded['reviews'] as List)
              .map((json) => Review.fromJson(json))
              .toList();

          return {"count": reviewCount, "reviews": reviews};

        } else if (decoded is List) {
          print("✅ 리뷰 목록만 응답 처리.");

          List<Review> reviews =
              decoded.map((json) => Review.fromJson(json)).toList();
          return {"count": reviews.length, "reviews": reviews};
        } else {
          print("❌ 예상치 못한 응답 형식: ${decoded.runtimeType}");
          return {"count": 0, "reviews": []};
        }
      } else {
        print("❌ 리뷰 목록 에러: ${response.statusCode}, ${response.body}");
        return {"count": 0, "reviews": []};
      }
    } catch (e) {
      print("❌ 리뷰 가져오기 에러: $e");
      return {"count": 0, "reviews": []};
    }
  }

  Future<List<Review>> getUserReviews() async {
    try {
      final headers = await _getHeaders();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      if(userId == null) {
        print("사용자 ID 가 없습니다!");
        return[];
      }

      String url = '$baseUrl/api/user/reviews/$userId';

      print('📢 사용자 리뷰 요청 URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print("API 응답코드 : ${response.statusCode}");
      print("API 응답 본문 : ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));

        List<dynamic> reviewList = decoded['reviews'] ?? [];
        List<Review> reviews = reviewList.map((json) => Review.fromJson(json)).toList();

        return reviews;
      } else {
        print("❌ 리뷰 불러오기 실패: ${response.statusCode}, ${response.body}");
        return [];
      }
    } catch (e) {
      print("❌ 리뷰 가져오기 예외 발생: $e");
      return [];
    }
  }


  // 리뷰 작성
  Future<bool> createReview(Review review) async {
    try {
      final headers = await _getHeaders();

      final Map<String, dynamic> requestBody = {
        'userId': review.userId,
        'movieId': review.movieId,
        'content': review.content,
        'rating': review.rating,
        'nick': review.nick,
        'createdAt': DateTime.now().toIso8601String(),
      };

      print('📢 서버로 보낼 JSON 데이터: ${jsonEncode(requestBody)}');
      print('📢 요청 헤더: $headers');

      final response = await http.post(
        Uri.parse('$baseUrl/api/movie/reviews/add'),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print('  리뷰 작성 성공!');
        return true;
      } else {
        print('  리뷰 작성 실패: ${response.statusCode}, ${response.body}');

        if (response.body.isNotEmpty) {
          try {
            final errorData = jsonDecode(response.body);
            print('에러 상세: $errorData');
          } catch (_) {
            print('에러 응답이 JSON 형식이 아닙니다.');
          }
        }
        return false;
      }
    } catch (e) {
      print('  리뷰 생성 중 예외 발생: $e');
      return false;
    }
  }

  // 리뷰 수정
  Future<bool> updateReview(Review review) async {
    try {
      final headers = await _getHeaders();

      final Map<String, dynamic> requestBody = {
        'id': review.reviewId,
        'userId': review.userId,
        'movieId': review.movieId,
        'content': review.content,
        'rating': review.rating,
        'nick': review.nick,
      };
      print('📢 서버로 보낼 수정 리뷰 데이터: ${jsonEncode(requestBody)}');

      final response = await http.put(
        Uri.parse('$baseUrl/api/movie/reviews/update'),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print('  리뷰 수정 성공!');
        return true;
      } else {
        print('  리뷰 수정 실패: ${response.statusCode}, ${response.body}');
        return false;
      }
    } catch (e) {
      print('  리뷰 수정 중 예외 발생: $e');
      return false;
    }
  }

  // 리뷰 삭제
  Future<bool> deleteReview(String reviewId) async {
    try {
      final headers = await _getHeaders();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId') ?? 0;

      print('📢 삭제할 리뷰 ID: $reviewId');
      print('📢 사용자 ID: $userId');

      final response = await http.delete(
        Uri.parse('$baseUrl/api/movie/reviews/delete/$reviewId?userId=$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        print('  리뷰 삭제 성공!');
        return true;
      } else {
        print('  리뷰 삭제 실패: ${response.statusCode}, ${response.body}');
        return false;
      }
    } catch (e) {
      print('  리뷰 삭제 중 예외 발생: $e');
      return false;
    }
  }

  // 리뷰 좋아요 토글
  Future<bool> toggleLike(String reviewId, bool liked) async {
    try {
      final headers = await _getHeaders();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId') ?? 0;

      print('📢 좋아요 토글 - 리뷰 ID: $reviewId, 좋아요: $liked, 사용자 ID : $userId');
      final response = await http.post(
        Uri.parse('$baseUrl/api/movie/reviews/like/$reviewId'),
        headers: headers,
        body: jsonEncode({'userId': userId, 'liked': liked}),
      );

      if (response.statusCode == 200) {
        print('  리뷰 좋아요 토글 성공!');
        return true;
      } else {
        print('  리뷰 좋아요 토글 실패: ${response.statusCode}, ${response.body}');
        return false;
      }
    } catch (e) {
      print('  리뷰 좋아요 토글 중 예외 발생: $e');
      return false;
    }
  }

  // AuthHttpService로 천천히 마이그레이션하기 위한 준비 메서드
  // 나중에 모든 메서드가 이것을 사용하도록 변경할 수 있습니다
  AuthHttpService _getHttpService() {
    return _ref.read(authHttpServiceProvider);
  }
}

// ReviewRepository Provider
final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepository(ref);
});

final userReviewsProvider = FutureProvider<List<Review>>((ref) async {
  final repository = ref.watch(reviewRepositoryProvider);
  return repository.getUserReviews();
});
