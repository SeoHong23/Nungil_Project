import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nungil/providers/theme_provider.dart';
import 'package:nungil/screens/list/components/list_body_component.dart';
import 'package:nungil/screens/search/search_page.dart';

/*

2025-01-22 강중원 - 생성


 */

class ListPage extends ConsumerStatefulWidget {
  const ListPage({super.key});

  @override
  ConsumerState<ListPage> createState() => _ListPageState();
}

class _ListPageState extends ConsumerState<ListPage> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text("작품 탐색"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              themeNotifier.toggleTheme(); // ✅ 다크 모드 토글 기능 추가
            },
            icon: Icon(isDarkMode ? Icons.nightlight_round : Icons.wb_sunny),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(),
                ),
              );
            },
            icon: const Icon(FontAwesomeIcons.magnifyingGlass),
          ),
        ],
      ),
      body: const ListBodyComponent(),
    );
  }
}
