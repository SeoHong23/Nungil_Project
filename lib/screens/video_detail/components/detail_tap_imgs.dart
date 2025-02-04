import 'package:flutter/material.dart';
import 'package:nungil/models/Video.dart';

class DetailTapImgs extends StatelessWidget {
  final Video item;
  const DetailTapImgs({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          height: 2000,
          width: double.infinity,
          color: Colors.grey,
        ),
      ],
    );
  }
}
