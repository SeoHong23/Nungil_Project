import 'package:flutter/material.dart';
import 'package:nungil/models/ott_icon_list.dart';

/// 2025-01-25 강중원 - 기존 위젯 컴포넌트화
///

class OttListComponent extends StatefulWidget {
  const OttListComponent({super.key});

  @override
  State<OttListComponent> createState() => _OttListComponentState();
}

class _OttListComponentState extends State<OttListComponent> {
  @override
  Widget build(BuildContext context) {
    final Set<int> _activeIndexes = {};
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          ottIconList.length,
          (index) {
            final isActive = _activeIndexes.contains(index);
            return GestureDetector(
              onTap: () {
                setState(() {
                  // 아이콘 활성화 상태를 토글
                  if (isActive) {
                    _activeIndexes.remove(index);
                  } else {
                    _activeIndexes.add(index);
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
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
