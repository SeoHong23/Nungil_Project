import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nungil/models/review/review_model.dart';
import 'package:nungil/util/my_http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReviewRepository {
  final String baseURl = 'http://13.239.238.92:8080';

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    return {
      'Content-Type': 'application/json',
      'Authorization': token.isNotEmpty ? 'Bearer $token' : '',
    };
  }

// 뭐야
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
      final response = await http.post(
        Uri.parse('$baseUrl/api/movie/reviews/add'),
        headers: headers,
        body: jsonEncode(review.toJson()),
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
