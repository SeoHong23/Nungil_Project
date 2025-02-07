import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
          '별점: $_rating',
          style: TextStyle(fontSize: 22),
        ),
        SizedBox(height: 10),
        RatingBar.builder(
          initialRating: _rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 40,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
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
