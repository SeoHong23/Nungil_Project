import 'package:flutter/material.dart';

class EmailLogin extends StatefulWidget {
  const EmailLogin({super.key});

  @override
  State<EmailLogin> createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {
  bool hasError = false;
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  bool _isPasswordVisible1 = false;
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode1 = FocusNode();
  String errorMessage = '';

  bool isValidEmail(String email) {
    final RegExp regex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    _focusNode1.addListener(_onFocusChange1);
  }

  @override
  void dispose() {
    _focusNode1.removeListener(_onFocusChange1);
    _controller1.dispose();
    super.dispose();
  }

  void _onFocusChange1() {
    if (!_focusNode1.hasFocus) {
      final email = _controller1.text;

      if (email.isEmpty) {
        setState(() {
          hasError = true;
          errorMessage = '입력창에 내용을 입력해주세요.';
        });
      } else if (!isValidEmail(email)) {
        setState(() {
          hasError = true;
          errorMessage = '이메일 형식이 올바르지 않습니다.';
        });
      } else {
        setState(() {
          hasError = false;
          errorMessage = '';
        });
      }
    }
  }

  void clearText() {
    setState(() {
      _controller1.clear();
      hasError = false; // 텍스트를 지우면 오류 없앰
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('이메일 로그인'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      '이메일',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Focus(
                    onFocusChange: (hasFocus) {
                      setState(() {
                        if (!hasFocus && _controller1.text.isEmpty) {
                          hasError = true;
                        } else {
                          hasError = false;
                        }
                      });
                    },
                    child: TextField(
                      controller: _controller1,
                      onChanged: (text) {
                        hasError = !isValidEmail(_controller1.text);
                      },
                      decoration: InputDecoration(
                        hintText: '이메일 주소 입력',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: hasError ? Colors.red : Colors.grey.shade600,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        suffixIcon: _controller1.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: clearText,
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                if (hasError)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '이메일 형식이 올바르지 않습니다.',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      '비밀번호',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: _controller2,
                    obscureText: !_isPasswordVisible1,
                    focusNode: _focusNode2,
                    decoration: InputDecoration(
                        hintText: '8자 이상 입력 (문자/숫자/기호 사용 가능)',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: hasError ? Colors.red : Colors.grey.shade600,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        suffixIcon: _controller2.text.isNotEmpty
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        _controller2.clear();
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      _isPasswordVisible1
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible1 =
                                            !_isPasswordVisible1;
                                      });
                                    },
                                  )
                                ],
                              )
                            : null),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
