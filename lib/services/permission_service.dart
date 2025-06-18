import 'package:shared_preferences/shared_preferences.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/models/role_models.dart';
import 'package:thesis_manage_project/repositories/role_repository.dart';

class PermissionService {
  final RoleRepository _roleRepository;
  
  // Cache danh sách chức năng và quyền
  List<FunctionModel> _userFunctions = [];
  
  // Mapping từ mã chức năng sang quyền
  final Map<String, bool> _permissionCache = {};
  
  PermissionService({required RoleRepository roleRepository})
      : _roleRepository = roleRepository;

  /// Khởi tạo dữ liệu quyền sau khi đăng nhập
  Future<void> initPermissions(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
        // Lấy user type từ shared preferences
      final userType = prefs.getInt(AppConfig.userTypeKey) ?? AppConfig.userTypeStudent;
      print('Loading permissions for user: $userId, userType: $userType');
      
      // Lấy danh sách vai trò của người dùng
      final userRoles = await _roleRepository.getUserRoles(userId);
      
      // Tạo danh sách chức năng từ vai trò
      for (var userRole in userRoles) {
        try {
          final roleData = await _roleRepository.getRoleById(userRole.roleId.toString());
          _userFunctions.addAll(roleData.function);
        } catch (e) {
          print('Error loading role: ${e.toString()}');
        }
      }
      
      // Thêm quyền mặc định dựa trên loại tài khoản
      _addDefaultPermissions(userType);
      
      // Cập nhật cache quyền
      _updatePermissionCache();
    } catch (e) {
      print('Error initializing permissions: ${e.toString()}');
    }
  }
    /// Thêm quyền mặc định dựa trên loại người dùng
  void _addDefaultPermissions(int userType) {
    switch (userType) {
      case AppConfig.userTypeAdmin:
        // Admin có tất cả quyền
        _permissionCache[FunctionPaths.adminDashboard] = true;
        _permissionCache[FunctionPaths.adminUsers] = true;        _permissionCache[FunctionPaths.adminRoles] = true;
        _permissionCache[FunctionPaths.lecturerTheses] = true;
        _permissionCache[FunctionPaths.lecturerDashboard] = true;
        _permissionCache[FunctionPaths.lecturerStudents] = true;
        _permissionCache[FunctionPaths.lecturerCommittee] = true;
        _permissionCache[FunctionPaths.studentGroupManagement] = true;
        _permissionCache[FunctionPaths.studentThesisRegistration] = true;
        _permissionCache[FunctionPaths.studentTaskManagement] = true;
        _permissionCache[FunctionPaths.profile] = true;
        _permissionCache[FunctionPaths.settings] = true;
        break;
      
      case AppConfig.userTypeLecturer:
        // Quyền mặc định cho giảng viên
        _permissionCache[FunctionPaths.lecturerTheses] = true;
        _permissionCache[FunctionPaths.lecturerDashboard] = true;
        _permissionCache[FunctionPaths.lecturerStudents] = true;
        _permissionCache[FunctionPaths.lecturerCommittee] = true;
        _permissionCache[FunctionPaths.profile] = true;
        _permissionCache[FunctionPaths.settings] = true;
        break;      case AppConfig.userTypeStudent:
        // Quyền mặc định cho sinh viên
        _permissionCache[FunctionPaths.studentGroupManagement] = true;
        _permissionCache[FunctionPaths.studentThesisRegistration] = true;
        _permissionCache[FunctionPaths.studentTaskManagement] = true;
        _permissionCache[FunctionPaths.profile] = true;
        _permissionCache[FunctionPaths.settings] = true;
        break;
    }
  }
  
  /// Cập nhật cache quyền từ danh sách chức năng
  void _updatePermissionCache() {
    _permissionCache.clear();
    
    for (var func in _userFunctions) {
      if (func.path != null) {
        _permissionCache[func.path!] = true;
      }
      
      // Thêm các chức năng con vào cache
      _addChildFunctionsToCache(func.children);
    }
  }
  
  /// Thêm đệ quy các chức năng con vào cache
  void _addChildFunctionsToCache(List<FunctionModel> children) {
    for (var child in children) {
      if (child.path != null) {
        _permissionCache[child.path!] = true;
      }
      
      if (child.children.isNotEmpty) {
        _addChildFunctionsToCache(child.children);
      }
    }
  }
  
  /// Kiểm tra nếu người dùng có quyền truy cập chức năng
  bool hasPermission(String functionPath) {
    // Nếu không có path, không cho phép truy cập
    if (functionPath.isEmpty) return false;
    
    return _permissionCache[functionPath] ?? false;
  }
  
  /// Kiểm tra nếu người dùng là admin
  Future<bool> isAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    final userType = prefs.getInt('user_type') ?? 0;
    return userType == AppConfig.userTypeAdmin;
  }
  
  /// Kiểm tra nếu người dùng là giảng viên
  Future<bool> isLecturer() async {
    final prefs = await SharedPreferences.getInstance();
    final userType = prefs.getInt('user_type') ?? 0;
    return userType == AppConfig.userTypeLecturer;
  }
  
  /// Kiểm tra nếu người dùng là sinh viên
  Future<bool> isStudent() async {
    final prefs = await SharedPreferences.getInstance();
    final userType = prefs.getInt('user_type') ?? 0;
    return userType == AppConfig.userTypeStudent;
  }
  
  /// Trả về danh sách các chức năng được phép
  List<FunctionModel> getPermittedFunctions() {
    return _userFunctions;
  }
  
  /// Xóa dữ liệu quyền khi đăng xuất
  void clearPermissions() {
    _userFunctions = [];
    _permissionCache.clear();
  }
}
