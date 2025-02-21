import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nungil/data/repository/video_repository.dart';
import 'package:nungil/models/detail/Video.dart';

class VideoGVM extends AutoDisposeFamilyNotifier<Video, String> {
  final VideoRepository videoRepository = const VideoRepository();

  @override
  Video build(id) {
    ref.onDispose(() {});
    init(id);
    return Video.fromNull();
  }

  Future<void> init(String id) async {
    final resData = await videoRepository.readData(id);
    state = Video.fromMap(resData);
  }
}

// 패밀리를 사용하여 ID 전달
final videoDetailProvider = AutoDisposeNotifierProvider
    .family<VideoGVM, Video, String>(VideoGVM.new);
