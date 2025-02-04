import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../theme/common_theme.dart';

class RankitenComponent extends StatelessWidget {
  const RankitenComponent({required this.rankInten, super.key});
  final String rankInten;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container()),
        Builder(
          builder: (context) {
            if (rankInten == '0') {
              return Row(
                children: [
                  Text(
                    rankInten,
                    style: TextStyle(
                        color: DefaultColors.grey, fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    CupertinoIcons.minus,
                    size: 15,
                    color: DefaultColors.grey,
                  )
                ],
              );
            } else if (int.parse(rankInten) > 0) {
              return Row(
                children: [
                  Text(
                    '+${rankInten}',
                    style: TextStyle(
                        color: DefaultColors.green,
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    CupertinoIcons.arrowtriangle_up_fill,
                    size: 15,
                    color: DefaultColors.green,
                  )
                ],
              );
            } else {
              return Row(
                children: [
                  Text(
                    '${rankInten}',
                    style: TextStyle(
                        color: DefaultColors.red, fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    CupertinoIcons.arrowtriangle_down_fill,
                    size: 15,
                    color: DefaultColors.red,
                  )
                ],
              );
            }
          },
        ),
      ],
    );
  }
}
