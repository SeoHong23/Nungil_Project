import 'package:flutter/material.dart';
import 'package:nungil/theme/common_theme.dart';

import 'user_info.dart';

class Password extends StatefulWidget {
  final String email;
  const Password({Key? key, required this.email}) : super(key: key);

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  bool hasError = false;
  bool isPasswordMatch = true; // 비밀번호 일치 여부
  bool isButtonEnabled = false; // 버튼 활성화 상태
  String errorMessage = '';
  bool _isPasswordVisible1 = false; // 첫 번째 비밀번호 가시성 상태
  bool _isPasswordVisible2 = false; // 두 번째 비밀번호 가시성 상태
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode1.addListener(_onFocusChange1);
    _focusNode2.addListener(_onFocusChange2);

    // TextEditingController에 리스너 추가 (실시간 입력 처리)
    _controller1.addListener(_validatePassword);
    _controller2.addListener(_validatePasswordConfirm);
  }

  @override
  void dispose() {
    _focusNode1.removeListener(_onFocusChange1);
    _focusNode2.removeListener(_onFocusChange2);
    _controller1.removeListener(_validatePassword);
    _controller2.removeListener(_validatePasswordConfirm);
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  void _onFocusChange1() {
    if (!_focusNode1.hasFocus) {
      final password = _controller1.text;

      // 초기 빈 값 검사
      if (password.isEmpty) {
        setState(() {
          hasError = true;
          errorMessage = '입력창에 내용을 입력해주세요.';
        });
      } else if (password.length < 8) {
        setState(() {
          hasError = true;
          errorMessage = '최소 8자 이상 입력';
        });
      } else if (!_isPasswordValid(password)) {
        setState(() {
          hasError = true;
          errorMessage = '영문/숫자/특수문자 중 2개 이상 사용하여 8자 이상 입력';
        });
      } else {
        setState(() {
          hasError = false;
          errorMessage = '';
        });
      }
    }
  }

  void _onFocusChange2() {
    if (!_focusNode2.hasFocus) {
      _validatePasswordConfirm();
    }
  }

  void _validatePassword() {
    final password = _controller1.text;

    if (password.isEmpty) {
      setState(() {
        hasError = false;
        errorMessage = '';
      });
    } else if (password.length < 8) {
      setState(() {
        hasError = true;
        errorMessage = '최소 8자 이상 입력';
      });
    } else if (!_isPasswordValid(password)) {
      setState(() {
        hasError = true;
        errorMessage = '영문/숫자/특수문자 중 2개 이상 사용하여 8자 이상 입력';
      });
    } else {
      setState(() {
        hasError = false;
        errorMessage = '';
      });
    }
  }

  void _validatePasswordConfirm() {
    final password = _controller1.text;
    final confirmPassword = _controller2.text;

    if (confirmPassword.isEmpty) {
      setState(() {
        isPasswordMatch = true;
        errorMessage = '';
        isButtonEnabled = false; // 비밀번호가 일치하지 않으면 버튼 비활성화
      });
    } else if (confirmPassword != password) {
      setState(() {
        isPasswordMatch = false;
        errorMessage = '비밀번호가 일치하지 않습니다.';
        isButtonEnabled = false; // 비밀번호가 일치하지 않으면 버튼 비활성화
      });
    } else {
      setState(() {
        isPasswordMatch = true;
        errorMessage = '';
        isButtonEnabled =
            !hasError; // 비밀번호가 일치하면 버튼 활성화 (단, 첫 번째 비밀번호 유효성 검사 통과해야 함)
      });
    }
  }

  bool _isPasswordValid(String password) {
    // 영문, 숫자, 특수문자 중 2개 이상 포함하고 8자 이상인지 체크하는 정규식
    final regex = RegExp(
        r'^(?=(.*[a-zA-Z]){1})(?=(.*\d){1})(?=(.*[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?]){1}).{8,}$');
    return regex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('이메일 회원가입'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 첫 번째 비밀번호 섹션
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      '비밀번호',
                      style: ColorTextStyle.mediumNavy(context),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // 첫 번째 비밀번호 TextField
                TextField(
                  controller: _controller1,
                  obscureText: !_isPasswordVisible1, // 가시성 토글
                  focusNode: _focusNode1, // FocusNode 연결
                  style: ColorTextStyle.smallNavy(context),
                  decoration: InputDecoration(
                    hintText: '영문/숫자/특수문자를 사용하여 8자 이상 입력',
                    hintStyle: ColorTextStyle.smallLightNavy(context),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: hasError ? Colors.red : Theme.of(context).colorScheme.background,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: hasError ? Colors.red : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    suffixIcon: _controller1.text.isNotEmpty
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.close_rounded,color: Theme.of(context).colorScheme.secondary,size: 18,),
                                onPressed: () {
                                  setState(() {
                                    _controller1.clear();
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  _isPasswordVisible1
                                      ? Icons.visibility
                                      : Icons.visibility_off,color: Theme.of(context).colorScheme.secondary,size: 18,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible1 = !_isPasswordVisible1;
                                  });
                                },
                              ),
                            ],
                          )
                        : null,
                  ),
                ),
                if (hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      errorMessage,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                // 두 번째 비밀번호 섹션
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      '비밀번호 확인',
                      style: ColorTextStyle.mediumNavy(context),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // 두 번째 비밀번호 TextField (비밀번호 확인)
                TextField(
                  controller: _controller2,
                  obscureText: !_isPasswordVisible2, // 가시성 토글
                  focusNode: _focusNode2, // FocusNode 연결
                  style: ColorTextStyle.smallNavy(context),
                  decoration: InputDecoration(
                    hintText: '비밀번호 다시 입력',
                    hintStyle: ColorTextStyle.smallLightNavy(context),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: hasError ? Colors.red : Theme.of(context).colorScheme.background,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: hasError ? Colors.red : Theme.of(context).colorScheme.primary,
                      ),
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
                                icon: Icon(Icons.close_rounded,color: Theme.of(context).colorScheme.secondary,size: 18,),
                                onPressed: () {
                                  setState(() {
                                    _controller2.clear();
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  _isPasswordVisible2
                                      ? Icons.visibility
                                      : Icons.visibility_off,color: Theme.of(context).colorScheme.secondary,size: 18,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible2 = !_isPasswordVisible2;
                                  });
                                },
                              ),
                            ],
                          )
                        : null,
                  ),
                ),
                if (!isPasswordMatch)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      errorMessage,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const Spacer(),

                // 버튼
                Center(
                  child: SizedBox(
                    width: 350,
                    child: ElevatedButton(
                      onPressed: isButtonEnabled
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserInfo(
                                    email:
                                        widget.email, // Password 페이지에서 받은 이메일
                                    password:
                                        _controller1.text, // 첫 번째 비밀번호 입력값
                                  ),
                                ),
                              );
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
                        '다음',
                        style: CustomTextStyle.pretendard,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
