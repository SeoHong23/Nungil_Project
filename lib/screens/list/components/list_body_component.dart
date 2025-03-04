import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nungil/data/gvm/video_list_GVM.dart';
import 'package:nungil/util/logger.dart';
import 'filter_type_component.dart';
import 'ott_list_component.dart';
import 'video_list_container_component.dart';

class ListBodyComponent extends ConsumerStatefulWidget {
  const ListBodyComponent({super.key});

  @override
  ConsumerState<ListBodyComponent> createState() => _ListBodyComponentState();
}

class _ListBodyComponentState extends ConsumerState<ListBodyComponent> {
  Map<String, Set<String>> selectedFilters = {};
  bool _isNotOpen = false;
  String sortOrder = "DateDESC"; //   기본 정렬: 최신순

  ///   **필터 변경 시 비디오 데이터 다시 로드**
  void _onFilterChanged(Map<String, Set<String>> filters) {
    setState(() {
      selectedFilters = filters;
    });

    //   필터 적용 후 첫 페이지부터 다시 불러오기
    ref.read(videoNotifierProvider.notifier).fetchMoreVideosWithFilter(
        filters, sortOrder,
        isNotOpen: _isNotOpen, reset: true);
  }

  void _onOpenChanged(bool isNotOpen) {
    setState(() {
      _isNotOpen = isNotOpen;
    });

    //   필터 적용 후 첫 페이지부터 다시 불러오기
    ref.read(videoNotifierProvider.notifier).fetchMoreVideosWithFilter(
        selectedFilters, sortOrder,
        isNotOpen: isNotOpen, reset: true);
  }

  ///   **정렬 변경 핸들러**
  void onSortChanged(String? newValue) {
    if (newValue != null) {
      setState(
        () {
          sortOrder = newValue;
        },
      );

      //   정렬 옵션 변경 후 다시 비디오 목록 로드
      ref.read(videoNotifierProvider.notifier).fetchMoreVideosWithFilter(
            selectedFilters,
            sortOrder,
            isNotOpen: _isNotOpen,
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
        OttListComponent(
          selectedFilters: selectedFilters,
          onFilterChanged: _onFilterChanged,
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///   **필터 컴포넌트**
                FilterTypeComponent(
                  selectedFilters: selectedFilters,
                  onFilterChanged: _onFilterChanged,
                  isNotOpen: _isNotOpen,
                  onOpenChanged: _onOpenChanged,
                  sortOrder: sortOrder,
                  onSortChanged: onSortChanged,
                ),

                ///   **비디오 리스트**
                VideoListContainerComponent(
                  selectedFilters: selectedFilters,
                  sortOrder: sortOrder, //   정렬 옵션 전달
                  isNotOpen: _isNotOpen,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
