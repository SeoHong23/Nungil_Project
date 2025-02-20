import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nungil/theme/common_theme.dart';
import '../../main_screen.dart';
import 'login_view.dart';
import 'package:nungil/providers/auth_provider.dart';

class EmailLogin extends ConsumerStatefulWidget {
  const EmailLogin({super.key});

  @override
  ConsumerState<EmailLogin> createState() => _EmailLoginState();
}

class _EmailLoginState extends ConsumerState<EmailLogin> {
  bool emailHasError = false;
  bool passwordHasError = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  String emailErrorMessage = '';
  String passwordErrorMessage = '';
  bool isButtonEnabled = false;

  bool isValidEmail(String email) {
    final RegExp regex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  void validateEmail() {
    final email = emailController.text;
    if (email.isEmpty) {
      setState(() {
        emailHasError = true;
        emailErrorMessage = '이메일을 입력해주세요.';
      });
    } else if (!isValidEmail(email)) {
      setState(() {
        emailHasError = true;
        emailErrorMessage = '올바른 이메일 형식이 아닙니다.';
      });
    } else {
      setState(() {
        emailHasError = false;
        emailErrorMessage = '';
      });
    }
    updateButtonState();
  }

  void validatePassword() {
    final password = passwordController.text;
    if (password.isEmpty) {
      setState(() {
        passwordHasError = true;
        passwordErrorMessage = '비밀번호를 입력해주세요.';
      });
    } else if (password.length < 8) {
      setState(() {
        passwordHasError = true;
        passwordErrorMessage = '비밀번호는 8자 이상이어야 합니다.';
      });
    } else {
      setState(() {
        passwordHasError = false;
        passwordErrorMessage = '';
      });
    }
    updateButtonState();
  }

  void clearEmailField() {
    setState(() {
      emailController.clear();
      emailHasError = false;
    });
  }

  void clearPasswordField() {
    setState(() {
      passwordController.clear();
      passwordHasError = false;
    });
  }

  void updateButtonState() {
    setState(() {
      isButtonEnabled = !emailHasError &&
          !passwordHasError &&
          emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty;
    });
  }

  Future<void> loginUser() async {
    final email = emailController.text;
    final password = passwordController.text;
    // 서버 URL 입력
    final response = await http.post(
      Uri.parse('http://13.239.238.92:8080/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );
    print('Response headers: ${response.headers}');
    print('Response body: ${response.body}'); // 응답 본문을 확인

    if (response.statusCode == 200) {
      try {
        final responseData = json.decode(response.body); // JSON 디코딩
        final nickname = responseData['nickname'] ?? 'Unknown';
        final String email = responseData['email'] ?? '';
        final int userId = responseData['userId'] ?? 0;
        final bool admin = responseData['admin'] ?? false;
        ref.read(authProvider.notifier).login(userId, nickname, email, admin);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ),
        );
      } catch (e) {
        print('JSON decoding error: $e');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Invalid response format')));
      }
    } else {
      final errorMessage = json.decode(response.body)['message'];
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('이메일 로그인'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                '이메일',
                style: ColorTextStyle.mediumNavy(context),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                onChanged: (text) => validateEmail(),
                style: ColorTextStyle.smallNavy(context),
                decoration: InputDecoration(
                  hintText: '이메일 주소를 입력하세요',
                  hintStyle: ColorTextStyle.smallLightNavy(context),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: emailHasError ? Colors.red : Theme.of(context).colorScheme.background,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: emailHasError ? Colors.red : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  suffixIcon: emailController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: clearEmailField,
                        )
                      : null,
                ),
              ),
              if (emailHasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    emailErrorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                '비밀번호',
                style: ColorTextStyle.mediumNavy(context),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                onChanged: (text) => validatePassword(),
                style: ColorTextStyle.smallNavy(context),
                decoration: InputDecoration(
                  hintText: '8자 이상 입력 (문자/숫자/기호 사용 가능)',
                  hintStyle: ColorTextStyle.smallLightNavy(context),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          passwordHasError ? Colors.red : Theme.of(context).colorScheme.background,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: passwordHasError ? Colors.red : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (passwordController.text.isNotEmpty)
                        IconButton(
                          icon: Icon(Icons.close_rounded,color: Theme.of(context).colorScheme.secondary,size: 18,),
                          onPressed: clearPasswordField,
                        ),
                      IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,color: Theme.of(context).colorScheme.secondary,size: 18,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (passwordHasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    passwordErrorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
              const Spacer(), // 버튼

              Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: 350,
                      child: ElevatedButton(
                        onPressed: isButtonEnabled
                            ? () {
                                loginUser(); // 로그인 함수 호출
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: isButtonEnabled
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).cardColor,
                          disabledBackgroundColor: Theme.of(context).cardColor, // 비활성화 색상
                          foregroundColor: isButtonEnabled
                              ? Theme.of(context).colorScheme.surface // 활성화
                              : Theme.of(context).colorScheme.primary, // 비활성화
                          disabledForegroundColor:
                          Theme.of(context).colorScheme.primary, // 비활성화
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          '로그인',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 350,
                      child: TextButton(
                        onPressed: () {
                          // 여기에 두 번째 버튼의 동작을 정의하세요
                          print('두 번째 버튼 클릭됨');
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.only(bottom: 12),
                          textStyle: ColorTextStyle.smallLightNavy(context),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text('비밀번호 재설정'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
