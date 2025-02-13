import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nungil/data/repository/video_list_repository.dart';
import 'package:nungil/models/list/video_list_model.dart';
import 'package:nungil/screens/list/components/video_list_component.dart';
import 'package:nungil/util/logger.dart';

class SearchBody extends StatefulWidget {
  final String? keyword;
  const SearchBody({this.keyword, super.key});

  @override
  State<SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
  final TextEditingController _searchController = TextEditingController();
  int _page = 0;
  List<VideoListModel> _searchResults = [];
  bool _isLoading = false;
  String searchType = 'title';

  @override
  void initState() {
    if (widget.keyword != null && widget.keyword!.isNotEmpty) {
      _searchController.text = widget.keyword!;
      _performSearch(widget.keyword!);
    }
    super.initState();
  }

  /// ✅ **검색 API 호출**
  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repository = VideoListRepository();
      final results = await repository.searchVideos(
          _page, 10, query, searchType); // 🔥 검색 API 호출
      setState(() => _searchResults = results);
    } catch (e) {
      print("검색 오류: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _typeChange(String type) {
    setState(() {
      searchType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: const Text("검색: "),
            ),
            DropdownButton<String>(
              value: searchType,
              items: const [
                DropdownMenuItem(
                  value: "title",
                  child: Text("제목"),
                ),
                DropdownMenuItem(
                  value: "genre",
                  child: Text("장르"),
                ),
              ],
              onChanged: (value) => _typeChange(value!), // ✅ 검색 변경 시 실행
            ),
          ],
        ),
        // 검색창
        TextField(
          controller: _searchController,
          onSubmitted: (query) => _performSearch(query),
          decoration: InputDecoration(
            prefixIcon: Icon(FontAwesomeIcons.magnifyingGlass,
                color: Theme.of(context).iconTheme.color),
            fillColor: Theme.of(context).cardColor, // 채우기 색
            filled: true, // 채우기 유무 default = false
          ),
        ),
// ✅ **검색 결과 출력**
        Expanded(
          child: _isLoading
              ? Center(child: CircularProgressIndicator()) // 로딩 표시
              : _searchResults.isEmpty
                  ? Center(child: Text("검색 결과가 없습니다."))
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final video = _searchResults[index];
                        return VideoListComponent(
                          id: video.id,
                          imgUrl: video.poster ?? '',
                          name: video.title ?? '제목 없음',
                          rate: 80.0, // 평점 (임시)
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
