import 'package:thesis_manage_project/models/role_models.dart';
import 'package:thesis_manage_project/utils/api_service.dart';

class RoleRepository {
  final ApiService _apiService;

  RoleRepository({required ApiService apiService}) : _apiService = apiService;

  /// Get all roles
  Future<List<RoleResponseTree>> getAllRoles() async {
    try {
      final response = await _apiService.get('/roles');
      final List<dynamic> data = response;
      return data.map((role) => RoleResponseTree.fromJson(role)).toList();
    } catch (e) {
      throw Exception('Failed to load roles: $e');
    }
  }

  /// Get role by ID
  Future<RoleResponseTree> getRoleById(String roleId) async {
    try {
      final response = await _apiService.get('/roles/$roleId');
      return RoleResponseTree.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load role: $e');
    }
  }

  /// Get all functions
  Future<List<FunctionModel>> getAllFunctions() async {
    try {
      final response = await _apiService.get('/functions');
      final List<dynamic> data = response;
      return data.map((func) => FunctionModel.fromJson(func)).toList();
    } catch (e) {
      throw Exception('Failed to load functions: $e');
    }
  }

  /// Get function tree
  Future<List<FunctionModel>> getFunctionTree() async {
    try {
      final response = await _apiService.get('/functions/tree');
      final List<dynamic> data = response;
      return data.map((func) => FunctionModel.fromJson(func)).toList();
    } catch (e) {
      throw Exception('Failed to load function tree: $e');
    }
  }

  /// Get user roles
  Future<List<UserRoleAssignment>> getUserRoles(String userId) async {
    try {
      final response = await _apiService.get('/user-roles/user/$userId');
      final List<dynamic> data = response;
      return data.map((assignment) => UserRoleAssignment.fromJson(assignment)).toList();
    } catch (e) {
      throw Exception('Failed to load user roles: $e');
    }
  }

  /// Assign role to user
  Future<void> assignRoleToUser(String userId, int roleId) async {
    try {
      await _apiService.post(
        '/user-roles',
        body: {
          'user_id': userId,
          'role_id': roleId,
        },
      );
    } catch (e) {
      throw Exception('Failed to assign role: $e');
    }
  }

  /// Remove role from user
  Future<void> removeRoleFromUser(int assignmentId) async {
    try {
      await _apiService.delete('/user-roles/$assignmentId');
    } catch (e) {
      throw Exception('Failed to remove role: $e');
    }
  }
}
