import 'package:thesis_manage_project/models/thesis_models.dart';
import 'package:thesis_manage_project/utils/api_service.dart';

class LecturerThesisRepository {
  final ApiService _apiService;

  LecturerThesisRepository({required ApiService apiService}) : _apiService = apiService;

  /// Get all theses managed by the current lecturer
  Future<List<ThesisModel>> getLecturerTheses() async {
    try {
      // Using the correct API endpoint from the documentation
      final response = await _apiService.get('/theses/');
      final List<dynamic> data = response;
      return data.map((thesis) => ThesisModel.fromJson(thesis)).toList();
    } catch (e) {
      throw Exception('Không thể lấy danh sách đề tài của giảng viên: $e');
    }
  }

  /// Create a new thesis
  Future<ThesisModel> createThesis(Map<String, dynamic> thesisData) async {
    try {
      print('🔗 POST /theses/ with data: $thesisData');
      final response = await _apiService.post('/theses/', body: thesisData);
      print('✅ Response success: $response');
      return ThesisModel.fromJson(response);
    } catch (e) {
      print('❌ Create thesis error: $e');
      throw Exception('Không thể tạo đề tài mới: $e');
    }
  }

  /// Update thesis
  Future<ThesisModel> updateThesis(String thesisId, Map<String, dynamic> thesisData) async {
    try {
      final response = await _apiService.put('/theses/$thesisId', body: thesisData);
      return ThesisModel.fromJson(response);
    } catch (e) {
      throw Exception('Không thể cập nhật đề tài: $e');
    }
  }

  /// Delete thesis
  Future<void> deleteThesis(String thesisId) async {
    try {
      await _apiService.delete('/theses/$thesisId');
    } catch (e) {
      throw Exception('Không thể xóa đề tài: $e');
    }
  }
}
