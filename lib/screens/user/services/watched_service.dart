import 'package:dio/dio.dart';

class WatchedService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://13.239.238.92:8080"));

  Future<String> addWatched(Map<String, dynamic> data) async {
    try {
      Response response = await _dio.post(
        "/watched",
        data: data,
      );

      return response.data["message"];
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  Future<String> removeWatched(Map<String, dynamic> data) async {
    try {
      Response response = await _dio.delete(
        "/watched/remove",
        data: data,
      );
      return response.data["message"];
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  Future<bool> getWatchedStatus(Map<String, dynamic> data) async {
    try {
      Response response = await _dio.get(
        "/watched/${data['videoId']}/status",
        queryParameters: {
          'userId': data['userId'],
        },
      );
      print("getWatchingStatus Response: ${response.data}");
      return response.data["isWatched"] ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<int> getWatchedCount(int userId) async {
    try {
      Response response = await _dio.get(
        "/watched/count",
        queryParameters: {"userId": userId},
      );

      return response.data["count"] ?? 0;
    } catch (e) {
      print("Error fetching watched count: ${e.toString()}");
      return 0;
    }
  }
}
