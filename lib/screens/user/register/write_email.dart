import 'package:flutter/material.dart';
import 'password.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WriteEmail extends StatefulWidget {
  const WriteEmail({super.key});

  @override
  State<WriteEmail> createState() => _WriteEmailState();
}

class _WriteEmailState extends State<WriteEmail> {
  bool hasError = false; // 이메일 형식 오류 표시 여부
  bool isButtonEnabled = false; // 이메일 형식이 올바를 때만 버튼 활성화
  bool emailExistsError = false; // 이메일 중복 여부 표시
  final TextEditingController _controller = TextEditingController();

  // 이메일 유효성 검사
  bool isValidEmail(String email) {
    final RegExp regex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final List<String> emailDomains = [
    '@naver.com',
    '@gmail.com',
    '@hanmail.com',
    '@daum.com',
    '@nate.com'
  ];

  // 이메일 유효성에 따라 버튼 상태 갱신
  void updateButtonState() {
    setState(() {
      isButtonEnabled = isValidEmail(_controller.text);
    });
  }

  // 이메일 도메인 버튼 클릭 시 동작
  void setDomainToEmail(String domain) {
    setState(() {
      if (_controller.text.isNotEmpty && _controller.text.contains('@')) {
        _controller.text =
            _controller.text.split('@')[0] + domain; // 기존 텍스트에서 도메인 부분만 바꿈
      } else if (_controller.text.isEmpty) {
        _controller.text = domain; // 텍스트가 비어있으면 도메인만 입력
      } else {
        _controller.text = _controller.text + domain; // 도메인 없으면 텍스트 끝에 추가
      }
      _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length)); // 커서를 마지막 위치로
      updateButtonState(); // 이메일 변경 시 버튼 상태 갱신
      hasError = !isValidEmail(_controller.text); // 이메일 형식이 잘못된 경우 오류 표시
    });
  }

  // 이메일 중복 체크 API 호출
  Future<void> checkEmailExists(String email) async {
    final url = Uri.parse(
        'http://10.0.2.2:8080/check-email?email=$email'); // 실제 서버 URL로 변경하세요.

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // 이메일 중복 여부 확인
        final isEmailExist = jsonDecode(response.body);

        setState(() {
          emailExistsError = isEmailExist; // 중복되면 true로 설정
        });
      } else {
        // 서버 에러 처리
        setState(() {
          emailExistsError = false; // 예외 처리
        });
      }
    } catch (e) {
      // 네트워크 오류 처리
      setState(() {
        emailExistsError = false;
      });
      print('Error: $e');
    }
  }

  // 텍스트 필드의 텍스트를 지우는 함수
  void clearText() {
    setState(() {
      _controller.clear();
      hasError = false; // 텍스트를 지우면 오류 없앰
      emailExistsError = false; // 중복 이메일 오류 없앰
      updateButtonState(); // 텍스트 지운 후 버튼 상태 갱신
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('이메일 회원가입'),
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
                        if (!hasFocus && _controller.text.isEmpty) {
                          hasError = true;
                        } else {
                          hasError = false;
                        }
                      });
                    },
                    child: TextField(
                      controller: _controller,
                      onChanged: (text) {
                        updateButtonState(); // 이메일이 바뀔 때마다 버튼 상태 갱신
                        hasError =
                            !isValidEmail(_controller.text); // 이메일 유효성 검사
                        emailExistsError = false; // 이메일 입력 중에는 중복 에러 초기화
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
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: hasError ? Colors.red : Colors.black,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        suffixIcon: _controller.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: clearText,
                              )
                            : null, // 텍스트가 있을 때만 X 버튼 보이기
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // 이메일 형식 오류 메시지
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
                // 이메일 중복 오류 메시지
                if (emailExistsError)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '이미 가입된 이메일입니다. 이메일 로그인을 시도해주세요.',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                // 버튼 5개 나열
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly, // 버튼 사이 간격을 동일하게
                    children: List.generate(5, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // 도메인 버튼 클릭 시 이메일에 도메인 추가
                            setDomainToEmail(emailDomains[index]);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                              side: BorderSide(color: Colors.grey),
                            ),
                            minimumSize: Size(117, 45),
                          ),
                          child: Text(
                            emailDomains[index],
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const Spacer(),
                Center(
                  child: SizedBox(
                    width: 350,
                    child: ElevatedButton(
                      onPressed: isButtonEnabled
                          ? () async {
                              // 이메일 중복 확인
                              await checkEmailExists(_controller.text);
                              if (!emailExistsError) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Password(
                                        email: _controller.text), // 이메일 값을 전달
                                  ),
                                );
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: isButtonEnabled
                            ? const Color(0xFF0066CC) // 활성화 색상
                            : const Color(0xFF5F92D0), // 비활성화 색상
                        foregroundColor: isButtonEnabled
                            ? Colors.white // 활성화된 상태에서 텍스트는 흰색
                            : Colors.white70, // 비활성화된 상태에서 텍스트는 약간 어두운 흰색
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        '다음',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
