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
    color: Colors.white, //타이틀 색상
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
    selectedItemColor: Colors.black, // 선택된 아이템 색상
    unselectedItemColor: Colors.grey, // 선택되지 않은 아이템 색상
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
    scaffoldBackgroundColor: Colors.white,
    textTheme: textTheme(),
    appBarTheme: appBarTheme(),
    bottomNavigationBarTheme: bottomNavigationBarTheme(),
  );
}
