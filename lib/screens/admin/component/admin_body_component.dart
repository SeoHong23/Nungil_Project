import 'package:flutter/material.dart';
import 'package:nungil/screens/admin/component/admin_colum_component.dart';
import 'package:nungil/screens/admin/component/admin_banner_component.dart';

class AdminBodyComponent extends StatelessWidget {
  const AdminBodyComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "유저",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  AdminColumComponent(title: "유저관리"),
                  Divider(),
                  AdminColumComponent(title: "유저관리"),
                  Divider(),
                  AdminColumComponent(title: "유저관리"),
                ],
              ),
            ),
          ),
          Text(
            "시스템",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  AdminBannerComponent(title: "🚩  배너"),
                  Divider(),
                  AdminColumComponent(title: "🔔  푸쉬알림 관리"),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
