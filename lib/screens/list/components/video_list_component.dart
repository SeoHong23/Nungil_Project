import 'package:flutter/material.dart';
import 'package:nungil/theme/common_theme.dart';

class VideoListComponent extends StatelessWidget {
  final String imgUrl;
  final String name;
  final double rate;

  const VideoListComponent(
      {super.key,
      required this.imgUrl,
      required this.name,
      required this.rate});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: baseBackgroundColor[600],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity, // 부모 위젯의 너비를 명시적으로 설정
            height: 250, // 고정된 높이
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), // 둥근 모서리
            ),
            clipBehavior: Clip.hardEdge, // 둥근 모서리를 Clip 효과로 적용
            child: Image.asset(
              imgUrl,
              fit: BoxFit.cover, // 비율에 맞게 채움
            ),
          ),
          SizedBox(height: 5),
          Text(name),
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${rate}%"),
                  InkWell(
                    onTap: () {
                      // 버튼 클릭 시 실행될 동작
                    },
                    child: Icon(
                      Icons.add_circle_outline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
