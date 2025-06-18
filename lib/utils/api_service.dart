import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../config/constants.dart';

class ApiService {
  final http.Client _httpClient;

  ApiService({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();
  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final authHeaders = await _getAuthHeaders(headers);

    try {
      print('API GET request to: ${url.toString()}');
      
      final response = await _httpClient.get(url, headers: authHeaders);
      
      print('API GET response status: ${response.statusCode}');
      print('API GET response body: ${response.body}');
      
      return _handleResponse(response);
    } catch (e) {
      print('API get error: ${e.toString()}');
      throw Exception('Lỗi kết nối mạng: $e');
    }
  }
  Future<dynamic> post(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final authHeaders = await _getAuthHeaders(headers);

    try {
      print('API request to: ${url.toString()}');
      if (body != null) {
        print('Request body: ${json.encode(body)}');
      }
      
      final response = await _httpClient.post(
        url,
        headers: authHeaders,
        body: body != null ? json.encode(body) : null,
      );
      
      print('API response status: ${response.statusCode}');
      print('API response body: ${response.body}');
      
      return _handleResponse(response);
    } catch (e) {
      print('API post error: ${e.toString()}');
      throw Exception('Lỗi kết nối mạng: $e');
    }
  }
  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    Map<String, dynamic>? responseBody;
    
    try {
      if (response.body.isNotEmpty) {
        final decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic>) {
          responseBody = decoded;
        }
      }
    } catch (e) {
      print('Không thể parse response json: ${e.toString()}');
    }

    if (statusCode >= 200 && statusCode < 300) {
      return responseBody ?? {}; // Return empty map if null instead of null
    } else if (statusCode == 401) {
      throw Exception('Không được phép truy cập. Vui lòng đăng nhập lại.');
    } else if (statusCode == 403) {
      throw Exception('Bạn không có quyền truy cập tài nguyên này.');
    } else if (statusCode == 404) {
      throw Exception('Tài nguyên không tồn tại.');
    } else {
      final message =
          responseBody != null && responseBody['detail'] != null
              ? responseBody['detail']
              : 'Có lỗi xảy ra. Mã lỗi: $statusCode';
      throw Exception(message);
    }
  }

  Future<Map<String, String>> _getAuthHeaders(
    Map<String, String>? headers,
  ) async {
    final Map<String, String> authHeaders = {
      'Content-Type': 'application/json',
    };

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConfig.tokenKey);

      if (token != null && token.isNotEmpty) {
        authHeaders['Authorization'] = 'Bearer $token';
      }
    } catch (e) {}

    if (headers != null) {
      authHeaders.addAll(headers);
    }

    return authHeaders;
  }

  // Hàm tiện ích lưu token sau khi login
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConfig.tokenKey, token);
  }
}
