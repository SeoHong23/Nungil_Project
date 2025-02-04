import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String email;
  final String nickname;
  User({required this.email, required this.nickname});
}

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _userEmail;
  String? _nickname;
  User? _user; // User 객체를 저장할 변수

  bool get isLoggedIn => _isLoggedIn;
  User? get user => _user; // user getter 추가
  String? get userEmail => _userEmail;
  String? get nickname => _nickname;

  Future<void> login(String email, String nickname) async {
    _isLoggedIn = true;
    _userEmail = email;
    _nickname = nickname;
    _user = User(email: email, nickname: nickname);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userEmail', email);
    await prefs.setString('nickname', nickname);
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _user = null; // 로그아웃 시 user 정보 삭제
    _nickname = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // SharedPreferences 초기화
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final userEmail = prefs.getString('userEmail') ?? '';
    final nickname = prefs.getString('nickname') ?? '';
    if (_isLoggedIn) {
      _user = User(email: userEmail, nickname: nickname); // User 객체 복원
    }
    notifyListeners();
  }
}
