import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBox extends StatelessWidget {
  final double height;
  final double width;
  final double radius;

  const ShimmerBox({super.key, required this.height, required this.width, this.radius = 4.0});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[400]!,
      highlightColor: Colors.grey[300]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

class ShimmerTextPlaceholder extends StatelessWidget {
  final int lineCount; // 몇 줄을 만들지 결정
  final double lineHeight; // 각 줄의 높이
  final double spacing; // 줄 간 간격
  final double maxWidth; // 가장 긴 줄의 너비 (가변 길이 적용)

  const ShimmerTextPlaceholder({
    super.key,
    this.lineCount = 5,
    this.lineHeight = 14.0,
    this.spacing = 8.0,
    this.maxWidth = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[400]!,
      highlightColor: Colors.grey[300]!,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // 부모 위젯의 너비를 구함
          double parentWidth = constraints.maxWidth;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(lineCount, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: spacing),
                child: Container(
                  // maxWidth를 부모 위젯의 너비로 설정
                  width: index == lineCount - 1
                      ? parentWidth * 0.6 // 마지막 줄은 화면 크기 기준으로 30%로 설정
                      : maxWidth,
                  height: lineHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
