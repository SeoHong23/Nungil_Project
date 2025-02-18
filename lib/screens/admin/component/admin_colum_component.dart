import 'package:flutter/material.dart';

class AdminColumComponent extends StatelessWidget {
  final String title;

  const AdminColumComponent({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Icon(Icons.arrow_right)
          ],
        ),
      ),
    );
  }
}
