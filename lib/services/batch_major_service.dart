import 'package:thesis_manage_project/models/batch_models.dart';
import 'package:thesis_manage_project/utils/api_service.dart';

class BatchMajorService {
  final ApiService _apiService;

  BatchMajorService({required ApiService apiService}) : _apiService = apiService;

  /// Get all available batches
  Future<List<BatchModel>> getBatches() async {
    try {
      // Endpoint từ API specification: /theses/getall/batches
      final response = await _apiService.get('/theses/getall/batches');
      final List<dynamic> data = response;
      return data.map((batch) => BatchModel.fromJson(batch)).toList();
    } catch (e) {
      throw Exception('Không thể lấy danh sách đợt đề tài: $e');
    }
  }

  /// Get all available majors
  Future<List<MajorModel>> getMajors() async {
    try {
      // Endpoint từ API specification: /theses/getall/major
      final response = await _apiService.get('/theses/getall/major');
      final List<dynamic> data = response;
      return data.map((major) => MajorModel.fromJson(major)).toList();
    } catch (e) {
      throw Exception('Không thể lấy danh sách chuyên ngành: $e');
    }
  }

  /// Get all available departments
  Future<List<DepartmentModel>> getDepartments() async {
    try {
      // Endpoint từ API specification: /theses/getall/department/g
      final response = await _apiService.get('/theses/getall/department/g');
      final List<dynamic> data = response;
      return data.map((department) => DepartmentModel.fromJson(department)).toList();
    } catch (e) {
      throw Exception('Không thể lấy danh sách khoa/phòng ban: $e');
    }
  }
  /// Get all lecturers for reviewer selection
  Future<List<LecturerModel>> getLecturers() async {
    try {
      // Endpoint từ API specification: /users/lecturers
      final response = await _apiService.get('/users/lecturers');
      if (response == null) {
        return []; // Return empty list if response is null
      }
      final List<dynamic> data = response is List ? response : [];
      return data.map((lecturer) => LecturerModel.fromJson(lecturer)).toList();
    } catch (e) {
      throw Exception('Không thể lấy danh sách giảng viên: $e');
    }
  }
}
