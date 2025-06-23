import 'package:thesis_manage_project/config/api_config.dart';
import 'package:thesis_manage_project/models/mission_models.dart';
import 'package:thesis_manage_project/utils/api_service.dart';

class MissionRepository {
  final ApiService _apiService;

  MissionRepository({ApiService? apiService}) : _apiService = apiService ?? ApiService();  /// Lấy danh sách các task cho một thesis
  /// API: GET /progress/theses/{thesis_id}/tasks
  Future<List<Task>> getTasksForThesis(String thesisId) async {
    try {
      print('DEBUG: Calling getTasksForThesis with thesisId: $thesisId');
      final response = await _apiService.get('${ApiConfig.thesisTasksEndpoint}$thesisId/tasks');
      print('DEBUG: API response received: $response');
      
      // API service returns the parsed JSON directly
      if (response is List) {
        print('DEBUG: Parsing ${response.length} tasks');
        return response.map((json) => Task.fromJson(json)).toList();
      }
      
      print('DEBUG: Unexpected response format: ${response.runtimeType}');
      throw Exception('Invalid response format: expected List');
    } catch (e) {
      print('DEBUG: Error in getTasksForThesis: $e');
      throw Exception('Error fetching tasks: $e');
    }
  }
  /// Lấy thông tin chi tiết của một task
  /// API: GET /progress/tasks/{task_id}
  Future<Task> getTaskById(String taskId) async {
    try {
      final response = await _apiService.get('${ApiConfig.tasksEndpoint}/$taskId');
      
      // API service returns the parsed JSON directly
      if (response is Map<String, dynamic>) {
        return Task.fromJson(response);
      }
      
      throw Exception('Invalid response format: expected Map');
    } catch (e) {
      throw Exception('Error fetching task details: $e');
    }
  }  /// Cập nhật trạng thái của task
  /// API: PATCH /progress/tasks/{task_id}/status - sử dụng PUT vì ApiService không có phương thức patch
  Future<Task> updateTaskStatus(String taskId, int newStatus) async {
    try {
      final response = await _apiService.put(
        '${ApiConfig.taskStatusEndpoint}$taskId/status',
        body: {
          'status': newStatus,
        },
      );
      
      // API service returns the parsed JSON directly
      if (response is Map<String, dynamic>) {
        return Task.fromJson(response);
      }
      
      throw Exception('Invalid response format: expected Map');
    } catch (e) {
      throw Exception('Error updating task status: $e');
    }
  }
  /// Lấy thông tin mission với các task
  Future<Mission> getMissionWithTasks(String missionId) async {
    try {
      final response = await _apiService.get('${ApiConfig.missions}/$missionId');        
      
      // API service returns the parsed JSON directly
      if (response is Map<String, dynamic>) {
        return Mission.fromJson(response);
      }
      
      throw Exception('Invalid response format: expected Map');
    } catch (e) {
      throw Exception('Error fetching mission details: $e');
    }
  }
}
