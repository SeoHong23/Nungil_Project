import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// API 서버의 기본 URL 설정
// 눈길 URL
final baseUrl = 'http://13.239.238.92:8080';

// 로컬 백엔드 (크롬으로 실행시)
// final baseUrl = 'http://127.0.0.1:8080';

// 로컬 백엔드 (에뮬레이터로 실행시)
// final baseUrl = 'http://10.0.2.2:8080';

final dio = Dio(
  BaseOptions(
    baseUrl: baseUrl,
    // 요청 데이터 형식을 json 형식으로 지정
    contentType: 'application/json; charset=utf-8',
    // 필수! dio는 200상태코드 아니면 무조건 오류로 분류
    // true 설정 : 다른 상태 값도 허용
    validateStatus: (status) => true,
  ),
);

// 중요 데이터 보관소(금고)
// 민감한 데이터를 보관하는 금고 역할
const secureStorage = FlutterSecureStorage();
