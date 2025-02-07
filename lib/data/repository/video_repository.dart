
import 'package:dio/dio.dart';
import 'package:nungil/util/my_http.dart';

class VideoRepository{

  const VideoRepository();

  Future<Map<String,dynamic>> readData(String id) async {
      Response response = await dio.get('/api/video?id=$id');
      Map<String,dynamic> responseBody = response.data;
    return responseBody;
  }


}