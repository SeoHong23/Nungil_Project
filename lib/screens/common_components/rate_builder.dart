import 'package:flutter/material.dart';
import 'package:nungil/theme/common_theme.dart';

class RateBuilder extends StatelessWidget {
  const RateBuilder({required this.rate, super.key});
  final double rate;
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (rate > 70) {
          return Text(
            '$rate%',
            style: TextStyle(
              color: DefaultColors.green,
              fontWeight: FontWeight.bold,
            ),
          );
        } else if (rate > 40) {
          return Text(
            '$rate%',
            style: TextStyle(
              color: DefaultColors.yellow,
              fontWeight: FontWeight.bold,
            ),
          );
        } else {
          return Text(
            '$rate%',
            style: TextStyle(
              color: DefaultColors.red,
              fontWeight: FontWeight.bold,
            ),
          );
        }
      },
    );
  }
}
