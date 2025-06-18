import 'package:thesis_manage_project/models/student_models.dart';
import 'package:thesis_manage_project/utils/api_service.dart';

class StudentRepository {
  final ApiService _apiService;

  StudentRepository({required ApiService apiService}) : _apiService = apiService;

  /// Get list of all students
  Future<List<StudentModel>> getAllStudents() async {
    try {
      final response = await _apiService.get('/students');
      final List<dynamic> data = response;
      return data.map((student) => StudentModel.fromJson(student)).toList();
    } catch (e) {
      // If API is not available, return empty list
      print('Error fetching students: $e');
      return [];
    }
  }

  /// Get students by major
  Future<List<StudentModel>> getStudentsByMajor(String majorId) async {
    try {
      final response = await _apiService.get('/students/major/$majorId');
      final List<dynamic> data = response;
      return data.map((student) => StudentModel.fromJson(student)).toList();
    } catch (e) {
      // If API is not available, return empty list
      print('Error fetching students by major: $e');
      return [];
    }
  }

  /// Search students by name or student code
  Future<List<StudentModel>> searchStudents(String query) async {
    try {
      final response = await _apiService.get('/students/search?q=$query');
      final List<dynamic> data = response;
      return data.map((student) => StudentModel.fromJson(student)).toList();
    } catch (e) {
      // If API is not available, return empty list
      print('Error searching students: $e');
      return [];
    }
  }

  /// Get student by ID
  Future<StudentModel?> getStudentById(String id) async {
    try {
      final response = await _apiService.get('/students/$id');
      return StudentModel.fromJson(response);
    } catch (e) {
      print('Error fetching student by id: $e');
      return null;
    }
  }
}
