import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'components/home_body_component.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.toggleTheme});

  final VoidCallback toggleTheme; // 🔥 임시 테마 변경 함수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("눈길"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              toggleTheme();
            },
            icon: const Icon(FontAwesomeIcons.share),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(FontAwesomeIcons.magnifyingGlass),
          ),
        ],
      ),
      body: const HomeBodyComponent(),
    );
  }
}
