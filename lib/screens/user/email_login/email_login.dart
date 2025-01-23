import 'package:flutter/material.dart';

class EmailLogin extends StatefulWidget {
  const EmailLogin({super.key});

  @override
  State<EmailLogin> createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {
  bool emailHasError = false;
  bool passwordHasError = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  String emailErrorMessage = '';
  String passwordErrorMessage = '';

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
              const Text(
                '이메일',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                onChanged: (text) => validateEmail(),
                decoration: InputDecoration(
                  hintText: '이메일 주소를 입력하세요',
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: emailHasError ? Colors.red : Colors.grey.shade600,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: emailHasError ? Colors.red : Colors.black,
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
              const Text(
                '비밀번호',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                onChanged: (text) => validatePassword(),
                decoration: InputDecoration(
                  hintText: '8자 이상 입력 (문자/숫자/기호 사용 가능)',
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          passwordHasError ? Colors.red : Colors.grey.shade600,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: passwordHasError ? Colors.red : Colors.black,
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
                          icon: const Icon(Icons.clear),
                          onPressed: clearPasswordField,
                        ),
                      IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
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
            ],
          ),
        ),
      ),
    );
  }
}
