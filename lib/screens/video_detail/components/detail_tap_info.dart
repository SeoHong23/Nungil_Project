import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nungil/models/Video.dart';
import 'package:nungil/theme/common_theme.dart';

class DetailTapInfo extends StatefulWidget {
  final Video item;

  const DetailTapInfo({required this.item, super.key});

  @override
  State<DetailTapInfo> createState() => _DetailTapInfoState();
}

class _DetailTapInfoState extends State<DetailTapInfo> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          color: baseBackgroundColor,
          child: RichText(
            text: isExpanded
                ? TextSpan(
                    children: [
                      TextSpan(
                        text: widget.item.plots[0].plotText,
                        style: TextStyle(color: iconThemeColor.shade800),
                      ),
                      TextSpan(
                          text: '  접기',
                          style: const TextStyle(color: iconThemeColor),
                          recognizer: TapGestureRecognizer()..onTap = () {
                              setState(() {isExpanded = !isExpanded;});
                            })
                    ],
                  )
                : TextSpan(
                    children: [
                      TextSpan(
                        text: '${widget.item.plots[0].plotText.substring(0, 100)}... ',
                        style: TextStyle(color: iconThemeColor.shade800),
                      ),
                      TextSpan(
                          text: '더보기',
                          style: const TextStyle(color: iconThemeColor),
                          recognizer: TapGestureRecognizer()..onTap = () {
                              setState(() {isExpanded = !isExpanded;});
                            })
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 20,),
        Container(
          height: 1,
          decoration: BoxDecoration(color: iconThemeColor.shade700.withOpacity(0.3))
        ),

      ],
    );
  }
}
