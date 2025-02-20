import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:nungil/theme/common_theme.dart';

import '../../main_screen.dart';

class UserInfo extends StatefulWidget {
  final String email;
  final String password;
  const UserInfo({Key? key, required this.email, required this.password})
      : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final TextEditingController _nicknameController = TextEditingController();
  final FocusNode _nicknameFocusNode = FocusNode(); // FocusNode 추가
  bool _isNicknameValid = true; // 닉네임 유효성 상태
  bool isButtonEnabled = false;

  final List<String> emotions = [
    "화가난",
    "신이난",
    "행복한",
    "즐거운",
    "깜찍한",
    "싹싹한",
    "고고한",
    "궁금한",
    "덤덤한",
    "친절한"
  ];

  final List<String> names = [
    "강동원",
    "팀버튼",
    "봉준호",
    "브루스윌리스",
    "레이놀즈",
    "크리스토퍼",
    "마동석",
    "윤여정",
    "김혜수",
    "엠마스톤"
  ];

  // 성별 선택 상태 추가
  bool isFemaleSelected = false;
  bool isMaleSelected = false;

  @override
  void initState() {
    super.initState();
    _nicknameFocusNode.addListener(() {
      // 포커스 상태 변화 감지
      if (!_nicknameFocusNode.hasFocus) {
        setState(() {
          _isNicknameValid = _nicknameController.text.isNotEmpty; // 입력값 확인
        });
      }
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _nicknameFocusNode.dispose(); // FocusNode 해제
    super.dispose();
  }

  // 랜덤 닉네임 생성 함수
  String _generateRandomNickname() {
    final random = Random();
    String randomEmotion = emotions[random.nextInt(emotions.length)];
    String randomName = names[random.nextInt(names.length)];
    String randomNumber = List.generate(6, (_) => random.nextInt(10)).join();

    return "$randomEmotion\_$randomName\_$randomNumber";
  }

  // 닉네임 자동 생성
  void _setRandomNickname() {
    String newNickname = _generateRandomNickname();
    setState(() {
      _nicknameController.text = newNickname; // 텍스트필드 값 설정
      _isNicknameValid = true; // 자동 생성 시 유효성 초기화
    });
  }

  void _checkButtonState() {
    setState(() {
      isButtonEnabled = _nicknameController.text.isNotEmpty &&
          (isFemaleSelected || isMaleSelected) &&
          _selectedYear != null;
    });
  }

  // 성별 버튼 클릭 시 상태 변경
  void _toggleGenderSelection(String gender) {
    setState(() {
      if (gender == 'female') {
        isFemaleSelected = !isFemaleSelected; // 여성 선택 상태 토글
        if (isFemaleSelected) {
          isMaleSelected = false; // 남성 선택 취소
        }
      } else if (gender == 'male') {
        isMaleSelected = !isMaleSelected; // 남성 선택 상태 토글
        if (isMaleSelected) {
          isFemaleSelected = false; // 여성 선택 취소
        }
      }
      _checkButtonState();
    });
  }

  int? _selectedYear;

  List<int> years = List.generate(2012 - 1950, (index) => 1950 + index);

  Future<void> _submitForm() async {
    if (!isButtonEnabled) return;

    final nickname = _nicknameController.text;
    final gender = isFemaleSelected ? 'FEMALE' : 'MALE';
    final birthDate = _selectedYear;

    print('전송할 데이터: ${gender}, ${birthDate}, ${nickname}');
    print('Email: ${widget.email}');
    print('Password: ${widget.password}');

    try {
      // HTTP POST 요청
      final response = await http.post(
        Uri.parse('http://13.239.238.92:8080/register'), // 포트 번호를 8080으로 변경
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nickname': nickname,
          'gender': gender,
          'birthDate': birthDate,
          'email': widget.email,
          'password': widget.password,
        }),
      );

      if (response.statusCode == 200) {
        print('회원가입 성공!');
        // 이후 페이지로 이동하는 로직 추가
      } else {
        print('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
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
                // 닉네임 라벨
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      '닉네임',
                      style: ColorTextStyle.mediumNavy(context),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // 닉네임 입력 필드
                TextField(
                  controller: _nicknameController,
                  focusNode: _nicknameFocusNode, // FocusNode 연결
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(20), // 글자 수 제한 (최대 20자)
                  ],
                  style: ColorTextStyle.smallNavy(context),
                  decoration: InputDecoration(
                    hintText: '한글/영문 20자 이내로 입력',
                    hintStyle: ColorTextStyle.smallLightNavy(context),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _isNicknameValid
                            ? Theme.of(context).colorScheme.primary
                            : Colors.red, // 유효성에 따라 색상 변경
                        width: 1.0,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    suffixIcon: _nicknameController.text.isNotEmpty
                        ? IconButton(
                      icon: Icon(Icons.close_rounded,color: Theme.of(context).colorScheme.secondary,size: 18,),
                            onPressed: () {
                              setState(() {
                                _nicknameController.clear(); // 텍스트 지우기
                                _isNicknameValid = false; // 유효성 상태 초기화
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (text) {
                    setState(() {
                      _isNicknameValid = true; // 입력 시 유효성 초기화
                    });
                  },
                ),
                const SizedBox(height: 8),

                // 오류 메시지
                if (!_isNicknameValid)
                  const Text(
                    '입력창에 내용을 입력해주세요.',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                // 텍스트 + 아이콘으로 자동 생성
                MouseRegion(
                  cursor: SystemMouseCursors.click, // 커서 모양 변경
                  child: GestureDetector(
                    onTap: _setRandomNickname, // 클릭 시 닉네임 자동 생성
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "자동생성",
                          style: ColorTextStyle.smallNavy(context),
                        ),
                        const SizedBox(width: 4.0),
                        Icon(
                          Icons.autorenew,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    '성별',
                    style: ColorTextStyle.mediumNavy(context)
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _toggleGenderSelection('female'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: isFemaleSelected
                              ? Theme.of(context).colorScheme.background // 선택 색상
                              : Theme.of(context).colorScheme.surface, // 기본 색상
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('여성 ',style: ColorTextStyle.mediumNavy(context),),
                            Icon(
                              FontAwesomeIcons.personDress, // 여성 아이콘
                              color: Theme.of(context).colorScheme.secondary, // 아이콘 색상
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8), // 버튼 간 간격
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _toggleGenderSelection('male'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: isMaleSelected
                              ? Theme.of(context).colorScheme.background // 선택 색상
                              : Theme.of(context).colorScheme.surface, // 기본 색상
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('남성 ',style: ColorTextStyle.mediumNavy(context),),
                            Icon(
                              FontAwesomeIcons.person,
                              color: Theme.of(context).colorScheme.secondary, // 아이콘 색상
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    '출생 연도',
                      style: ColorTextStyle.mediumNavy(context)
                  ),
                ),
                const SizedBox(height: 8.0),
                DropdownButtonFormField(
                  value: _selectedYear,
                  items: years.map((year) {
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedYear = value;
                      _checkButtonState();
                    });
                  },
                  style: ColorTextStyle.smallNavy(context),
                  decoration: InputDecoration(
                    hintText: '출생 연도',
                    hintStyle: ColorTextStyle.smallLightNavy(context),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    border: const OutlineInputBorder(),enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.background,
                      width: 1.0,
                    ),
                  ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 16.0,
                    ),
                  ),
                ),
                const Spacer(),

                Center(
                  child: SizedBox(
                    width: 350,
                    child: ElevatedButton(
                      onPressed: isButtonEnabled
                          ? () {
                              _submitForm();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MainScreen(), // 이동할 페이지 지정
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: isButtonEnabled
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).cardColor,
                        disabledBackgroundColor: Theme.of(context).cardColor,
                        foregroundColor: isButtonEnabled
                            ? Theme.of(context).colorScheme.surface // 활성화
                            : Theme.of(context).colorScheme.primary, // 비활성화
                        disabledForegroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        '완료',
                          style: CustomTextStyle.pretendard
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
