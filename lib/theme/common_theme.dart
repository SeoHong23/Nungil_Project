import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///-------------------------------
/// 해당 페이지는 변경시 상의하기
///-------------------------------
/// 2025-01-21 생성 - 강중원
/// 2025-01-21 textTheme().labelSmall 추가 - 김주경
/// 2025-01-22 titleLarge/labelMedium 추가, iconThemeColor 수정 - 김주경
/// 2025-01-24 텍스트용 색상 추가(green, red)

//텍스트 테마
TextTheme textTheme() {
  return const TextTheme(
    // 가장 큰 제목 스타일
    displayLarge: TextStyle(
        fontFamily: 'GmarketSans', fontSize: 18.0, color: DefaultColors.black),
    // 중간 크기의 제목 스타일
    displayMedium: TextStyle(
        fontFamily: 'GmarketSans', fontSize: 16.0, color: DefaultColors.black),

    // 본문 텍스트 스타일 (기사, 설명)
    bodyLarge: TextStyle(
        fontFamily: 'GmarketSans', fontSize: 16.0, color: DefaultColors.black),
    // 부제목, 작은 본문 텍스트 스타일
    bodyMedium: TextStyle(
        fontFamily: 'GmarketSans', fontSize: 14.0, color: DefaultColors.black),

    // 두꺼운 제목 스타일
    // 상세보기 제목에 사용됨
    titleLarge: TextStyle(
        fontFamily: 'GmarketSans',
        fontSize: 16.0,
        color: DefaultColors.black,
        fontWeight: FontWeight.bold),

    // 중간 크기의 제목 스타일
    titleMedium: TextStyle(
        fontFamily: 'GmarketSans', fontSize: 15.0, color: DefaultColors.black),

    // 작은 글자 스타일
    // 버튼?에 써도 될듯?
    labelMedium: TextStyle(
        fontFamily: 'GmarketSans', fontSize: 10.0, color: DefaultColors.black),
    // 상당히 작은 글자 스타일
    // 상세보기 부제/연도에 사용함
    labelSmall: TextStyle(
        fontFamily: 'GmarketSans', fontSize: 8.0, color: DefaultColors.black),
  );
}

//--------------------------------------------

// AppBar 테마 설정
AppBarTheme appBarTheme() {
  return AppBarTheme(
    centerTitle: false, //타이틀 중앙 여부
    color: baseBackgroundColor, //타이틀 색상
    elevation: 0.0,
    scrolledUnderElevation: 0,
    iconTheme: IconThemeData(color: DefaultColors.black), //아이콘 색상
    titleTextStyle: TextStyle(
        fontFamily: 'GmarketSans',
        fontSize: 16, // 폰트 사이즈
        fontWeight: FontWeight.bold, // 굵기
        color: DefaultColors.black // 앱바 제목 텍스트 색상
        ),
  );
}

//--------------------------------------------

// 바텀네비게이션바 테마 설정
BottomNavigationBarThemeData bottomNavigationBarTheme() {
  return BottomNavigationBarThemeData(
    selectedItemColor: iconThemeColor[800], // 선택된 아이템 색상
    unselectedItemColor: iconThemeColor[300], // 선택되지 않은 아이템 색상
    showUnselectedLabels: true, // 선택 안된 라벨 표시 여부 설정
    backgroundColor: baseBackgroundColor,
    elevation: 0.0,
  );
}

//--------------------------------------------

// 전체 ThemeData 설정
ThemeData mTheme() {
  return ThemeData(
    // 우리가 직접 지정 함
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: iconThemeColor,
    ),
    scaffoldBackgroundColor: baseBackgroundColor,
    textTheme: textTheme(),
    appBarTheme: appBarTheme(),
    bottomNavigationBarTheme: bottomNavigationBarTheme(),
  );
}

const int _baseColorValue = 0xFFF8FBFF;
const int _primaryColorValue = 0xFF6B85C2;

const MaterialColor baseBackgroundColor = MaterialColor(
  _baseColorValue,
  <int, Color>{
    50: Color(0xFFFCFEFF), // 거의 하얀색
    100: Color(0xFFF9FDFF), // 아주 연한 하늘색
    200: Color(0xFFF6FBFF), // 조금 더 진한 연한 색
    300: Color(0xFFF3FAFF), // 기본 배경보다 조금 더 진함
    400: Color(0xFFF0F8FF), // 더 선명한 배경용
    500: Color(_baseColorValue), // 기본 베이스 색상
    600: Color(0xFFEAF3F9), // 약간 어두운 배경 대체 색
    700: Color(0xFFDDEDF4), // 어두운 톤의 배경
    800: Color(0xFFCFDDEC), // 더 어두운 대체 색상
    900: Color(0xFFB9CBDD), // 가장 어두운 배경 대체 색
  },
);

const MaterialColor iconThemeColor = MaterialColor(
  _primaryColorValue,
  <int, Color>{
    50: Color(0xFFE8EBF5), // 아주 연한 톤
    100: Color(0xFFC5CEE7), // 연한 청보라
    200: Color(0xFF9EADD7), // 중간 밝기
    300: Color(0xFF788CC8), // 기본 색상보다 밝은 청보라
    400: Color(0xFF5973B9), // 약간 더 진한 청보라
    500: Color(_primaryColorValue), // 기본 색상 (#6B85C2)
    600: Color(0xFF5E77AE), // 어두운 청보라
    700: Color(0xFF4E6499), // 더 어두운 청보라
    800: Color(0xFF3E5185), // 진한 청보라
    900: Color(0xFF2C3965), // 가장 어두운 네이비 청보라
  },
);

class DefaultColors {
  static const Color black = Color(0xFF212121); // 아주 짙은 회색(글자색)
  static const Color green = Color(0xFF0ca678); // 눈이 편한 초록색 (글자색)
  static const Color yellow = Color(0xFFf7b233); // 약한 경고용 노란색 (글자색)
  static const Color red = Color(0xFFf03e3e); // 경고용 붉은색 (글자색)
}

class CustomTextStyle {
  static const TextStyle bigLogo = TextStyle(fontSize: 50);
}
