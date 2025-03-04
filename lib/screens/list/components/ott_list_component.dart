import 'package:flutter/material.dart';
import 'package:nungil/models/movie_platform_list.dart';

/// 2025-01-25 강중원 - 기존 위젯 컴포넌트화
///

class OttListComponent extends StatefulWidget {
  final Map<String, Set<String>> selectedFilters;
  final Function(Map<String, Set<String>>) onFilterChanged;

  const OttListComponent({
    super.key,
    required this.selectedFilters,
    required this.onFilterChanged,
  });

  @override
  State<OttListComponent> createState() => _OttListComponentState();
}

class _OttListComponentState extends State<OttListComponent> {
  final Set<int> _activeIndexes = {};
  final String filterKey = "OTT"; // 필터 키

  ///   **OTT 필터 추가/제거 메서드**
  void _toggleOttFilter(int index) {
    final String ottName = ottIconList[index].name; // 아이콘에 해당하는 OTT 이름

    setState(() {
      if (_activeIndexes.contains(index)) {
        _activeIndexes.remove(index); // 선택 해제
        widget.selectedFilters[filterKey]?.remove(ottName); // 필터에서 제거
      } else {
        _activeIndexes.add(index); // 선택 추가
        widget.selectedFilters.putIfAbsent(filterKey, () => {}).add(ottName);
      }
    });

    //   변경된 필터 상태 전달
    widget.onFilterChanged(Map.from(widget.selectedFilters));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          ottIconList.length,
          (index) {
            final isActive = _activeIndexes.contains(index);
            return GestureDetector(
              onTap: () => _toggleOttFilter(index),
              child: Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Opacity(
                      opacity: isActive || _activeIndexes.isEmpty
                          ? 1.0
                          : 0.3, // 활성화 상태이면 1.0, 아니면 0.3
                      child: Image.asset(
                        ottIconList[index].uri,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
