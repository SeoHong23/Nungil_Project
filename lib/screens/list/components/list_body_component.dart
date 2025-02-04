import 'package:flutter/material.dart';

import 'filter_type_component.dart';
import 'ott_list_component.dart';
import 'video_list_container_component.dart';

class ListBodyComponent extends StatefulWidget {
  const ListBodyComponent({super.key});

  @override
  State<ListBodyComponent> createState() => _ListBodyComponentState();
}

class _ListBodyComponentState extends State<ListBodyComponent> {
  bool seenVideo = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // OTT 리스트
        OttListComponent(),
        const SizedBox(height: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FilterTypeComponent(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text("본 작품 포함"),
                        Checkbox(
                          value: seenVideo,
                          onChanged: (bool? value) {
                            setState(() {
                              seenVideo = value ?? false;
                            });
                          },
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text("인기순"),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ],
                ),
                VideoListContainerComponent(),
              ],
            ),
          ),
        ),
        // 조건
      ],
    );
  }
}
