import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nungil/theme/common_theme.dart';

class RatingExample extends StatefulWidget {
  final Function(double) onRatingSelected;

  const RatingExample({super.key, required this.onRatingSelected});

  @override
  _RatingExampleState createState() => _RatingExampleState();
}

class _RatingExampleState extends State<RatingExample> {
  double _rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '평점 ${_rating.toStringAsFixed(1)}점',
          style: ColorTextStyle.largeNavy(context),
        ),
        const SizedBox(height: 12),
        RatingBar.builder(
          initialRating: _rating,
          minRating: 0.5,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          glow: false,
          // 그림자 효과 제거
          itemSize: 30,
          unratedColor: iconThemeColorDark[300],
          itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
          itemBuilder: (context, _) => const Icon(
            CupertinoIcons.star_fill,
            color: Colors.orangeAccent,
          ),
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
            widget.onRatingSelected(rating);
          },
        ),
      ],
    );
  }
}
