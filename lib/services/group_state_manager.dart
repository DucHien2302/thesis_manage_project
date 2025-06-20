import 'package:thesis_manage_project/models/group_models.dart';
import 'package:thesis_manage_project/repositories/group_repository.dart';
import 'package:thesis_manage_project/repositories/auth_repository.dart';
import 'package:thesis_manage_project/utils/api_service.dart';

class GroupStateManager {
  static final GroupStateManager _instance = GroupStateManager._internal();
  factory GroupStateManager() => _instance;
  GroupStateManager._internal();

  GroupModel? _currentUserGroup;
  String? _currentUserId;
  DateTime? _lastUpdated;
  bool _isLoading = false;

  // Cache duration - 30 seconds
  static const Duration _cacheDuration = Duration(seconds: 30);

  GroupModel? get currentUserGroup => _currentUserGroup;
  String? get currentUserId => _currentUserId;
  bool get isLoading => _isLoading;

  /// Check if cache is still valid
  bool get _isCacheValid {
    if (_lastUpdated == null) return false;
    return DateTime.now().difference(_lastUpdated!) < _cacheDuration;
  }

  /// Get current user's group info with caching
  Future<GroupModel?> getCurrentUserGroup({bool forceRefresh = false}) async {
    // Return cached data if valid and not forcing refresh
    if (_isCacheValid && !forceRefresh && _currentUserGroup != null) {
      return _currentUserGroup;
    }

    // Prevent multiple simultaneous requests
    if (_isLoading) {
      // Wait for current request to complete
      while (_isLoading) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      return _currentUserGroup;
    }

    try {
      _isLoading = true;

      final groupRepository = GroupRepository(apiService: ApiService());
      final authRepository = AuthRepository(apiService: ApiService());

      final results = await Future.wait([
        groupRepository.getCurrentUserGroup(),
        authRepository.getCurrentUser(),
      ]);

      final currentGroup = results[0] as GroupModel?;
      final currentUserData = results[1] as Map<String, dynamic>;

      _currentUserGroup = currentGroup;
      _currentUserId = currentUserData['id']?.toString();
      _lastUpdated = DateTime.now();

      return _currentUserGroup;
    } catch (e) {
      print('Error loading group info: $e');
      return _currentUserGroup; // Return cached data on error
    } finally {
      _isLoading = false;
    }
  }

  /// Update group info (call this when group changes)
  void updateGroupInfo(GroupModel? group, String? userId) {
    _currentUserGroup = group;
    _currentUserId = userId;
    _lastUpdated = DateTime.now();
  }

  /// Clear cache (call on logout)
  void clearCache() {
    _currentUserGroup = null;
    _currentUserId = null;
    _lastUpdated = null;
    _isLoading = false;
  }

  /// Check if current user is group leader
  bool get isCurrentUserGroupLeader {
    if (_currentUserGroup == null || _currentUserId == null) {
      return false;
    }
    return _currentUserGroup!.leaderId == _currentUserId;
  }
}
