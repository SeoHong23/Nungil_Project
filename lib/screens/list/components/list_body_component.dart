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

  String sortOrder = "DateDESC"; // ✅ 기본 정렬: 최신순

  /// ✅ **필터 변경 시 비디오 데이터 다시 로드**
  void _onFilterChanged(Map<String, Set<String>> filters) {
    setState(() {
      selectedFilters = filters;
    });

    // ✅ 필터 적용 후 첫 페이지부터 다시 불러오기
    ref
        .read(videoNotifierProvider.notifier)
        .fetchMoreVideosWithFilter(filters, sortOrder, reset: true);
  }

  /// ✅ **정렬 변경 핸들러**
  void _onSortChanged(String? newValue) {
    if (newValue != null) {
      setState(
        () {
          sortOrder = newValue;
        },
      );

      // ✅ 정렬 옵션 변경 후 다시 비디오 목록 로드
      ref.read(videoNotifierProvider.notifier).fetchMoreVideosWithFilter(
            selectedFilters,
            sortOrder,
            reset: true,
          );
    }
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

                    /// ✅ **정렬 Dropdown 버튼**
                    Row(
                      children: [
                        const Text("정렬: "),
                        DropdownButton<String>(
                          value: sortOrder,
                          items: const [
                            DropdownMenuItem(
                              value: "DateDESC",
                              child: Text("최신순"),
                            ),
                            DropdownMenuItem(
                              value: "DateASC",
                              child: Text("오래된순"),
                            ),
                          ],
                          onChanged: _onSortChanged, // ✅ 정렬 변경 시 실행
                        ),
                      ],
                    ),
                  ],
                ),

                /// ✅ **비디오 리스트**
                VideoListContainerComponent(
                  selectedFilters: selectedFilters,
                  sortOrder: sortOrder, // ✅ 정렬 옵션 전달
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
