import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:nungil/models/admin/banner_model.dart';
import '../../util/my_http.dart';

class BannerRepository {
  const BannerRepository();

  Future<bool> fetchBanner(File? image, String title, String type) async {
    try {
      FormData formData = FormData.fromMap({
        "title": title, // 배너 제목
        if (image != null) // 이미지가 있을 때만 포함
          "image": await MultipartFile.fromFile(image.path,
              filename: image.path.split('/').last),
        "type": type,
      });

      Response response = await dio.post(
        '/api/banner/insert',
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      if (response.statusCode == 200) {
        if (response.data is bool) {
          return response.data as bool;
        } else {
          throw Exception('Invalid response format: ${response.data}');
        }
      } else {
        throw Exception(
            'Failed to upload banner. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print(" Error uploading banner: $e");
      throw Exception('Failed to upload banner');
    }
  }

  Future<List<BannerModel>> fetchBannerList() async {
    try {
      Response response = await dio.get('/api/banner/list');

      //   response.data가 이미 JSON 형태일 가능성이 높음 → json.decode 제거
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((item) => BannerModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print("Error fetching videos: $e");
      throw Exception('Failed to load videos');
    }
  }

  Future<void> DeleteBanner(String id) async {
    try {
      Response response =
          await dio.delete('/api/banner/delete', queryParameters: {"id": id});

      //   response.data가 이미 JSON 형태일 가능성이 높음 → json.decode 제거
      if (response.statusCode == 200) {
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print("Error fetching videos: $e");
      throw Exception('Failed to load videos');
    }
  }

  Future<BannerModel> randomBanner(String type) async {
    try {
      Response response =
          await dio.get('/api/banner/random', queryParameters: {"type": type});

      if (response.statusCode == 200) {
        return BannerModel.fromJson(response.data);
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print("Error fetching videos: $e");
      throw Exception('Failed to load banner');
    }
  }
}
