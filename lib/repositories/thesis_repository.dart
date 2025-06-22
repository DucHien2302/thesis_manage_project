import 'package:thesis_manage_project/models/thesis_models.dart';
import 'package:thesis_manage_project/utils/api_service.dart';

class ThesisRepository {
  final ApiService _apiService;

  ThesisRepository({required ApiService apiService}) : _apiService = apiService;
  /// Get all available thesis topics
  Future<List<ThesisModel>> getAllThesis() async {
    try {
      final response = await _apiService.get('/thesis');
      final List<dynamic> data = response;
      return data.map((thesis) => ThesisModel.fromJson(thesis)).toList();
    } catch (e) {
      throw Exception('Không thể lấy danh sách đề tài: $e');
    }
  }
  /// Get thesis details by ID
  Future<ThesisModel> getThesisById(String thesisId) async {
    try {
      // Updated to use the correct endpoint: /theses/{thesis_id}
      final response = await _apiService.get('/theses/$thesisId');
      return ThesisModel.fromJson(response);
    } catch (e) {
      throw Exception('Không thể lấy thông tin chi tiết đề tài: $e');
    }
  }

  /// Search thesis by title or description
  Future<List<ThesisModel>> searchThesis(String query) async {
    try {
      final response = await _apiService.get('/thesis/search?q=$query');
      final List<dynamic> data = response;
      return data.map((thesis) => ThesisModel.fromJson(thesis)).toList();
    } catch (e) {
      throw Exception('Không thể tìm kiếm đề tài: $e');
    }
  }

  /// Get thesis by instructor
  Future<List<ThesisModel>> getThesisByInstructor(String instructorId) async {
    try {
      final response = await _apiService.get('/thesis/instructor/$instructorId');
      final List<dynamic> data = response;
      return data.map((thesis) => ThesisModel.fromJson(thesis)).toList();
    } catch (e) {
      throw Exception('Không thể lấy danh sách đề tài của giảng viên: $e');
    }
  }

  /// Get available thesis (not yet registered by any group)
  Future<List<ThesisModel>> getAvailableThesis() async {
    try {
      final response = await _apiService.get('/thesis/available');
      final List<dynamic> data = response;
      return data.map((thesis) => ThesisModel.fromJson(thesis)).toList();
    } catch (e) {
      throw Exception('Không thể lấy danh sách đề tài có sẵn: $e');
    }
  }
}
