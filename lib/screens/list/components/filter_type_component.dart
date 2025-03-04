import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nungil/theme/common_theme.dart';
import '../../../models/list/list_filter_type.dart';

class FilterTypeComponent extends StatefulWidget {
  final Map<String, Set<String>> selectedFilters;
  final Function(Map<String, Set<String>>) onFilterChanged;
  final Function(bool isOpen) onOpenChanged;
  final bool isNotOpen;
  final String sortOrder;
  final Function(String? newValue) onSortChanged;

  const FilterTypeComponent({
    super.key,
    required this.isNotOpen,
    required this.onOpenChanged,
    required this.selectedFilters,
    required this.onFilterChanged,
    required this.sortOrder,
    required this.onSortChanged,
  });

  @override
  State<FilterTypeComponent> createState() => _FilterTypeComponentState();
}

class _FilterTypeComponentState extends State<FilterTypeComponent> {
  /// ✅ **필터 선택 다이얼로그**
  void _showFilterDialog(String filterType) {
    List<String> options = FilterRepository.getOptionsByCategory(filterType);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor, // ✅ 바텀시트 배경색 지정
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.7,
            maxChildSize: 0.7,
            expand: false, // ✅ 바텀시트가 전체 화면을 덮지 않도록 설정
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.all(16),
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$filterType 선택",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          String option = options[index];
                          bool isSelected = widget.selectedFilters[filterType]
                                  ?.contains(option) ??
                              false;
                          return ListTile(
                            title: Text(
                              option,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            trailing: isSelected
                                ? Icon(Icons.check_box, color: Colors.green)
                                : Icon(Icons.check_box_outline_blank),
                            onTap: () {
                              _toggleFilter(filterType, option);
                              Navigator.pop(context); // 다이얼로그 닫기
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// ✅ **필터 추가/삭제 함수**
  void _toggleFilter(String category, String option) {
    final newFilters = Map<String, Set<String>>.from(widget.selectedFilters);

    if (!newFilters.containsKey(category)) {
      newFilters[category] = {};
    }

    if (newFilters[category]!.contains(option)) {
      newFilters[category]!.remove(option);
      if (newFilters[category]!.isEmpty) {
        newFilters.remove(category);
      }
    } else {
      newFilters[category]!.add(option);
    }

    widget.onFilterChanged(newFilters); // ✅ 필터 변경 이벤트 호출
  }

  void _toggleOpen(bool isNotOpen) {
    widget.onOpenChanged(isNotOpen); // ✅ 필터 변경 이벤트 호출
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ✅ **필터 버튼 (클릭 시 다이얼로그 열림)**
        Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: FilterRepository.filters.map((filterData) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          _showFilterDialog(filterData.category);
                        },
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: iconThemeColor[800],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              Text(
                                filterData.category,
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                              Icon(Icons.keyboard_arrow_down,
                                  color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text("미개봉"),
            CupertinoSwitch(
              value: widget.isNotOpen,
              activeColor: CupertinoColors.activeBlue,
              onChanged: (bool? value) {
                setState(() {
                  _toggleOpen(value ?? false);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 5),

        /// ✅ **선택된 필터 리스트**
        Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.selectedFilters.entries
                      .where((entry) => entry.key != "OTT") // ✅ OTT 제외
                      .expand(
                    (entry) {
                      String category = entry.key;
                      return entry.value.map(
                        (filter) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: iconThemeColor[300],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  Text("$category: $filter",
                                      style: TextStyle(color: Colors.white)),
                                  GestureDetector(
                                    onTap: () {
                                      _toggleFilter(category, filter);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Icon(Icons.cancel_outlined,
                                          size: 18, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
            SizedBox(width: 8),
            Row(
              children: [
                const Text("정렬: "),
                DropdownButton<String>(
                  value: widget.sortOrder,
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
                  onChanged: widget.onSortChanged, // ✅ 정렬 변경 시 실행
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
