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

  /// Get thesis statistics for lecturer
  Future<Map<String, int>> getThesisStatistics() async {
    try {
      final theses = await getLecturerTheses();
      
      // Filter out registered and unregistered status as per requirement
      final filteredTheses = theses.where((thesis) {
        return !thesis.status.contains('Đã được đăng ký') && 
               !thesis.status.contains('Chưa được đăng ký');
      }).toList();

      final Map<String, int> stats = {
        'total': filteredTheses.length,
        'approved': 0,
        'pending': 0,
        'rejected': 0,
      };

      for (final thesis in filteredTheses) {
        final status = thesis.status.toLowerCase();
        if (status.contains('đã duyệt')) {
          stats['approved'] = (stats['approved'] ?? 0) + 1;
        } else if (status.contains('chờ duyệt')) {
          stats['pending'] = (stats['pending'] ?? 0) + 1;
        } else if (status.contains('từ chối')) {
          stats['rejected'] = (stats['rejected'] ?? 0) + 1;
        }
      }

      return stats;
    } catch (e) {
      throw Exception('Không thể lấy thống kê đề tài: $e');
    }
  }  /// Create a new thesis
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
