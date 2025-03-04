class SettingModel {
  final int userId;
  final int settingId;
  final String isAlert;

  SettingModel(
      {required this.userId, required this.settingId, required this.isAlert});

  //   JSON 변환 (서버 데이터 연동 시 필요)
  factory SettingModel.fromJson(Map<String, dynamic> json) {
    return SettingModel(
        userId: json['userId'],
        settingId: json['settingId'],
        isAlert: json['isAlert']);
  }

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'settingId': settingId, 'isAlert': isAlert};
  }
}
