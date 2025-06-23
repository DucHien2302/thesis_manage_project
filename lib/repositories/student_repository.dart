import 'package:thesis_manage_project/models/student_models.dart';
import 'package:thesis_manage_project/utils/api_service.dart';

class StudentRepository {
  final ApiService _apiService;

  StudentRepository({required ApiService apiService}) : _apiService = apiService;

  /// Get list of all students from the same major as current user
  Future<List<StudentModel>> getAllStudents() async {
    try {
      final response = await _apiService.get('/student-profile/gett-all');
      final List<dynamic> data = response;
      return data.map((student) => StudentModel.fromJson(student)).toList();
    } catch (e) {
      print('Error fetching students: $e');
      rethrow;
    }
  }

  /// Get students by major
  Future<List<StudentModel>> getStudentsByMajor(String majorId) async {
    try {
      // This endpoint might not exist in the API, using the general endpoint
      final response = await _apiService.get('/student-profile/gett-all');
      final List<dynamic> data = response;
      final students = data.map((student) => StudentModel.fromJson(student)).toList();
      
      // Filter by major ID
      return students.where((student) => student.studentInfo.majorId == majorId).toList();
    } catch (e) {
      print('Error fetching students by major: $e');
      rethrow;
    }
  }

  /// Search students by name or student code
  Future<List<StudentModel>> searchStudents(String query) async {
    try {
      // Get all students and filter locally since search endpoint might not exist
      final students = await getAllStudents();
      final lowerQuery = query.toLowerCase();
      
      return students.where((student) => 
        student.fullName.toLowerCase().contains(lowerQuery) ||
        student.studentCode.toLowerCase().contains(lowerQuery)
      ).toList();
    } catch (e) {
      print('Error searching students: $e');
      rethrow;
    }
  }

  /// Get student by ID
  Future<StudentModel?> getStudentById(String id) async {
    try {
      // Get all students and find by ID since individual get might not exist
      final students = await getAllStudents();
      return students.firstWhere(
        (student) => student.id == id,
        orElse: () => throw Exception('Student not found'),
      );
    } catch (e) {
      print('Error getting student by ID: $e');      
      return null;
    }
  }  /// Get current student's thesis ID from their group
  Future<String?> getCurrentStudentThesisId() async {
    try {
      print('DEBUG: Calling getCurrentStudentThesisId');
      final response = await _apiService.get('/group/my-groups');
      print('DEBUG: Group API response: $response');
      
      if (response is List && response.isNotEmpty) {
        final firstGroup = response.first;
        print('DEBUG: First group data: $firstGroup');
        final thesisId = firstGroup['thesis_id']?.toString();
        print('DEBUG: Extracted thesis_id: $thesisId');
        return thesisId;
      }
      
      print('DEBUG: No groups found or empty response');
      return null;
    } catch (e) {
      print('DEBUG: Error getting current student thesis ID: $e');
      return null;
    }
  }
}
