import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nungil/providers/theme_provider.dart';
import 'package:nungil/screens/search/search_page.dart';

import 'components/ranking_body_component.dart';

class RankingPage extends ConsumerStatefulWidget {
  const RankingPage({super.key});

  @override
  ConsumerState<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends ConsumerState<RankingPage> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('박스오피스 랭킹'),
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
      body: RankingBodyComponent(),
    );
  }
}
