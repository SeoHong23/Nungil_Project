import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nungil/models/ott_icon_list.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("작품 탐색"),
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
      body: Column(
        children: [
          // OTT 리스트
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                ottIconList.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 5.0), // 아이템 간 간격
                  child: Container(
                    width: 50, // 아이템 크기
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16), // 모서리 둥글게
                    ),
                    child: Center(
                      child: Image.asset(ottIconList[index].uri),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
          // 조건
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                12,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 5.0), // 아이템 간 간격
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5), // 모서리 둥글게
                    ),
                    child: Center(
                      child: Row(
                        children: [
                          Text(
                            '인증작품',
                            style: const TextStyle(fontSize: 15),
                          ),
                          Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
