import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thesis_manage_project/config/api_config.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/utils/api_service.dart';
import 'package:thesis_manage_project/utils/logger.dart';

class AuthRepository {
  final ApiService _apiService;
  final Logger _logger = Logger('AuthRepository');
  
  AuthRepository({ApiService? apiService}) 
      : _apiService = apiService ?? ApiService();
  
  /// Đăng nhập với username và password
  /// 
  /// Trả về Map chứa token và thông tin người dùng nếu thành công
  /// Nếu thất bại, trả về Map chứa key 'error' với thông báo lỗi
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
        
        // Lấy thông tin user đầy đủ từ API /auth/me
        try {
          final userInfo = await getCurrentUser();
          if (userInfo.isNotEmpty && !userInfo.containsKey('error')) {
            // Update user data with more detailed info
            responseData['user'] = userInfo;
            // Save updated user info
            await _saveUserInfo(userInfo);
          }
        } catch (e) {
          _logger.warn('Không thể lấy thông tin chi tiết người dùng: $e');
          // Vẫn tiếp tục với thông tin cơ bản từ token
        }
      } else {
        return {'error': 'Đăng nhập thất bại: Không nhận được token'};
      }
      
      return responseData;
    } catch (e) {
      _logger.error('Lỗi đăng nhập: $e');
      return {'error': e.toString()};
    }
  }
  
  /// Đăng ký người dùng mới
  /// 
  /// [username]: Tên đăng nhập
  /// [password]: Mật khẩu
  /// [userType]: Loại người dùng (1: Admin, 2: Lecturer, 3: Student)
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
      _logger.error('Lỗi đăng ký: $e');
      return {'error': e.toString()};
    }
  }
  
  /// Đăng xuất khỏi hệ thống
  /// 
  /// Gọi API logout và xóa dữ liệu xác thực khỏi local storage
  Future<bool> logout() async {
    try {
      await _apiService.post(ApiConfig.logout);
      await _clearAuthData();
      return true;
    } catch (e) {
      _logger.warn('Lỗi đăng xuất từ API: $e');
      // Xóa token khỏi local storage bất kể API có lỗi hay không
      await _clearAuthData();
      return true;
    }
  }
  
  /// Làm mới token khi token hiện tại sắp hết hạn
  /// 
  /// Sử dụng refresh token để lấy access token mới
  Future<Map<String, dynamic>> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString(AppConfig.refreshTokenKey);
      
      if (refreshToken == null || refreshToken.isEmpty) {
        return {'error': 'Không có refresh token'};
      }
      
      final response = await _apiService.post(
        ApiConfig.refreshToken,
        body: {'refresh_token': refreshToken},
      );
      
      if (response != null && 
          response.containsKey('access_token') && 
          response.containsKey('refresh_token')) {
        
        // Giải mã JWT token để lấy thông tin user cơ bản
        final Map<String, dynamic> userData = _extractUserDataFromToken(response['access_token']);
        
        await _saveAuthData(
          response['access_token'],
          response['refresh_token'],
          userData,
        );
        
        return {'success': true, ...response};
      }
      
      return {'error': 'Không thể làm mới token'};
    } catch (e) {
      _logger.error('Lỗi làm mới token: $e');
      return {'error': e.toString()};
    }
  }
  
  /// Lấy thông tin người dùng đang đăng nhập
  /// 
  /// Đầu tiên kiểm tra dữ liệu đã lưu trong SharedPreferences
  /// Nếu không có, gọi API /auth/me để lấy thông tin
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
        } catch (e) {
          _logger.error('Lỗi parse user JSON từ SharedPreferences: $e');
        }
      }
      
      // Nếu không có thông tin user cached hoặc parse lỗi, gọi API
      final response = await _apiService.get(ApiConfig.me);
      if (response != null && response is Map<String, dynamic>) {
        // Lưu thông tin user vào SharedPreferences
        await _saveUserInfo(response);
        return response;
      }
      
      // Nếu API không trả về thông tin user, lấy từ token
      final tokenData = _extractUserDataFromToken(token);
      if (tokenData.isNotEmpty) {
        return tokenData;
      }
      
      return {'error': 'Không thể lấy thông tin người dùng'};
    } catch (e) {
      _logger.error('Lỗi lấy thông tin người dùng: $e');
      return {'error': e.toString()};
    }
  }
  
  /// Đổi mật khẩu của người dùng hiện tại
  /// 
  /// [oldPassword]: Mật khẩu hiện tại
  /// [newPassword]: Mật khẩu mới
  Future<Map<String, dynamic>> changePassword(String oldPassword, String newPassword) async {
    try {
      final response = await _apiService.post(
        ApiConfig.changePassword,
        body: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );
      
      if (response == null) {
        return {'error': 'Không thể đổi mật khẩu'};
      } else if (response.containsKey('error')) {
        return response;
      } else {
        return {'success': true, 'message': 'Đổi mật khẩu thành công'};
      }
    } catch (e) {
      _logger.error('Lỗi đổi mật khẩu: $e');
      return {'error': e.toString()};
    }
  }

  /// Admin đổi mật khẩu cho người dùng khác
  /// Chỉ available cho người dùng có quyền admin
  /// 
  /// [userId]: ID của user cần đổi mật khẩu
  /// [newPassword]: Mật khẩu mới
  Future<Map<String, dynamic>> adminChangePassword(String userId, String newPassword) async {
    try {
      final response = await _apiService.post(
        ApiConfig.adminChangePassword,
        body: {
          'user_id': userId,
          'new_password': newPassword,
        },
      );
      
      if (response == null) {
        return {'error': 'Không thể đổi mật khẩu'};
      } else if (response.containsKey('error')) {
        return response;
      } else {
        return {'success': true, 'message': 'Đổi mật khẩu thành công'};
      }
    } catch (e) {
      _logger.error('Lỗi admin đổi mật khẩu: $e');
      return {'error': e.toString()};
    }
  }
  
  /// Kiểm tra trạng thái đăng nhập của người dùng
  /// 
  /// Trả về true nếu có token trong SharedPreferences
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConfig.tokenKey);
    
    // Kiểm tra token có tồn tại và chưa hết hạn
    if (token != null && token.isNotEmpty) {
      // Kiểm tra token hết hạn chưa
      if (_isTokenExpired(token)) {
        // Thử làm mới token
        final refreshResult = await refreshToken();
        return !refreshResult.containsKey('error');
      }
      return true;
    }
    return false;
  }
  
  /// Gửi yêu cầu quên mật khẩu
  /// 
  /// [email]: Địa chỉ email đã đăng ký
  /// Trả về Map với 'success' và 'message' nếu thành công
  /// Trả về Map với key 'error' nếu thất bại
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await _apiService.post(
        ApiConfig.forgotPassword,
        body: {
          'email': email,
        },
      );
      
      if (response == null) {
        return {'error': 'Không thể gửi yêu cầu quên mật khẩu'};
      } else if (response.containsKey('error')) {
        return response;
      } else {
        return {
          'success': true, 
          'message': response['message'] ?? 'Đã gửi email lấy lại mật khẩu thành công'
        };
      }
    } catch (e) {
      _logger.error('Lỗi gửi yêu cầu quên mật khẩu: $e');
      return {'error': e.toString()};
    }
  }
  
  /// Đặt lại mật khẩu với token
  /// 
  /// [token]: Token xác nhận từ email
  /// [newPassword]: Mật khẩu mới cần đặt
  /// Trả về Map với 'success' và 'message' nếu thành công
  /// Trả về Map với key 'error' nếu thất bại
  Future<Map<String, dynamic>> resetPassword(String token, String newPassword) async {
    try {
      final response = await _apiService.post(
        ApiConfig.resetPassword,
        body: {
          'token': token,
          'new_password': newPassword,
        },
      );
      
      if (response == null) {
        return {'error': 'Không thể đặt lại mật khẩu'};
      } else if (response.containsKey('error')) {
        return response;
      } else {
        return {
          'success': true, 
          'message': response['message'] ?? 'Đặt lại mật khẩu thành công'
        };
      }
    } catch (e) {
      _logger.error('Lỗi đặt lại mật khẩu: $e');
      return {'error': e.toString()};
    }
  }
  
  /// Lưu thông tin xác thực vào SharedPreferences
  /// 
  /// [accessToken]: JWT access token
  /// [refreshToken]: Refresh token
  /// [userData]: Thông tin người dùng
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
      
      // Lưu thêm user_type nếu có
      if (userData.containsKey('user_type')) {
        await prefs.setInt(AppConfig.userTypeKey, userData['user_type']);
      }
    } catch (e) {
      _logger.error('Lỗi lưu thông tin xác thực: $e');
    }
  }
  
  /// Lưu thông tin người dùng vào SharedPreferences
  /// 
  /// [userData]: Thông tin người dùng
  Future<void> _saveUserInfo(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataJson = json.encode(userData);
      await prefs.setString(AppConfig.userInfoKey, userDataJson);
      
      // Lưu thêm user_type nếu có
      if (userData.containsKey('user_type')) {
        await prefs.setInt(AppConfig.userTypeKey, userData['user_type']);
      }
    } catch (e) {
      _logger.error('Lỗi lưu thông tin user: $e');
    }
  }
  
  /// Xóa thông tin xác thực khỏi SharedPreferences
  Future<void> _clearAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.remove(AppConfig.tokenKey);
      await prefs.remove(AppConfig.refreshTokenKey);
      await prefs.remove(AppConfig.userInfoKey);
      await prefs.remove(AppConfig.userTypeKey);
    } catch (e) {
      _logger.error('Lỗi xóa thông tin xác thực: $e');
    }
  }
  
  /// Trích xuất thông tin người dùng từ JWT token
  /// 
  /// [token]: JWT token cần giải mã
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
      
      _logger.info('JWT Payload: $payloadMap');
      
      // Map thông tin người dùng từ JWT claims
      final userType = payloadMap['type'] ?? payloadMap['user_type'] ?? AppConfig.userTypeStudent;
      _logger.info('Extracted user_type: $userType');
      
      final userData = <String, dynamic>{
        'id': payloadMap['uuid'] ?? payloadMap['sub'],
        'user_name': payloadMap['name'] ?? payloadMap['preferred_username'],
        'user_type': userType,
        'user_type_name': _getUserTypeName(userType),
        'functions': payloadMap['functions'] ?? [],
        'email': payloadMap['email'],
        'role': payloadMap['role'],
      };

      return userData;
    } catch (e) {
      _logger.error('Lỗi giải mã token: $e');
      return {};
    }
  }

  /// Kiểm tra token đã hết hạn chưa
  /// 
  /// [token]: JWT token cần kiểm tra
  bool _isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      // Lấy phần payload
      String payload = parts[1];
      
      // Padding chuỗi nếu cần
      while (payload.length % 4 != 0) {
        payload += '=';
      }
      
      // Decode payload
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(decoded) as Map<String, dynamic>;
      
      // Kiểm tra thời gian hết hạn
      if (payloadMap.containsKey('exp')) {
        final expiry = DateTime.fromMillisecondsSinceEpoch(payloadMap['exp'] * 1000);
        final now = DateTime.now();
        
        // Nếu token sắp hết hạn (còn dưới 5 phút), coi như đã hết hạn để refresh
        final difference = expiry.difference(now);
        return difference.inMinutes < 5;
      }
      
      return true; // Nếu không có trường exp, coi như hết hạn
    } catch (e) {
      _logger.error('Lỗi kiểm tra token hết hạn: $e');
      return true; // Nếu có lỗi, coi như đã hết hạn
    }
  }
  
  /// Chuyển đổi user_type (int) thành tên loại người dùng
  /// 
  /// [userType]: Mã loại người dùng
  String _getUserTypeName(int? userType) {
    switch (userType) {
      case AppConfig.userTypeAdmin:
        return 'Quản trị viên';
      case AppConfig.userTypeLecturer:
        return 'Giảng viên';
      case AppConfig.userTypeStudent:
        return 'Sinh viên';
      default:
        return 'Chưa xác định';
    }
  }

  /// Mock login với user type cụ thể (để test)
  Future<Map<String, dynamic>> mockLoginWithUserType(int userType) async {
    try {
      // Tạo mock userData dựa trên userType
      final mockUserData = {
        'id': 'mock_user_${DateTime.now().millisecondsSinceEpoch}',
        'user_name': _getMockUsername(userType),
        'user_type': userType,
        'user_type_name': _getUserTypeName(userType),
        'email': _getMockEmail(userType),
        'role': _getMockRole(userType),
        'functions': <String>[],
      };

      // Tạo mock tokens
      final mockAccessToken = _createMockJWTToken(mockUserData);
      final mockRefreshToken = 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}';

      // Lưu auth data
      await _saveAuthData(mockAccessToken, mockRefreshToken, mockUserData);

      return {
        'access_token': mockAccessToken,
        'refresh_token': mockRefreshToken,
        'user': mockUserData,
      };
    } catch (e) {
      _logger.error('Lỗi mock login: $e');
      return {'error': e.toString()};
    }
  }

  String _getMockUsername(int userType) {
    switch (userType) {
      case AppConfig.userTypeAdmin:
        return 'admin_user';
      case AppConfig.userTypeLecturer:
        return 'lecturer_user';
      case AppConfig.userTypeStudent:
        return 'student_user';
      default:
        return 'unknown_user';
    }
  }

  String _getMockEmail(int userType) {
    switch (userType) {
      case AppConfig.userTypeAdmin:
        return 'admin@university.edu.vn';
      case AppConfig.userTypeLecturer:
        return 'lecturer@university.edu.vn';
      case AppConfig.userTypeStudent:
        return 'student@university.edu.vn';
      default:
        return 'user@university.edu.vn';
    }
  }

  String _getMockRole(int userType) {
    switch (userType) {
      case AppConfig.userTypeAdmin:
        return 'ADMIN';
      case AppConfig.userTypeLecturer:
        return 'LECTURER';
      case AppConfig.userTypeStudent:
        return 'STUDENT';
      default:
        return 'USER';
    }
  }

  String _createMockJWTToken(Map<String, dynamic> userData) {
    // Tạo mock JWT token với payload chứa thông tin user
    final header = {'alg': 'HS256', 'typ': 'JWT'};
    final payload = {
      'sub': userData['id'],
      'name': userData['user_name'],
      'type': userData['user_type'],
      'user_type': userData['user_type'],
      'email': userData['email'],
      'role': userData['role'],
      'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'exp': DateTime.now().add(const Duration(hours: 24)).millisecondsSinceEpoch ~/ 1000,
    };

    final headerEncoded = base64Url.encode(utf8.encode(json.encode(header)));
    final payloadEncoded = base64Url.encode(utf8.encode(json.encode(payload)));
    
    // Mock signature (trong thực tế sẽ được ký bằng secret key)
    const signature = 'mock_signature';
    
    return '$headerEncoded.$payloadEncoded.$signature';
  }

  /// Đăng ký tài khoản giảng viên (chỉ cho admin)
  /// 
  /// [username]: Tên đăng nhập
  /// [password]: Mật khẩu
  Future<Map<String, dynamic>> adminRegisterLecturer(
    String username, 
    String password,
  ) async {
    try {
      // Đăng ký tài khoản với user_type = 3 (giảng viên)
      final response = await _apiService.post(
        ApiConfig.register,
        body: {
          'user_name': username,
          'password': password,
          'user_type': 3, // Lecturer
          'is_active': true,
        },
      );
      return response ?? {};
    } catch (e) {
      _logger.error('Lỗi đăng ký giảng viên: $e');
      return {'error': e.toString()};
    }
  }
}