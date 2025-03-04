import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nungil/data/repository/setting_repository.dart';
import 'package:nungil/theme/common_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSetting extends StatefulWidget {
  const UserSetting({required this.label, required this.context, super.key});

  final String label;
  final String context;

  @override
  State<UserSetting> createState() => _UserSettingState();
}

class _UserSettingState extends State<UserSetting> {
  bool _isAlert = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => getSetting());
  }

  Future<void> getSetting() async {
    final prefs = await SharedPreferences.getInstance();

    bool alertValue = await prefs.getBool('isAlert') ?? false;
    setState(() {
      _isAlert = alertValue;
    });
  }

  Future<void> setSetting(bool isAlert) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAlert', isAlert);
    setState(
      () {
        _isAlert = isAlert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 항목들을 양쪽 끝으로 배치
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.label,
                style: ColorTextStyle.largeNavy(context),
              ),
              Text(
                widget.context,
                style: ColorTextStyle.smallLightNavy(context),
              ),
            ],
          ),
          CupertinoSwitch(
            value: _isAlert,
            activeColor: CupertinoColors.activeBlue,
            onChanged: (bool? value) {
              setState(() {
                setSetting(value ?? false);
              });
            },
          ),
        ],
      ),
    );
  }
}
