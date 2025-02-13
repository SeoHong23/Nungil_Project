import 'package:flutter/material.dart';
import 'package:nungil/screens/search/components/search_body.dart';

class SearchPage extends StatelessWidget {
  final String? keyword;
  const SearchPage({this.keyword, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("검색"),
      ),
      body: SearchBody(
        keyword: keyword,
      ),
    );
  }
}
