import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nungil/models/list/video_list_model.dart';

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
}
