import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../config/constants.dart';
import 'logger.dart';

class ApiService {
  final http.Client _httpClient;
  final Logger _logger = Logger('ApiService');

  ApiService({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();  /// Thực hiện HTTP GET request
  /// 
  /// [endpoint]: Đường dẫn API, sẽ được thêm vào sau BaseURL
  /// [headers]: Headers bổ sung nếu cần
  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final authHeaders = await _getAuthHeaders(headers);

    try {
      _logger.debug('API GET request to: ${url.toString()}');
      
      final response = await _httpClient.get(url, headers: authHeaders);
      
      _logger.debug('API GET response status: ${response.statusCode}');
      _logger.debug('API GET response body: ${response.body}');
      
      return _handleResponse(response);
    } catch (e) {
      _logger.error('API get error: $e');
      throw Exception('Lỗi kết nối mạng: $e');
    }
  }

  /// Thực hiện HTTP POST request
  /// 
  /// [endpoint]: Đường dẫn API, sẽ được thêm vào sau BaseURL
  /// [headers]: Headers bổ sung nếu cần
  /// [body]: Body của request, sẽ được encode sang JSON
  Future<dynamic> post(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final authHeaders = await _getAuthHeaders(headers);

    try {
      _logger.debug('API POST request to: ${url.toString()}');
      if (body != null) {
        _logger.debug('Request body: ${json.encode(body)}');
      }
      
      final response = await _httpClient.post(
        url,
        headers: authHeaders,
        body: body != null ? json.encode(body) : null,
      );
      
      _logger.debug('API response status: ${response.statusCode}');
      _logger.debug('API response body: ${response.body}');
      
      return _handleResponse(response);
    } catch (e) {
      _logger.error('API post error: $e');
      throw Exception('Lỗi kết nối mạng: $e');
    }
  }
  
  /// Thực hiện HTTP PUT request
  /// 
  /// [endpoint]: Đường dẫn API, sẽ được thêm vào sau BaseURL
  /// [headers]: Headers bổ sung nếu cần
  /// [body]: Body của request, sẽ được encode sang JSON
  Future<dynamic> put(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final authHeaders = await _getAuthHeaders(headers);

    try {
      _logger.debug('API PUT request to: ${url.toString()}');
      if (body != null) {
        _logger.debug('Request body: ${json.encode(body)}');
      }
      
      final response = await _httpClient.put(
        url,
        headers: authHeaders,
        body: body != null ? json.encode(body) : null,
      );
      
      _logger.debug('API response status: ${response.statusCode}');
      _logger.debug('API response body: ${response.body}');
      
      return _handleResponse(response);
    } catch (e) {
      _logger.error('API put error: $e');
      throw Exception('Lỗi kết nối mạng: $e');
    }
  }
  
  /// Thực hiện HTTP DELETE request
  /// 
  /// [endpoint]: Đường dẫn API, sẽ được thêm vào sau BaseURL
  /// [headers]: Headers bổ sung nếu cần
  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final authHeaders = await _getAuthHeaders(headers);

    try {
      _logger.debug('API DELETE request to: ${url.toString()}');
      
      final response = await _httpClient.delete(
        url,
        headers: authHeaders,
      );
      
      _logger.debug('API response status: ${response.statusCode}');
      _logger.debug('API response body: ${response.body}');
      
      return _handleResponse(response);
    } catch (e) {
      _logger.error('API delete error: $e');
      throw Exception('Lỗi kết nối mạng: $e');
    }
  }  /// Xử lý response từ API
  /// 
  /// Trả về dữ liệu phản hồi nếu thành công (status 2xx)
  /// Throw Exception nếu có lỗi
  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    dynamic responseData;
    
    try {
      if (response.body.isNotEmpty) {
        responseData = json.decode(response.body);
      }
    } catch (e) {
      _logger.error('Không thể parse response JSON: $e');
    }

    if (statusCode >= 200 && statusCode < 300) {
      return responseData; // Return the actual decoded data (List, Map, or primitive)
    } else if (statusCode == 401) {
      // Lưu lại lỗi để xử lý token hết hạn ở tầng trên
      throw Exception(responseData is Map && responseData['detail'] != null 
          ? responseData['detail'] 
          : 'Không được phép truy cập. Vui lòng đăng nhập lại.');
    } else if (statusCode == 403) {
      throw Exception(responseData is Map && responseData['detail'] != null 
          ? responseData['detail'] 
          : 'Bạn không có quyền truy cập tài nguyên này.');
    } else if (statusCode == 404) {
      throw Exception(responseData is Map && responseData['detail'] != null 
          ? responseData['detail'] 
          : 'Tài nguyên không tồn tại.');
    } else if (statusCode == 422) {
      // Validation errors
      String errorMsg = 'Lỗi xác thực dữ liệu:';
      if (responseData is Map && responseData.containsKey('detail')) {
        final details = responseData['detail'];
        if (details is List) {
          for (var detail in details) {
            if (detail is Map && detail.containsKey('msg')) {
              errorMsg += '\n- ${detail['msg']}';
            }
          }
        } else {
          errorMsg = responseData['detail'].toString();
        }
      }
      throw Exception(errorMsg);
    } else {
      final message = responseData is Map && responseData['detail'] != null
          ? responseData['detail']
          : 'Có lỗi xảy ra. Mã lỗi: $statusCode';
      throw Exception(message);
    }
  }

  /// Tạo headers cho API request với token xác thực
  /// 
  /// [headers]: Headers bổ sung (nếu có)
  Future<Map<String, String>> _getAuthHeaders(
    Map<String, String>? headers,
  ) async {
    final Map<String, String> authHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConfig.tokenKey);

      if (token != null && token.isNotEmpty) {
        authHeaders['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      _logger.error('Lỗi lấy auth token: $e');
    }

    if (headers != null) {
      authHeaders.addAll(headers);
    }

    return authHeaders;
  }

  /// Lưu token vào SharedPreferences
  /// 
  /// [token]: Access token cần lưu
  /// [refreshToken]: Refresh token cần lưu (optional)
  Future<void> saveTokens({required String token, String? refreshToken}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConfig.tokenKey, token);
      
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await prefs.setString(AppConfig.refreshTokenKey, refreshToken);
      }
    } catch (e) {
      _logger.error('Lỗi lưu token: $e');
    }
  }
  
  /// Xóa tất cả tokens khỏi SharedPreferences
  Future<void> clearTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConfig.tokenKey);
      await prefs.remove(AppConfig.refreshTokenKey);
    } catch (e) {
      _logger.error('Lỗi xóa tokens: $e');
    }
  }
}
