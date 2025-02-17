import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nungil/providers/theme_provider.dart';
import 'package:nungil/screens/search/search_page.dart';

import 'components/home_body_component.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text("눈길"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              themeNotifier.toggleTheme();
            },
            icon: Icon(isDarkMode ? Icons.nightlight_round : Icons.wb_sunny),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ),
              );
            },
            icon: const Icon(FontAwesomeIcons.magnifyingGlass),
          ),
        ],
      ),
      body: const HomeBodyComponent(),
    );
  }
}
