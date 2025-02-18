import 'package:flutter/material.dart';

import '../../../theme/common_theme.dart';

class HomeReviewComponent extends StatelessWidget {
  final String mName;
  final String contents;
  final String uName;

  const HomeReviewComponent(
      {required this.mName,
      required this.contents,
      required this.uName,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor,
        ),
        width: 200,
        height: 125,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mName,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 3),
            Expanded(child: Text(contents, style: CustomTextStyle.pretendard,)),
            Text(uName, style: CustomTextStyle.pretendard,),
          ],
        ),
      ),
    );
  }
}
