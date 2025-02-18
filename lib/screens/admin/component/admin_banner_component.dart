import 'package:flutter/material.dart';
import 'package:nungil/screens/admin/banner/banner_insert.dart';

class AdminBannerComponent extends StatelessWidget {
  final String title;

  const AdminBannerComponent({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title, style: Theme.of(context).textTheme.displayLarge),
      trailing: Icon(Icons.arrow_drop_down), // 화살표 아이콘 변경
      children: [
        ListTile(
          title: Text(
            "배너 추가",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BannerInsert(),
              ),
            );
          },
        ),
        ListTile(
          title: Text(
            "배너 관리",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          onTap: () {
            // 상세 메뉴 클릭 시 동작
          },
        ),
      ],
    );
  }
}
