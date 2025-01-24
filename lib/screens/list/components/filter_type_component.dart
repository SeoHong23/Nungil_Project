import 'package:flutter/material.dart';

import '../../../models/list/list_filter_type.dart';
import '../../../theme/common_theme.dart';

/// 2025-01-25 강중원 - 기존 위젯 컴포넌트화

class FilterTypeComponent extends StatelessWidget {
  const FilterTypeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          child: Row(
            children: List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  child: Center(
                    child: Row(
                      children: [
                        Text(
                          'SF',
                          style: textTheme().bodySmall,
                        ),
                        Icon(
                          Icons.cancel_outlined,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
