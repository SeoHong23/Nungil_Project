import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nungil/theme/common_theme.dart';

class RatingExample extends StatefulWidget {
  final Function(double) onRatingSelected;

  const RatingExample({Key? key, required this.onRatingSelected})
      : super(key: key);

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
          '별점: ${_rating.toStringAsFixed(1)}',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: DefaultColors.black,
          ),
        ),
        SizedBox(height: 12),
        RatingBar.builder(
          initialRating: _rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          glow: false, // 그림자 효과 제거
          itemSize: 40,
          unratedColor: iconThemeColorDark[300],
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
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
