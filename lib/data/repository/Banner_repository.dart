import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import '../../util/my_http.dart';

class BannerRepository {
  const BannerRepository();

  Future<bool> fetchBanner(File? image, String title) async {
    try {
      FormData formData = FormData.fromMap({
        "title": title, // 배너 제목
        if (image != null) // 이미지가 있을 때만 포함
          "image": await MultipartFile.fromFile(image.path,
              filename: image.path.split('/').last),
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
      print("❌ Error uploading banner: $e");
      throw Exception('Failed to upload banner');
    }
  }
}
