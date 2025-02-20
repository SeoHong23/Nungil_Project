import 'package:flutter/material.dart';
import 'package:nungil/theme/common_theme.dart';

import '../register/write_email.dart';

class Term extends StatefulWidget {
  const Term({super.key});

  @override
  State<Term> createState() => _MainScreenState();
}

class _MainScreenState extends State<Term> {
  bool isChecked = false; // "모두 동의합니다" 체크박스 상태
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;

  void updateAllAgreeCheckbox() {
    setState(() {
      isChecked = isChecked1 && isChecked2 && isChecked3;
    });
  }

  void updateIndividualCheckboxes(bool value) {
    setState(() {
      isChecked1 = value;
      isChecked2 = value;
      isChecked3 = value;
      isChecked = value;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child:
                      Text('약관 동의', style: ColorTextStyle.largeNavy(context)),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text('가입을 하시려면 다음의 정책에 대한 동의가 필요합니다.',
                    style: ColorTextStyle.mediumLightNavy(context)),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      updateIndividualCheckboxes(value ?? false);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                    activeColor: Theme.of(context).colorScheme.secondary,
                    checkColor: Theme.of(context).colorScheme.surface,
                  ),
                  Text('모두 동의합니다.', style: ColorTextStyle.mediumNavy(context)),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.black26,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: isChecked1,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked1 = value ?? false;
                        updateAllAgreeCheckbox();
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                    activeColor: Theme.of(context).colorScheme.secondary,
                    checkColor: Theme.of(context).colorScheme.surface,
                  ),
                  Text('[필수] 이용약관에 동의합니다.',
                      style: ColorTextStyle.mediumNavy(context)),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: isChecked2,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked2 = value ?? false;
                        updateAllAgreeCheckbox();
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                    activeColor: Theme.of(context).colorScheme.secondary,
                    checkColor: Theme.of(context).colorScheme.surface,
                  ),
                  Text('[필수] 개인정보 수집 및 이용에 동의합니다.',
                      style: ColorTextStyle.mediumNavy(context)),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: isChecked3,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked3 = value ?? false;
                        updateAllAgreeCheckbox();
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                    activeColor: Theme.of(context).colorScheme.secondary,
                    checkColor: Theme.of(context).colorScheme.surface,
                  ),
                  Text('[필수] 본인은 만 14세 이상입니다.',
                      style: ColorTextStyle.mediumNavy(context)),
                ],
              ),
              const Spacer(),
              Center(
                child: SizedBox(
                  width: 350,
                  child: ElevatedButton(
                    onPressed: (isChecked1 && isChecked2 && isChecked3)
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const WriteEmail(), // 이동할 페이지 지정
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor:
                            (isChecked1 && isChecked2 && isChecked3)
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).cardColor, // 비활성화 색상
                        disabledBackgroundColor: Theme.of(context).cardColor,
                        foregroundColor:
                            (isChecked1 && isChecked2 && isChecked3)
                                ? Theme.of(context).colorScheme.surface // 활성화
                                : Theme.of(context).colorScheme.primary, // 비활성화
                        disabledForegroundColor:
                            Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        )),
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
    );
  }
}
