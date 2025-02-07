import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///-------------------------------
/// 해당 페이지는 변경시 상의하기
///-------------------------------
/// 2025-01-21 생성 - 강중원
/// 2025-01-21 textTheme().labelSmall 추가 - 김주경
/// 2025-01-22 titleLarge/labelMedium 추가, iconThemeColor 수정 - 김주경
/// 2025-01-24 텍스트용 색상 추가(green, red)
/// 2025-01-25 다크테마 설정 추가

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
    bodySmall: TextStyle(
        fontFamily: 'GmarketSans', fontSize: 12.0, color: DefaultColors.black),

    // 두꺼운 제목 스타일
    // 상세보기 제목에 사용됨
    titleLarge: TextStyle(
        fontFamily: 'GmarketSans',
        fontSize: 20.0,
        color: DefaultColors.black,
        fontWeight: FontWeight.bold),

    // 중간 크기의 제목 스타일
    titleMedium: TextStyle(
        fontFamily: 'GmarketSans', fontSize: 15.0, color: DefaultColors.black),

    // 작은 글자 스타일
    // 버튼?에 써도 될듯?
    labelMedium: TextStyle(
        fontFamily: 'GmarketSans', fontSize: 13.0, color: DefaultColors.black),
    // 상당히 작은 글자 스타일
    // 상세보기 부제/연도에 사용함
    labelSmall: TextStyle(
        fontFamily: 'GmarketSans', fontSize: 12.0, color: DefaultColors.black),

  );
}

// 다크 테마 텍스트
TextTheme textThemeDark() {
  return const TextTheme(
    // 가장 큰 제목 스타일
    displayLarge: TextStyle(
        fontFamily: 'GmarketSans', fontSize: 18.0, color: DefaultColors.white),
    // 중간 크기의 제목 스타일
    displayMedium: TextStyle(
        fontFamily: 'GmarketSans', fontSize: 16.0, color: DefaultColors.white),

    // 본문 텍스트 스타일 (기사, 설명)
    bodyLarge: TextStyle(
        fontFamily: 'GmarketSans', fontSize: 16.0, color: DefaultColors.white),
    // 부제목, 작은 본문 텍스트 스타일
    bodyMedium: TextStyle(
        fontFamily: 'GmarketSans', fontSize: 14.0, color: DefaultColors.white),
    bodySmall: TextStyle(
        fontFamily: 'GmarketSans', fontSize: 12.0, color: DefaultColors.white),

    // 두꺼운 제목 스타일
    // 상세보기 제목에 사용됨
    titleLarge: TextStyle(
        fontFamily: 'GmarketSans',
        fontSize: 20.0,
        color: DefaultColors.white,
        fontWeight: FontWeight.bold),

    // 중간 크기의 제목 스타일
    titleMedium: TextStyle(
        fontFamily: 'GmarketSans', fontSize: 15.0, color: DefaultColors.white),

    // 작은 글자 스타일
    // 버튼?에 써도 될듯?
    labelMedium: TextStyle(
        fontFamily: 'GmarketSans', fontSize: 13.0, color: DefaultColors.white),
    // 상당히 작은 글자 스타일
    // 상세보기 부제/연도에 사용함
    labelSmall: TextStyle(
        fontFamily: 'GmarketSans', fontSize: 12.0, color: DefaultColors.white),
  );
}

//--------------------------------------------

// AppBar 테마 설정
AppBarTheme appBarTheme() {
  return AppBarTheme(
    centerTitle: false, //타이틀 중앙 여부
    backgroundColor: baseBackgroundColor, //타이틀 색상
    elevation: 0.0,
    scrolledUnderElevation: 0,
    iconTheme: IconThemeData(color: iconThemeColor[700]), //아이콘 색상
    titleTextStyle: TextStyle(
        fontFamily: 'GmarketSans',
        fontSize: 16, // 폰트 사이즈
        fontWeight: FontWeight.bold, // 굵기
        color: iconThemeColor[700] // 앱바 제목 텍스트 색상
        ),
  );
}

