import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nungil/data/repository/video_list_repository.dart';
import 'package:nungil/models/list/video_list_model.dart';
import 'package:nungil/screens/common_components/video_list_component.dart';
import 'package:nungil/screens/search/components/search_list_container_component.dart';
import 'package:nungil/util/logger.dart';

class SearchBody extends StatefulWidget {
  final String? keyword;
  const SearchBody({this.keyword, super.key});

  @override
  State<SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
  String keyword = "";
  final TextEditingController _searchController = TextEditingController();
  String searchType = 'title';

  @override
  void initState() {
    super.initState();
    if (widget.keyword != null && widget.keyword!.isNotEmpty) {
      keyword = widget.keyword!;
      _searchController.text = widget.keyword!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchKey(String query) {
    if (query.isNotEmpty) {
      setState(() {
        keyword = query;
      });
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
              onChanged: (value) => _typeChange(value!), // ✅ 검색 타입 변경
            ),
          ],
        ),
        // 검색창 및 버튼 추가
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onSubmitted: (query) => _searchKey(query),
                  decoration: InputDecoration(
                    prefixIcon: Icon(FontAwesomeIcons.magnifyingGlass,
                        color: Theme.of(context).iconTheme.color),
                    fillColor: Theme.of(context).cardColor,
                    filled: true,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(FontAwesomeIcons.arrowRight,
                    color: Theme.of(context).iconTheme.color),
                onPressed: () =>
                    _searchKey(_searchController.text), // ✅ 검색 버튼 클릭 시 검색 실행
              ),
            ],
          ),
        ),
        // ✅ **Expanded 제거하여 오류 해결**
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchListContainerComponent(
              keyword: keyword,
              searchType: searchType,
            ),
          ),
        ),
      ],
    );
  }
}
