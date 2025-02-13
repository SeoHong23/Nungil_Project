import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nungil/data/gvm/video_list_GVM.dart';
import 'package:nungil/data/repository/video_list_repository.dart';
import 'package:nungil/models/list/video_list_model.dart';
import 'package:nungil/screens/common_components/video_list_component.dart';

class SearchListContainerComponent extends ConsumerStatefulWidget {
  final String keyword;
  final String searchType;

  const SearchListContainerComponent({
    required this.keyword,
    required this.searchType,
    super.key,
  });

  @override
  ConsumerState<SearchListContainerComponent> createState() =>
      _VideoListContainerComponentState();
}

class _VideoListContainerComponentState
    extends ConsumerState<SearchListContainerComponent> {
  final ScrollController _scrollController = ScrollController();

  int _page = 0;
  List<VideoListModel> _searchResults = [];
  bool _isLoading = false;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Future.microtask(() {
      _performSearch(widget.keyword, reset: true);
    });
  }

  @override
  void didUpdateWidget(covariant SearchListContainerComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.keyword != widget.keyword ||
        oldWidget.searchType != widget.searchType) {
      // ✅ 검색어 또는 검색 타입이 변경되면 새로운 검색 수행
      _page = 0;
      _searchResults.clear(); // ✅ 기존 검색 결과 초기화
      _hasMoreData = true;
      _performSearch(widget.keyword, reset: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// ✅ **검색 API 호출**
  Future<void> _performSearch(String query, {bool reset = false}) async {
    if (_isLoading || !_hasMoreData) return; // ✅ 중복 호출 방지 & 더 불러올 데이터가 없으면 종료
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _hasMoreData = false;
      });
      return;
    }

    if (reset) {
      setState(() {
        _page = 0;
        _searchResults.clear(); // ✅ 기존 검색 결과 초기화
        _hasMoreData = true;
      });
    }

    setState(() => _isLoading = true);

    try {
      final repository = VideoListRepository();
      final results = await repository.searchVideos(
        _page,
        10, // ✅ 한 번에 불러올 데이터 개수
        query,
        widget.searchType,
      );

      setState(() {
        if (reset) {
          _searchResults = results;
        } else {
          _searchResults.addAll(results); // ✅ 기존 데이터에 추가
        }

        if (results.length < 10) {
          _hasMoreData = false; // ✅ 더 이상 가져올 데이터가 없으면 false 처리
        }
      });
    } catch (e) {
      print("검색 오류: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // 끝에 도달하면 추가 데이터 요청
      _page++;
      _performSearch(widget.keyword);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;
    if (screenWidth > 600) {
      crossAxisCount = 4;
    } else if (screenWidth > 450) {
      crossAxisCount = 3;
    }

    return Container(
      child: _isLoading && _searchResults.isEmpty // ✅ 처음 검색 중일 때 로딩 화면 표시
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _searchResults.isEmpty // ✅ 검색 결과가 없을 때 메시지 표시
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "검색 결과가 없습니다.",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  itemCount: _searchResults.length + 1, // ✅ 로딩 아이템 추가
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    mainAxisExtent: 310,
                  ),
                  itemBuilder: (context, index) {
                    if (index < _searchResults.length) {
                      final video = _searchResults[index];
                      return VideoListComponent(
                        id: video.id,
                        imgUrl: video.poster,
                        name: video.title,
                        rate: 80.0,
                      );
                    } else {
                      return _isLoading
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : SizedBox.shrink();
                    }
                  },
                ),
    );
  }
}