// DarkAppBar 테마 설정
AppBarTheme appBarThemeDark() {
  return AppBarTheme(
    centerTitle: true, //타이틀 중앙 여부
    backgroundColor: baseBackgroundColorDark, //타이틀 색상
    elevation: 0.0,
    scrolledUnderElevation: 0,
    iconTheme: IconThemeData(color: iconThemeColorDark[700]), //아이콘 색상
    titleTextStyle: TextStyle(
        fontFamily: 'GmarketSans',
        fontSize: 16, // 폰트 사이즈
        fontWeight: FontWeight.bold, // 굵기
        color: iconThemeColorDark[700] // 앱바 제목 텍스트 색상
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

// 바텀네비게이션바 다크 테마 설정
BottomNavigationBarThemeData bottomNavigationBarThemeDark() {
  return BottomNavigationBarThemeData(
    selectedItemColor: iconThemeColorDark[800], // 선택된 아이템 색상
    unselectedItemColor: iconThemeColorDark[200], // 선택되지 않은 아이템 색상
    showUnselectedLabels: true, // 선택 안된 라벨 표시 여부 설정
    backgroundColor: baseBackgroundColorDark,
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
      backgroundColor: baseBackgroundColor,
      accentColor: iconThemeColor[900]
    ),
    cardColor: baseBackgroundColor[100],
    scaffoldBackgroundColor: baseBackgroundColor,
    textTheme: textTheme(),
    appBarTheme: appBarTheme(),
    bottomNavigationBarTheme: bottomNavigationBarTheme(),
  );
}

//--------------------------------------------

// 전체 Dark ThemeData 설정
ThemeData dTheme() {
  return ThemeData(
    // 우리가 직접 지정 함
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: iconThemeColorDark,
        accentColor: iconThemeColorDark[900]
    ),
    cardColor: baseBackgroundColorDark[200],
    scaffoldBackgroundColor: baseBackgroundColorDark,
    textTheme: textThemeDark(),
    iconTheme: IconThemeData(color: iconThemeColorDark[300]),
    appBarTheme: appBarThemeDark(),
    bottomNavigationBarTheme: bottomNavigationBarThemeDark(),
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

const int _baseColorValueDark = 0xFF272A2F;
const int _primaryColorValueDark = 0xFF788B98;
// 다크 테마 배경 색상
const MaterialColor baseBackgroundColorDark = MaterialColor(
  _baseColorValueDark,
  <int, Color>{
    50: Color(0xFF1A1D23), // 거의 블랙에 가까운 딥 네이비
    100: Color(0xFF22252C), // 어두운 네이비
    200: Color(0xFF2A2E36), // 다크 그레이 블루
    300: Color(0xFF333842), // 약간 밝은 톤의 배경
    400: Color(0xFF3D424D), // 중간 정도의 어두운 톤
    500: Color(_baseColorValueDark), // 기본 베이스 색상 (메인 다크 컬러)
    600: Color(0xFF49505D), // 약간 더 밝은 대체 색
    700: Color(0xFF5A6575), // 중간 어두운 톤
    800: Color(0xFF6B7788), // 부드러운 다크 블루
    900: Color(0xFF8899A8), // 가장 밝은 다크 테마 색상
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

// 다크 테마 아이콘
const MaterialColor iconThemeColorDark = MaterialColor(
  _primaryColorValueDark,
  <int, Color>{
    50: Color(0xFF4D5964), // 가장 어두운 색상 (거의 블랙에 가까운 다크 블루)
    100: Color(0xFF5D6E79), // 딥 네이비 계열
    200: Color(0xFF6C7B8C), // 더 어두운 블루 톤
    300: Color(0xFF788B98), // 어두운 블루 그레이
    400: Color(0xFF8A99A9), // 네이비 블루 느낌
    500: Color(_primaryColorValueDark), // 기본 색상 (차분한 블루 계열)
    600: Color(0xFF8D9BAD), // 기본보다 살짝 밝은 컬러
    700: Color(0xFF99A6B7), // 중간 밝기 (채도가 낮은 블루)
    800: Color(0xFFB1BFD0), // 밝은 톤의 블루 그레이
    900: Color(0xFFBCCBD9), // 가장 밝은 톤 (연한 블루 그레이)
  },
);



class DefaultColors {
  static const Color black = Color(0xFF212121); // 아주 짙은 회색(글자색)
  static const Color white = Color(0xFFF1F1F1); // 아주 밝은 회색(글자색)
  static const Color green = Color(0xFF0ca678); // 눈이 편한 초록색 (글자색)
  static const Color yellow = Color(0xFFf7b233); // 약한 경고용 노란색 (글자색)
  static const Color red = Color(0xFFf03e3e); // 경고용 붉은색 (글자색)
  static const Color grey = Color(0xff979797); // 회색 (글자색)
  static const Color navy = Color(0xFF3E5185); // 남색 (버튼색)
  static const Color lightNavy = Color(0xFF788CC8); // 밝은 남색 (버튼색)
}

class CustomTextStyle {
  static const TextStyle bigLogo = TextStyle(fontSize: 50);
  static const TextStyle ranking = TextStyle(
    fontStyle: FontStyle.italic,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle font = TextStyle(fontFamily: 'GmarketSans');
  static const TextStyle pretendard = TextStyle(fontFamily: 'Pretendard');
  static const TextStyle mediumNavy = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 15,
      color: DefaultColors.navy,
      height: 1.6,
      fontWeight: FontWeight.w400,
      wordSpacing: 0.6);
  static const TextStyle mediumLightNavy = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 15,
      color: DefaultColors.lightNavy,
      height: 1.6,
      fontWeight: FontWeight.w400);
  static const TextStyle smallNavy = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 14,
      color: DefaultColors.navy,
      height: 1.8);
  static const TextStyle smallLightNavy = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 14,
      color: DefaultColors.lightNavy,
      height: 1.8);
  static const TextStyle xSmallNavy = TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 12,
      color: DefaultColors.navy,
      height: 1.8);
}
class ColorTextStyle{
  // 라이트 테마 색상
  static TextStyle mediumNavy(BuildContext context) {
    return TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 15,
      color: Theme.of(context).colorScheme.secondary, // 테마에 맞는 색상 적용
      height: 1.6,
      fontWeight: FontWeight.w400,
      wordSpacing: 0.6,
    );
  }

  static TextStyle mediumLightNavy(BuildContext context) {
    return TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 15,
      color: Theme.of(context).colorScheme.primary, // 테마에 맞는 색상 적용
      height: 1.6,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle smallNavy(BuildContext context) {
    return TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 14,
      color: Theme.of(context).colorScheme.secondary, // 테마에 맞는 색상 적용
      height: 1.8,
    );
  }

  static TextStyle smallLightNavy(BuildContext context) {
    return TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 14,
      color: Theme.of(context).colorScheme.primary, // 테마에 맞는 색상 적용
      height: 1.8,
    );
  }

  static TextStyle xSmallNavy(BuildContext context) {
    return TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 12,
      color: Theme.of(context).colorScheme.secondary, // 테마에 맞는 색상 적용
      height: 1.5,
    );
  }
  static TextStyle xSmallLightNavy(BuildContext context) {
    return TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 12,
      color: Theme.of(context).colorScheme.primary, // 테마에 맞는 색상 적용
      height: 1.3,
      wordSpacing: -1
    );
  }
}
