import 'package:dio/dio.dart';

class FavoriteService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://13.239.238.92:8080"));

  Future<int> getFavoriteCount(int userId) async {
    try {
      Response response = await _dio.get(
        "/favorite/count",
        queryParameters: {"userId": userId},
      );

      return response.data["count"] ?? 0;
    } catch (e) {
      print("Error fetching favorite count: ${e.toString()}");
      return 0;
    }
  }
}
