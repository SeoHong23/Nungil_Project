import 'package:nungil/util/my_http.dart';

class VideoRepository {
  const VideoRepository();

  Future<Map<String, dynamic>> readData(String id) async {
    final response = await dio.get('/api/video?id=$id');

    if (response.statusCode == 200) {
      if (response.data is Map<String, dynamic>) {
        return response.data;
      } else {
        throw const FormatException("Invalid response format: expected a map.");
      }
    } else {
      throw Exception("Failed to fetch video data. Status code: ${response.statusCode}");
    }
  }
}


