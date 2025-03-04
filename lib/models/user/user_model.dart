class UserModel {
  final int userId;
  final String nickname;
  final String email;
  final String? kakaoId;

  UserModel(
      {required this.userId,
      required this.nickname,
      required this.email,
      this.kakaoId});

  //   JSON 변환 (서버 데이터 연동 시 필요)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        userId: json['userId'],
        nickname: json['nickname'],
        email: json['email'],
        kakaoId: json['kakaoId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'nickname': nickname,
      'email': email,
      'kakaoId': kakaoId
    };
  }
}
