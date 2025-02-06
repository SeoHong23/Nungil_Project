import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nungil/data/gvm/video_list_GVM.dart';
import 'filter_type_component.dart';
import 'ott_list_component.dart';
import 'video_list_container_component.dart';

class ListBodyComponent extends ConsumerStatefulWidget {
  const ListBodyComponent({super.key});

  @override
  ConsumerState<ListBodyComponent> createState() => _ListBodyComponentState();
}

class _ListBodyComponentState extends ConsumerState<ListBodyComponent> {
  bool seenVideo = false;
  Map<String, Set<String>> selectedFilters = {};

  /// ✅ **필터 변경 시 비디오 데이터 다시 로드**
  void _onFilterChanged(Map<String, Set<String>> filters) {
    setState(() {
      selectedFilters = filters;
    });

    // ✅ 필터 적용 후 첫 페이지부터 다시 불러오기
    ref
        .read(videoNotifierProvider.notifier)
        .fetchMoreVideosWithFilter(filters, reset: true);
  }

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
                /// ✅ **필터 컴포넌트**
                FilterTypeComponent(
                  selectedFilters: selectedFilters,
                  onFilterChanged: _onFilterChanged,
                ),

                /// ✅ **'본 작품 포함' & 정렬 옵션**
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text("본 작품 포함"),
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
                    const Row(
                      children: [
                        Text("최신순"),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ],
                ),

                /// ✅ **비디오 리스트**
                VideoListContainerComponent(
                  selectedFilters: selectedFilters,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
