import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nungil/models/review/review_model.dart';
import 'package:nungil/providers/auth_provider.dart';
import 'package:nungil/util/my_http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReviewRepository {
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
    print('토큰 내용: ${token ?? "토큰 없음"}');

    if (token == null || token.isEmpty) {
      print("⚠️ 저장된 토큰이 없습니다. 로그인 상태를 확인하세요!");
      return {
        'Content-Type': 'application/json; charset=utf-8',
      };
    }
    print("📢 저장된 토큰: $token");

    return {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer $token',
    };
  }

  // 영화별 리뷰 목록
  Future<List<Review>> getReviews(int movieId) async {
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
        print('리뷰 목록 에러 : ${response.statusCode}, ${response.body}');
        return [];
      }
    } catch (e) {
      print('리뷰 가져오기 에러:$e');
      return [];
    }
  }

  // 리뷰 작성
  Future<bool> createReview(Review review) async {
    try {
      final headers = await _getHeaders();
      final reviewJson = jsonEncode(review.toJson());

      print('📢 서버로 보낼 JSON 데이터: $reviewJson'); // ✅ JSON 확인
      print('📢 요청 헤더: $headers'); // ✅ 헤더 확인

      final response = await http.post(
        Uri.parse('$baseUrl/api/movie/reviews/add'),
        headers: headers,
        body: reviewJson,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('리뷰 작성 실패: ${response.statusCode}, ${response.body}');
        return false;
      }
    } catch (e) {
      print('리뷰 생성 중 에러 발생 : $e');
      return false;
    }
  }

  Future<bool> updateReview(Review review) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/api/movie/reviews/update'),
        headers: headers,
        body: jsonEncode(review.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('리뷰 수정 실패 :${response.statusCode}, ${response.body}');
        return false;
      }
    } catch (e) {
      print('리뷰 수정 중 에러 발생 : $e');
      return false;
    }
  }

  Future<bool> deleteReview(String reviewId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/api/movie/reviews/delete/$reviewId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('리뷰 삭제 실패 :${response.statusCode}, ${response.body}');
        return false;
      }
    } catch (e) {
      print('리뷰 삭제 중 에러 발생 : $e');
      return false;
    }
  }

  Future<bool> toggleLike(String reviewId, bool liked) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/api/movie/reviews/like/$reviewId'),
        headers: headers,
        body: jsonEncode({'liked': liked}),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('리뷰 좋아요 실패 : ${response.statusCode}, ${response.body}');
        return false;
      }
    } catch (e) {
      print('리뷰 좋아요 중 에러 발생 :$e');
      return false;
    }
  }
}
