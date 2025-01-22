import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nungil/models/list/list_filter_type.dart';
import 'package:nungil/models/ott_icon_list.dart';
import 'package:nungil/theme/common_theme.dart';

import 'components/video_list_component.dart';

/*

2025-01-22 강중원 - 생성


 */

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    // 화면의 가로 크기 가져오기
    final screenWidth = MediaQuery.of(context).size.width;

    // 가로 크기에 따른 열 개수 계산
    int crossAxisCount = 2; // 기본 2열
    if (screenWidth > 800) {
      crossAxisCount = 4; // 가로 800px 이상일 경우 4열
    } else if (screenWidth > 500) {
      crossAxisCount = 3; // 가로 500px 이상일 경우 3열
    }

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
                listFilterType.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 8.0), // 아이템 간 간격
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: baseBackgroundColor[400],
                      borderRadius: BorderRadius.circular(5), // 모서리 둥글게
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${listFilterType[index].name}',
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
          const SizedBox(height: 5),
          SingleChildScrollView(
            // 선택된 필터
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: List.generate(
                  12,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 5.0), // 아이템 간 간격
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Center(
                        child: Row(
                          children: [
                            Text(
                              'SF',
                              style: const TextStyle(fontSize: 15),
                            ),
                            Icon(Icons.cancel_outlined),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: false,
                      onChanged: (value) {},
                    ),
                    Text("본 작품 포함"),
                  ],
                ),
                Text("인기순"),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: 20,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                mainAxisExtent: 310,
              ),
              itemBuilder: (context, index) {
                return VideoListComponent(
                  imgUrl: 'assets/images/tmp/mickey17.webp',
                  name: '미키 17',
                  rate: 100.0,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
