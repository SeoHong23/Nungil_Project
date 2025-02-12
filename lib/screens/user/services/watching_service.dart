import 'package:dio/dio.dart';

class WatchingService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://13.239.238.92:8080"));

  Future<String> addWatching(Map<String, dynamic> data) async {
    try {
      Response response = await _dio.post(
        "/watching",
        data: data,
      );

      return response.data["message"];
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  Future<String> removeWatching(Map<String, dynamic> data) async {
    try {
      Response response = await _dio.delete(
        "/watching/remove",
        data: data,
      );
      return response.data["message"];
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  Future<bool> getWatchingStatus(Map<String, dynamic> data) async {
    try {
      Response response = await _dio.get(
        "/watching/${data['videoId']}/status",
        queryParameters: {
          'userId': data['userId'],
        },
      );
      print("getWatchingStatus Response: ${response.data}");
      return response.data["isWatching"] ?? false;
    } catch (e) {
      return false;
    }
  }
}
