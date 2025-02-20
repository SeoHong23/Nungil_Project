class UserModel {
  final int userId;
  final String nickname;
  final String email;

  UserModel(
      {required this.userId, required this.nickname, required this.email});

  // ✅ JSON 변환 (서버 데이터 연동 시 필요)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      nickname: json['nickname'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'nickname': nickname,
      'email': email,
    };
  }
}
