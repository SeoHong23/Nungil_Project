import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'components/ranking_body_component.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('박스오피스 랭킹'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(FontAwesomeIcons.share),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(FontAwesomeIcons.magnifyingGlass),
          ),
        ],
      ),
      body: RankingBodyComponent(),
    );
  }
}
