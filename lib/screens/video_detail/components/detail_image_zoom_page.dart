import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:nungil/screens/video_detail/components/skeleton.dart';
import 'package:nungil/util/my_http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:preload_page_view/preload_page_view.dart' as preload_page;

class DetailImageZoomPage extends StatefulWidget {
  final List<dynamic> imgList;
  final int index;

  const DetailImageZoomPage({
    required this.imgList,
    required this.index,
    super.key,
  });

  @override
  State<DetailImageZoomPage> createState() => _DetailImageZoomPageState();
}

class _DetailImageZoomPageState extends State<DetailImageZoomPage> {
  int _currentIndex = 0;
  bool _isDownloading = false;
  String progressingString = "";
  String file = "";

  Future<void> downloadImage(String imageUrl) async {
    String downloadDirPath = (await getApplicationDocumentsDirectory())!.path;

    if (Platform.isAndroid) {
      downloadDirPath = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
      Directory dir = Directory(downloadDirPath);

      if (!dir.existsSync()) {
        downloadDirPath = (await getExternalStorageDirectory())!.path;
      }
    }
    try {
      // URL에서 파일 이름 추출
      String fileName = Uri.parse(imageUrl).pathSegments.last;
      String extension = '.jpg'; // 기본 확장자
        Response response = await dio.head(imageUrl);
        String? contentType = response.headers.value('content-type');

        if (contentType != null) {
          if (contentType.contains('image/jpeg')) {
            extension = '.jpg';
          } else if (contentType.contains('image/png')) {
            extension = '.png';
          } else if (contentType.contains('image/gif')) {
            extension = '.gif';
          }
        }

        fileName += extension;

      final filePath = '$downloadDirPath/$fileName';

      await dio.download(imageUrl, filePath, onReceiveProgress: (rec, total) {
        setState(() {
          _isDownloading = true;
          progressingString = '${((rec / total) * 100).toStringAsFixed(0)}%';
          file = filePath;
        });
      });
      progressingString = '성공적으로 저장되었습니다.';
      print(filePath);
    } catch (e) {
      print('Error: $e');
    }

    setState(() {
      _isDownloading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.transparent,
          actions: [
            _isDownloading?
                CircularProgressIndicator()
                :
            IconButton(
              onPressed: () {
                if(!_isDownloading){
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(
                    content: Text(progressingString,textAlign: TextAlign.center,),backgroundColor: Colors.black26,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                    duration: const Duration(milliseconds: 500),
                  ));
                  downloadImage(widget.imgList[_currentIndex]);
                }
              },
              icon: const Icon(
                Icons.download_rounded,
                color: Colors.white,
              ),
            )
          ],
        ),
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            preload_page.PreloadPageView.builder(
              controller:
                  preload_page.PreloadPageController(initialPage: widget.index),
              itemCount: widget.imgList.length,
              preloadPagesCount: 5,
              onPageChanged: (int position) {
                setState(() {
                  _currentIndex = position;
                });
              },
              itemBuilder: (BuildContext context, int position) {
                return Center(
                  child: PhotoView(
                    imageProvider: NetworkImage(widget.imgList[position]),

                  ),
                );
              },
            ),
            Positioned(
              bottom: 20,
              right: 0,
              left: 0,
              child: Text(
                '${_currentIndex + 1} / ${widget.imgList.length}',
                style: const TextStyle(color: Colors.white60),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailImage extends StatelessWidget {
  final List<dynamic> imgList;
  final dynamic index;
  final double width;
  final double height;
  final double radius;

  const DetailImage({
    required this.imgList,
    required this.index,
    required this.width,
    required this.height,
    this.radius = 5.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailImageZoomPage(
              imgList: imgList,
              index: index as int,
            ),
          ),
        );
      },
      child: SizedBox(
        height: height,
        width: width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: CachedNetworkImage(
            imageUrl: imgList[index],
            height: height, // 포스터 크기 고정
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                ShimmerBox(height: height, width: width),
          ),
        ),
      ),
    );
  }
}
