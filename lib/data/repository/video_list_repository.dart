import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nungil/models/list/video_list_model.dart';

import '../../models/ranking/video_rank_model.dart';
import '../../util/my_http.dart';

class VideoListRepository {
  const VideoListRepository();

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

  Future<List<VideoListModel>> fetchVideosWithFilter(
      int page, int size, Map<String, Set<String>> filter) async {
    Map<String, dynamic> queryParams = _buildQueryParams(page, size, filter);
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

  Future<List<VideoRankModel>> fetchRanksDaily() async {
    try {
      // ✅ API 호출 (JSON 데이터 직접 받음)
      Response response = await dio.get('/api/ranking/daily');

      // ✅ response.data가 이미 JSON 형태일 가능성이 높음 → json.decode 제거
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map(
                (item) => VideoRankModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print("Error fetching videos: $e");
      throw Exception('Failed to load videos');
    }
  }

  Future<List<VideoRankModel>> fetchRanksWeekly() async {
    try {
      // ✅ API 호출 (JSON 데이터 직접 받음)
      Response response = await dio.get('/api/ranking/weekly');

      // ✅ response.data가 이미 JSON 형태일 가능성이 높음 → json.decode 제거
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map(
                (item) => VideoRankModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print("Error fetching videos: $e");
      throw Exception('Failed to load videos');
    }
  }

  Map<String, dynamic> _buildQueryParams(
      int page, int size, Map<String, Set<String>> filters) {
    Map<String, dynamic> queryParams = {
      "page": page,
      "size": size,
    };

    filters.forEach((key, values) {
      if (values.isNotEmpty) {
        queryParams[key] = values.join(","); // "장르=액션,SF" 형식으로 변환
      }
    });

    return queryParams;
  }
}
