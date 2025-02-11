import 'package:flutter/material.dart';

Widget CustomAnimatedSwitcher({required Widget child}){
  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 300), // 애니메이션 지속 시간 설정
    transitionBuilder: (Widget child, Animation<double> animation) {
      // FadeTransition이나 ScaleTransition 등 다양한 전환 효과 사용 가능
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    child: child
  );
}