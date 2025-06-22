import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thesis_manage_project/config/api_config.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/models/thesis_models.dart';

class ThesisService {
  static final ThesisService _instance = ThesisService._internal();
  factory ThesisService() => _instance;
  ThesisService._internal();

  static const String _baseUrl = ApiConfig.baseUrl;

  /// Lấy access token từ SharedPreferences
  Future<String?> _getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(AppConfig.tokenKey);
    } catch (e) {
      return null;
    }
  }  /// Lấy danh sách đề tài theo chuyên ngành của sinh viên đang đăng nhập
  Future<List<ThesisModel>> getThesesByMyMajor() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token không tồn tại');
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/theses/get-all/by-my-major'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print('API Response: $jsonData'); // Debug log
        
        try {
          return jsonData.map((item) {
            print('Processing item: $item'); // Debug log  
            return ThesisModel.fromJson(item);
          }).toList();
        } catch (e) {
          print('Error parsing JSON: $e'); // Debug log
          print('First item causing error: ${jsonData.isNotEmpty ? jsonData[0] : 'empty'}');
          rethrow;
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Lỗi khi tải danh sách đề tài');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }  /// Lấy chi tiết đề tài
  Future<ThesisModel> getThesisDetail(String thesisId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token không tồn tại');
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/theses/$thesisId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ThesisModel.fromJson(jsonData);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Lỗi khi tải chi tiết đề tài');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }  /// Lấy danh sách nhóm của sinh viên đang đăng nhập
  Future<List<GroupModel>> getMyGroups() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token không tồn tại');
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/group/my-groups'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => GroupModel.fromJson(item)).toList();
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Lỗi khi tải danh sách nhóm');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  /// Đăng ký đề tài cho nhóm (chỉ nhóm trưởng mới được đăng ký)
  Future<bool> registerThesisForGroup(
    String groupId,
    String thesisId,
  ) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token không tồn tại');
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/group/$groupId/register-thesis/$thesisId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Lỗi khi đăng ký đề tài');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }  /// Lấy thông tin đề tài theo ID
  Future<ThesisModel> getStudentRegistrations(
    String thesisId,
  ) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token không tồn tại');
      }

      // Sử dụng API đúng: /theses/{thesis_id} để lấy thông tin đề tài
      // Endpoint: get_thesis_by_id_endpoint_theses__thesis_id__get
      final response = await http.get(
        Uri.parse('$_baseUrl/theses/$thesisId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        return ThesisModel.fromJson(jsonData);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Lỗi khi tải thông tin đề tài');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }
  /// Hủy đăng ký đề tài
  Future<void> cancelRegistration(String registrationId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token không tồn tại');
      }

      final response = await http.delete(
        Uri.parse('$_baseUrl/api/student-thesis-registrations/$registrationId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Lỗi khi hủy đăng ký');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }
}
