import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nungil/providers/auth_provider.dart';

// HTTP 통신 서비스 - 토큰 자동 추가 기능
class AuthHttpService {
  final Ref _ref;

  AuthHttpService(this._ref);

  // 토큰을 가져오는 메서드
  Future<String?> _getToken() async {
    try {
      // 먼저 상태에서 토큰 확인
      final authState = _ref.read(authProvider);

      if (authState.accessToken != null && authState.accessToken!.isNotEmpty) {
        return authState.accessToken;
      }

      // 상태에 없으면 SharedPreferences에서 직접 확인
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null || token.isEmpty) {
        print("⚠️ 저장된 토큰이 없습니다. 로그인 상태를 확인하세요!");
      }

      return token;
    } catch (e) {
      print('❌ 토큰 가져오기 오류: $e');
      return null;
    }
  }

  // 인증이 필요한 GET 요청
  Future<http.Response> authGet(String url,
      {Map<String, String>? headers}) async {
    try {
      // 토큰 가져오기
      final token = await _getToken();

      // 헤더 준비
      final requestHeaders = {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        ...?headers,
      };

      print('📡 인증 GET 요청: $url');
      print('🔑 토큰 사용 여부: ${token != null ? '사용' : '미사용'}');

      // 요청 보내기
      final response = await http.get(
        Uri.parse(url),
        headers: requestHeaders,
      );

      print('📡 응답 상태 코드: ${response.statusCode}');

      // 토큰 만료 처리 (401 Unauthorized)
      if (response.statusCode == 401) {
        print('⚠️ 토큰이 만료되었습니다. 로그아웃 처리합니다.');
        await _ref.read(authProvider.notifier).logout();
      }

      return response;
    } catch (e) {
      print('❌ 인증 GET 요청 오류: $e');
      rethrow;
    }
  }

  // 인증이 필요한 POST 요청
  Future<http.Response> authPost(String url, dynamic body,
      {Map<String, String>? headers}) async {
    try {
      // 토큰 가져오기
      final token = await _getToken();

      // 헤더 준비
      final requestHeaders = {
        'Content-Type': 'application/json; charset=utf-8',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        ...?headers,
      };

      // 바디 준비
      final jsonBody = body is String ? body : json.encode(body);

      print('📡 인증 POST 요청: $url');
      print('🔑 토큰 사용 여부: ${token != null ? '사용' : '미사용'}');

      // 요청 보내기
      final response = await http.post(
        Uri.parse(url),
        headers: requestHeaders,
        body: jsonBody,
      );

      print('📡 응답 상태 코드: ${response.statusCode}');

      // 토큰 만료 처리 (401 Unauthorized)
      if (response.statusCode == 401) {
        print('⚠️ 토큰이 만료되었습니다. 로그아웃 처리합니다.');
        await _ref.read(authProvider.notifier).logout();
      }

      return response;
    } catch (e) {
      print('❌ 인증 POST 요청 오류: $e');
      rethrow;
    }
  }

  // 인증이 필요한 PUT 요청
  Future<http.Response> authPut(String url, dynamic body,
      {Map<String, String>? headers}) async {
    try {
      // 토큰 가져오기
      final token = await _getToken();

      // 헤더 준비
      final requestHeaders = {
        'Content-Type': 'application/json; charset=utf-8',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        ...?headers,
      };

      // 바디 준비
      final jsonBody = body is String ? body : json.encode(body);

      print('📡 인증 PUT 요청: $url');
      print('🔑 토큰 사용 여부: ${token != null ? '사용' : '미사용'}');

      // 요청 보내기
      final response = await http.put(
        Uri.parse(url),
        headers: requestHeaders,
        body: jsonBody,
      );

      print('📡 응답 상태 코드: ${response.statusCode}');

      // 토큰 만료 처리 (401 Unauthorized)
      if (response.statusCode == 401) {
        print('⚠️ 토큰이 만료되었습니다. 로그아웃 처리합니다.');
        await _ref.read(authProvider.notifier).logout();
      }

      return response;
    } catch (e) {
      print('❌ 인증 PUT 요청 오류: $e');
      rethrow;
    }
  }

  // 인증이 필요한 DELETE 요청
  Future<http.Response> authDelete(String url,
      {Map<String, String>? headers}) async {
    try {
      // 토큰 가져오기
      final token = await _getToken();

      // 헤더 준비
      final requestHeaders = {
        'Content-Type': 'application/json; charset=utf-8',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        ...?headers,
      };

      print('📡 인증 DELETE 요청: $url');
      print('🔑 토큰 사용 여부: ${token != null ? '사용' : '미사용'}');

      // 요청 보내기
      final response = await http.delete(
        Uri.parse(url),
        headers: requestHeaders,
      );

      print('📡 응답 상태 코드: ${response.statusCode}');

      // 토큰 만료 처리 (401 Unauthorized)
      if (response.statusCode == 401) {
        print('⚠️ 토큰이 만료되었습니다. 로그아웃 처리합니다.');
        await _ref.read(authProvider.notifier).logout();
      }

      return response;
    } catch (e) {
      print('❌ 인증 DELETE 요청 오류: $e');
      rethrow;
    }
  }
}

// HTTP 서비스 공급자
final authHttpServiceProvider = Provider<AuthHttpService>((ref) {
  return AuthHttpService(ref);
});
