import 'package:dio/dio.dart';

class NotInterestedService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://13.239.238.92:8080"));

  Future<String> addNotInterested(Map<String, dynamic> data) async {
    try {
      Response response = await _dio.post(
        "/notinterested",
        data: data,
      );

      return response.data["message"];
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  Future<String> removeNotInterested(Map<String, dynamic> data) async {
    try {
      Response response = await _dio.delete(
        "/notinterested/remove",
        data: data,
      );
      return response.data["message"];
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  Future<bool> getNotInterestedStatus(Map<String, dynamic> data) async {
    try {
      Response response = await _dio.get(
        "/notinterested/${data['videoId']}/status",
        queryParameters: {
          'userId': data['userId'],
        },
      );
      print("getNotInterestedStatus Response: ${response.data}");
      return response.data["checkNotInterested"] ?? false;
    } catch (e) {
      return false; // 에러 발생 시 기본적으로 false 반환
    }
  }

  Future<int> getNotInterestedCount(int userId) async {
    try {
      Response response = await _dio.get(
        "/notinterested/count",
        queryParameters: {"userId": userId},
      );

      return response.data["count"] ?? 0;
    } catch (e) {
      print("Error fetching notinterested count: ${e.toString()}");
      return 0;
    }
  }
}
