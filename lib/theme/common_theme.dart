import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//-------------------------------
// 해당 페이지는 변경시 상의하기
//-------------------------------
// 2025 - 01 - 21 생성 - 강중원

//텍스트 테마
TextTheme textTheme() {
  return TextTheme(
    // 가장 큰 제목 스타일
    displayLarge: TextStyle(
        fontFamily: 'GmarketSans', fontSize: 18.0, color: Colors.black),
    // 중간 크기의 제목 스타일
    displayMedium: TextStyle(
        fontFamily: 'GmarketSans', fontSize: 16.0, color: Colors.black),

    // 본문 텍스트 스타일 (기사, 설명)
    bodyLarge: TextStyle(
        fontFamily: 'GmarketSans', fontSize: 16.0, color: Colors.black),
    // 부제목, 작은 본문 텍스트 스타일
    bodyMedium: TextStyle(
        fontFamily: 'GmarketSans', fontSize: 14.0, color: Colors.black),

    // 중간 크기의 제목 스타일
    titleMedium: TextStyle(
        fontFamily: 'GmarketSans', fontSize: 15.0, color: Colors.black),
  );
}

//--------------------------------------------

// AppBar 테마 설정
AppBarTheme appBarTheme() {
  return AppBarTheme(
    centerTitle: false, //타이틀 중앙 여부
    color: baseBackgroundColor, //타이틀 색상
    elevation: 0.0,
    iconTheme: IconThemeData(color: Colors.black), //아이콘 색상
    titleTextStyle: TextStyle(
        fontFamily: 'GmarketSans',
        fontSize: 16, // 폰트 사이즈
        fontWeight: FontWeight.bold, // 굵기
        color: Colors.black // 앱바 제목 텍스트 색상
        ),
  );
}

//--------------------------------------------

// 바텀네비게이션바 테마 설정
BottomNavigationBarThemeData bottomNavigationBarTheme() {
  return BottomNavigationBarThemeData(
    selectedItemColor: iconThemeColor[800], // 선택된 아이템 색상
    unselectedItemColor: iconThemeColor, // 선택되지 않은 아이템 색상
    showUnselectedLabels: true, // 선택 안된 라벨 표시 여부 설정
  );
}

//--------------------------------------------

// 전체 ThemeData 설정
ThemeData mTheme() {
  return ThemeData(
    // 머터리얼 3 때부터 변경 됨..
    // 자동 셋팅
    // colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange)
    // 우리가 직접 지정 함
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.orange,
    ),
    scaffoldBackgroundColor: baseBackgroundColor,
    textTheme: textTheme(),
    appBarTheme: appBarTheme(),
    bottomNavigationBarTheme: bottomNavigationBarTheme(),
  );
}

const int _baseColorValue = 0xFFF8FBFF;
const int _primaryColorValue = 0xFFA4DDED;

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
    50: Color(0xFFEAF7FD), // 매우 연한 파란색
    100: Color(0xFFD2EFFB), // 연한 파란색
    200: Color(0xFFB7E5F8), // 조금 더 진한 연한 파란색
    300: Color(0xFF9BD9F4), // 중간 밝기의 파란색
    400: Color(0xFF86D1F1), // 기본보다 약간 더 진한 파란색
    500: Color(_primaryColorValue), // 기본 색상
    600: Color(0xFF8CC9E0), // 약간 어두운 톤
    700: Color(0xFF72BFD9), // 더 어두운 톤
    800: Color(0xFF58B5D2), // 더 진한 파란색
    900: Color(0xFF2C9CBF), // 가장 어두운 파란색
  },
);
