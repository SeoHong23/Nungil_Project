import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nungil/data/repository/video_list_repository.dart';
import 'package:nungil/models/list/video_list_model.dart';

class VideoNotifier extends Notifier<List<VideoListModel>> {
  final VideoListRepository _videoService = VideoListRepository();
  int _page = 0;
  final int _size = 10;
  bool _hasMore = true;
  bool _isLoading = false;
  Map<String, Set<String>> _selectedFilters = {}; // ✅ 현재 선택된 필터

  bool get hasMore => _hasMore;
  bool get isLoading => _isLoading;

  @override
  List<VideoListModel> build() => [];

  Future<void> fetchMoreVideos() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    state = [...state]; // UI 업데이트

    try {
      List<VideoListModel> newVideos =
          await _videoService.fetchVideos(_page, _size);
      state = [...state, ...newVideos];
      _page++;
      _hasMore = newVideos.length == _size; // 더 이상 데이터 없으면 false 설정
    } catch (e) {
      print("Error fetching videos: $e");
    } finally {
      _isLoading = false;
    }
  }

  Future<void> fetchMoreVideosWithFilter(Map<String, Set<String>> filters,
      {bool reset = false}) async {
    if (_isLoading || (!_hasMore && !reset)) return;

    _isLoading = true;
    state = [...state];

    try {
      if (reset) {
        _page = 0;
        _hasMore = true;
        state = [];
      }

      _selectedFilters = filters;
      List<VideoListModel> newVideos =
          await _videoService.fetchVideosWithFilter(
        _page,
        _size,
        _selectedFilters,
      );

      state = [...state, ...newVideos];
      _page++;
      _hasMore = newVideos.length == _size;
    } catch (e) {
      print("Error fetching videos: $e");
    } finally {
      _isLoading = false;
    }
  }
}

// **Provider 등록**
final videoNotifierProvider =
    NotifierProvider<VideoNotifier, List<VideoListModel>>(
        () => VideoNotifier());
