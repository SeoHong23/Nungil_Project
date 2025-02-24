import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nungil/models/list/video_list_model.dart';
import 'package:nungil/util/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/ranking/video_rank_model.dart';
import '../../util/my_http.dart';

class VideoListRepository {
  const VideoListRepository();

  // 사용안함
  Future<List<VideoListModel>> fetchVideos(int page, int size) async {
    try {
      // ✅ API 호출 (JSON 데이터 직접 받음)
      Response response =
          await dio.get('/api/videos/paged?page=$page&size=$size');

      // ✅ response.data가 이미 JSON 형태일 가능성이 높음 → json.decode 제거
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map(
                (item) => VideoListModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print("Error fetching videos: $e");
      throw Exception('Failed to load videos');
    }
  }

  Future<List<VideoListModel>> fetchVideosWithFilter(int page, int size,
      Map<String, Set<String>> filter, String sortOrder, bool isNotOpen) async {
    Map<String, dynamic> queryParams =
        _buildQueryParams(page, size, filter, sortOrder, isNotOpen);
    try {
      // ✅ API 호출 (JSON 데이터 직접 받음)
      Response response =
          await dio.get('/api/videos/paged', queryParameters: queryParams);

      // ✅ response.data가 이미 JSON 형태일 가능성이 높음 → json.decode 제거
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map(
                (item) => VideoListModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print("Error fetching videos: $e");
      throw Exception('Failed to load videos');
    }
  }

  // 랜덤한 영상 10개
  Future<List<VideoListModel>> fetchVideosRandom(int size) async {
    try {
      // ✅ API 호출 (JSON 데이터 직접 받음)
      Response response = await dio.get('/api/videos/random?size=$size');

      // ✅ response.data가 이미 JSON 형태일 가능성이 높음 → json.decode 제거
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map(
                (item) => VideoListModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print("Error fetching videos: $e");
      throw Exception('Failed to load videos');
    }
  }

  Future<List<VideoRankModel>> fetchRanksDaily() async {
    return await _fetchRanks(
        '/api/ranking/daily', 'cached_ranks_daily', 'cached_date_daily');
  }

  Future<List<VideoRankModel>> fetchRanksWeekly() async {
    return await _fetchRanks(
        '/api/ranking/weekly', 'cached_ranks_weekly', 'cached_date_weekly');
  }

  Future<List<VideoRankModel>> _fetchRanks(
      String url, String cacheKey, String dateKey) async {
    final prefs = await SharedPreferences.getInstance();
    final String today = _getTodayDate();

    // ✅ 캐싱된 날짜 확인
    final String? cachedDate = prefs.getString(dateKey);
    final String? cachedData = prefs.getString(cacheKey);

    // ✅ 오늘 날짜와 같다면, 캐싱된 데이터 반환
    if (cachedDate == today && cachedData != null) {
      print('🔹 캐싱된 데이터 사용: $cacheKey');
      final List<dynamic> decoded = jsonDecode(cachedData);
      return decoded.map((item) => VideoRankModel.fromJson(item)).toList();
    }

    try {
      // ✅ API 호출 (JSON 데이터 직접 받음)
      Response response = await dio.get(url);

      if (response.statusCode == 200 && response.data is List) {
        List<VideoRankModel> ranks = (response.data as List)
            .map(
                (item) => VideoRankModel.fromJson(item as Map<String, dynamic>))
            .toList();

        // ✅ 새 데이터 캐싱
        await prefs.setString(
            cacheKey, jsonEncode(ranks.map((e) => e.toJson()).toList()));
        await prefs.setString(dateKey, today);

        print('🆕 새로운 데이터 저장: $cacheKey');
        return ranks;
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print("⚠️ Error fetching videos: $e");
      throw Exception('Failed to load videos');
    }
  }

  // ✅ 오늘 날짜를 yyyy-MM-dd 형식으로 반환
  String _getTodayDate() {
    return DateTime.now().toIso8601String().split('T')[0];
  }

  Map<String, dynamic> _buildQueryParams(int page, int size,
      Map<String, Set<String>> filters, String sortOrder, bool isNotOpen) {
    Map<String, dynamic> queryParams = {
      "page": page,
      "size": size,
      "orderBy": sortOrder,
      "isNotOpen": isNotOpen
    };

    filters.forEach(
      (key, values) {
        if (values.isNotEmpty) {
          queryParams[key] = values.join(","); // "장르=액션,SF" 형식으로 변환
        }
      },
    );
    return queryParams;
  }

  Future<List<VideoListModel>> searchVideos(
      int page, int size, String query, String searchType) async {
    try {
      final response = await dio.get("/api/videos/search", queryParameters: {
        "page": page,
        "size": size,
        "query": query,
        "searchType": searchType
      });

      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map(
                (item) => VideoListModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print("Error fetching videos: $e");
      throw Exception('Failed to load videos');
    }
  }
}
