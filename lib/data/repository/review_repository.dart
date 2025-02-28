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

  // 생성자 변경 - 지연 초기화 대신 직접 참조로 변경
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
  Future<List<Review>> getReviews(String movieId) async {
    try {
      final headers = await _getHeaders();

      final response = await http.get(
        Uri.parse('$baseUrl/api/movie/reviews/$movieId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList =
            jsonDecode(utf8.decode(response.bodyBytes));
        return jsonList.map((json) => Review.fromJson(json)).toList();
      } else {
        print('리뷰 목록 에러: ${response.statusCode}, ${response.body}');
        return [];
      }
    } catch (e) {
      print('리뷰 가져오기 에러: $e');
      return [];
    }
  }

  // 리뷰 작성
  Future<bool> createReview(Review review) async {
    try {
      final headers = await _getHeaders();

      // 서버에서 기대하는 형식으로 요청 본문 구성
      final Map<String, dynamic> requestBody = {
        'userId': review.userId, // int를 Long으로 자동 변환됨
        'movieId': review.movieId, // 이미 문자열이라 문제 없음
        'content': review.content,
        'rating': review.rating,
        'nick': review.nick,
        // createdAt을 ISO 형식으로 변환 (서버에서 파싱 가능한 형식)
        'createdAt': DateTime.now().toIso8601String(),
        // id 필드는 생략 (서버에서 자동 생성)
      };

      print('📢 서버로 보낼 JSON 데이터: ${jsonEncode(requestBody)}');
      print('📢 요청 헤더: $headers');

      final response = await http.post(
        Uri.parse('$baseUrl/api/movie/reviews/add'),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print('✅ 리뷰 작성 성공!');
        return true;
      } else {
        print('❌ 리뷰 작성 실패: ${response.statusCode}, ${response.body}');

        // 에러 응답 분석 (디버깅 용도)
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
      print('❌ 리뷰 생성 중 예외 발생: $e');
      return false;
    }
  }

  // 리뷰 수정
  Future<bool> updateReview(Review review) async {
    try {
      final headers = await _getHeaders();
      final reviewJson = jsonEncode(review.toJson());

      print('📢 서버로 보낼 수정 리뷰 데이터: $reviewJson');

      final response = await http.put(
        Uri.parse('$baseUrl/api/movie/reviews/update'),
        headers: headers,
        body: reviewJson,
      );

      if (response.statusCode == 200) {
        print('✅ 리뷰 수정 성공!');
        return true;
      } else {
        print('❌ 리뷰 수정 실패: ${response.statusCode}, ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ 리뷰 수정 중 예외 발생: $e');
      return false;
    }
  }

  // 리뷰 삭제
  Future<bool> deleteReview(String reviewId) async {
    try {
      final headers = await _getHeaders();

      print('📢 삭제할 리뷰 ID: $reviewId');

      final response = await http.delete(
        Uri.parse('$baseUrl/api/movie/reviews/delete/$reviewId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        print('✅ 리뷰 삭제 성공!');
        return true;
      } else {
        print('❌ 리뷰 삭제 실패: ${response.statusCode}, ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ 리뷰 삭제 중 예외 발생: $e');
      return false;
    }
  }

  // 리뷰 좋아요 토글
  Future<bool> toggleLike(String reviewId, bool liked) async {
    try {
      final headers = await _getHeaders();

      print('📢 좋아요 토글 - 리뷰 ID: $reviewId, 좋아요: $liked');

      final response = await http.post(
        Uri.parse('$baseUrl/api/movie/reviews/like/$reviewId'),
        headers: headers,
        body: jsonEncode({'liked': liked}),
      );

      if (response.statusCode == 200) {
        print('✅ 리뷰 좋아요 토글 성공!');
        return true;
      } else {
        print('❌ 리뷰 좋아요 토글 실패: ${response.statusCode}, ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ 리뷰 좋아요 토글 중 예외 발생: $e');
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
