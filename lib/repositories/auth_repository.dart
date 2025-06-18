import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thesis_manage_project/config/api_config.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/utils/api_service.dart';

class AuthRepository {
  final ApiService _apiService;
  
  AuthRepository({ApiService? apiService}) 
      : _apiService = apiService ?? ApiService();
  
  // Đăng nhập
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _apiService.post(
        ApiConfig.login,
        body: {
          'user_name': username,
          'password': password,
        },
      );
      
      // Xử lý response null
      final Map<String, dynamic> responseData = response ?? {};
      
      // Lưu token nếu có
      if (responseData.containsKey('access_token') && 
          responseData.containsKey('refresh_token')) {
        
        // Giải mã JWT token để lấy thông tin user cơ bản
        final Map<String, dynamic> userData = _extractUserDataFromToken(responseData['access_token']);
        
        await _saveAuthData(
          responseData['access_token'],
          responseData['refresh_token'],
          userData,
        );
        
        // Thêm thông tin user vào response để các phần khác sử dụng
        responseData['user'] = userData;
      }
      
      return responseData;
    } catch (e) {
      // Ghi log lỗi
      print('Lỗi đăng nhập: ${e.toString()}');
      // Trả về map rỗng trong trường hợp lỗi thay vì null
      return {'error': e.toString()};
    }
  }
  
  // Đăng ký
  Future<Map<String, dynamic>> register(
    String username, 
    String password, 
    int userType
  ) async {
    try {
      final response = await _apiService.post(
        ApiConfig.register,
        body: {
          'user_name': username,
          'password': password,
          'user_type': userType,
          'is_active': true,
        },
      );
      
      return response ?? {};
    } catch (e) {
      print('Lỗi đăng ký: ${e.toString()}');
      return {'error': e.toString()};
    }
  }
  
  // Đăng xuất
  Future<void> logout() async {
    try {
      await _apiService.post(ApiConfig.logout);
    } catch (e) {
      // Ignore errors on logout API
    } finally {
      // Xóa token khỏi local storage
      await _clearAuthData();
    }
  }
  
  // Lấy thông tin người dùng đang đăng nhập
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      // Kiểm tra xem có token lưu trong SharedPreferences không
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConfig.tokenKey);
      
      if (token == null || token.isEmpty) {
        return {'error': 'Không có token đăng nhập'};
      }
      
      // Nếu có thông tin user trong SharedPreferences, trả về luôn
      final userInfoJson = prefs.getString(AppConfig.userInfoKey);
      if (userInfoJson != null && userInfoJson.isNotEmpty) {
        try {
          final userData = json.decode(userInfoJson);
          if (userData is Map<String, dynamic>) {
            return userData;
          }
        } catch (_) {}
      }
      
      // Nếu không có thông tin user cached, gọi API
      final response = await _apiService.get(ApiConfig.me);
      if (response != null && response is Map<String, dynamic>) {
        return response;
      }
      
      // Nếu API không trả về thông tin user, lấy từ token
      return _extractUserDataFromToken(token);
    } catch (e) {
      print('Lỗi lấy thông tin người dùng: ${e.toString()}');
      return {'error': e.toString()};
    }
  }
  
  // Đổi mật khẩu
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    try {
      final response = await _apiService.post(
        ApiConfig.changePassword,
        body: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );
      
      // Nếu response là Map và không chứa lỗi, đổi mật khẩu thành công
      return response is Map && !response.containsKey('error');
    } catch (e) {
      print('Lỗi đổi mật khẩu: ${e.toString()}');
      return false;
    }
  }
  
  // Kiểm tra trạng thái đăng nhập
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConfig.tokenKey);
    
    return token != null && token.isNotEmpty;
  }
  
  // Lưu thông tin xác thực
  Future<void> _saveAuthData(
    String accessToken,
    String refreshToken,
    Map<String, dynamic> userData,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setString(AppConfig.tokenKey, accessToken);
      await prefs.setString(AppConfig.refreshTokenKey, refreshToken);
      
      // Encode userData to JSON
      final userDataJson = json.encode(userData);
      await prefs.setString(AppConfig.userInfoKey, userDataJson);
    } catch (e) {
      print('Lỗi lưu thông tin xác thực: ${e.toString()}');
    }
  }
  
  // Xóa thông tin xác thực
  Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.remove(AppConfig.tokenKey);
    await prefs.remove(AppConfig.refreshTokenKey);
    await prefs.remove(AppConfig.userInfoKey);
  }
  
  // Trích xuất thông tin người dùng từ JWT token
  Map<String, dynamic> _extractUserDataFromToken(String token) {
    try {
      // Phân tách token
      final parts = token.split('.');
      if (parts.length != 3) {
        return {};
      }

      // Lấy phần payload (phần thứ 2)
      String payload = parts[1];
      
      // Padding chuỗi nếu cần để đảm bảo độ dài chia hết cho 4
      while (payload.length % 4 != 0) {
        payload += '=';
      }
      
      // Decode Base64URL
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(decoded) as Map<String, dynamic>;
      
      // Map thông tin người dùng từ JWT claims
      final userData = <String, dynamic>{
        'id': payloadMap['uuid'],
        'username': payloadMap['name'],
        'userType': payloadMap['type'],
        'functions': payloadMap['functions'] ?? [],
      };

      return userData;
    } catch (e) {
      print('Lỗi giải mã token: ${e.toString()}');
      return {};
    }
  }
}
