import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/models/student_models.dart';
import 'package:thesis_manage_project/models/group_models.dart';
import 'package:thesis_manage_project/repositories/student_repository.dart';
import 'package:thesis_manage_project/repositories/group_repository.dart';
import 'package:thesis_manage_project/repositories/auth_repository.dart';
import 'package:thesis_manage_project/screens/group/bloc/group_bloc.dart';
import 'package:thesis_manage_project/utils/api_service.dart';
import 'package:thesis_manage_project/components/animated_loading.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/services/group_state_manager.dart';

class StudentListView extends StatefulWidget {
  const StudentListView({Key? key}) : super(key: key);

  @override
  State<StudentListView> createState() => _StudentListViewState();
}

class _StudentListViewState extends State<StudentListView>
    with AutomaticKeepAliveClientMixin {
  late StudentRepository _studentRepository;
  late GroupRepository _groupRepository;
  late AuthRepository _authRepository;
  late GroupStateManager _groupStateManager;
  List<StudentModel> _students = [];
  List<StudentModel> _filteredStudents = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _sentInvites = <String>{};
  bool _showGroupBanner = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _studentRepository = StudentRepository(apiService: ApiService());
    _groupRepository = GroupRepository(apiService: ApiService());
    _authRepository = AuthRepository(apiService: ApiService());
    _groupStateManager = GroupStateManager();
    _loadStudents();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh when tab becomes active
    if (mounted && !_isLoading) {
      _refreshGroupInfo();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _sentInvites.clear();
    super.dispose();
  }

  Future<void> _loadStudents() async {
    if (!mounted) return;
    
    try {
      setState(() {
        _isLoading = true;
      });

      // Load students and group info
      final results = await Future.wait([
        _studentRepository.getAllStudents(),
        _groupStateManager.getCurrentUserGroup(),
      ]);

      final students = results[0] as List<StudentModel>;
      
      if (mounted) {
        setState(() {
          _students = _filterAvailableStudents(students);
          _filteredStudents = _students;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showSnackBarIfMounted(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Lỗi khi tải danh sách sinh viên: $e')),
              ],
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    }
  }

  List<StudentModel> _filterAvailableStudents(List<StudentModel> allStudents) {
    final currentGroup = _groupStateManager.currentUserGroup;
    if (currentGroup == null) {
      return allStudents;
    }

    // Get list of member IDs in current user's group
    final Set<String> memberIds = currentGroup.members
        .map((member) => member.userId)
        .toSet();

    // Filter out students who are already in the group
    return allStudents.where((student) => !memberIds.contains(student.id)).toList();
  }

  /// Check if current user is the group leader
  bool get _isCurrentUserGroupLeader {
    return _groupStateManager.isCurrentUserGroupLeader;
  }

  void _filterStudents(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredStudents = _students;
      } else {
        _filteredStudents = _students.where((student) {
          final lowerQuery = query.toLowerCase();
          return student.fullName.toLowerCase().contains(lowerQuery) ||
              student.studentCode.toLowerCase().contains(lowerQuery);
        }).toList();
      }
    });
  }

  Future<void> _sendInvite(StudentModel student) async {
    if (!mounted) return;
    
    try {
      setState(() {
        _sentInvites.add(student.id);
      });

      await context.read<GroupBloc>().groupRepository.sendInvite(student.id);

      // Refresh the students list after sending invite to update group info
      await _refreshGroupInfo();

      if (mounted) {
        _showSnackBarIfMounted(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.white),
                const SizedBox(width: 8),
                Text('Đã gửi lời mời đến ${student.fullName}'),
              ],
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _sentInvites.remove(student.id);
        });
        _showSnackBarIfMounted(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Lỗi khi gửi lời mời: $e')),
              ],
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    }
  }

  Future<void> _refreshGroupInfo() async {
    if (!mounted) return;
    
    try {
      await _groupStateManager.getCurrentUserGroup(forceRefresh: true);
      
      if (mounted) {
        setState(() {
          // Re-filter students based on updated group info
          _students = _filterAvailableStudents(_students);
          _filteredStudents = _searchQuery.isEmpty ? _students : _students.where((student) {
            final lowerQuery = _searchQuery.toLowerCase();
            return student.fullName.toLowerCase().contains(lowerQuery) ||
                student.studentCode.toLowerCase().contains(lowerQuery);
          }).toList();
        });
      }
    } catch (e) {
      print('Error refreshing group info: $e');
    }
  }

  /// Safely show snackbar only if widget is still mounted
  void _showSnackBarIfMounted(SnackBar snackBar) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return BlocListener<GroupBloc, GroupState>(
      listener: (context, state) {
        // Refresh student list when group state changes
        if (state is InviteSentState || 
            state is MemberAddedState || 
            state is MemberRemovedState ||
            state is GroupCreatedState) {
          _refreshGroupInfo();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            // Search Bar
            Container(
              margin: const EdgeInsets.all(AppDimens.marginMedium),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm theo tên hoặc mã sinh viên...',
                  hintStyle: const TextStyle(color: AppColors.textSecondary),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.textSecondary,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _filterStudents('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.marginMedium,
                    vertical: AppDimens.marginMedium,
                  ),
                ),
                onChanged: _filterStudents,
              ),
            ),
            // Results Count
            if (_searchQuery.isNotEmpty) ...[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppDimens.marginMedium),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Tìm thấy ${_filteredStudents.length} sinh viên khả dụng',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            // Group info banner
            if (_groupStateManager.currentUserGroup != null && _showGroupBanner) ...[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppDimens.marginMedium),
                padding: const EdgeInsets.all(AppDimens.marginRegular),
                decoration: BoxDecoration(
                  color: _isCurrentUserGroupLeader 
                      ? AppColors.primary.withOpacity(0.1)
                      : AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                  border: Border.all(
                    color: _isCurrentUserGroupLeader 
                        ? AppColors.primary.withOpacity(0.2)
                        : AppColors.warning.withOpacity(0.2)
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          _isCurrentUserGroupLeader ? Icons.info_outline : Icons.warning_amber_outlined,
                          size: 16,
                          color: _isCurrentUserGroupLeader ? AppColors.primary : AppColors.warning,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Nhóm hiện tại: ${_groupStateManager.currentUserGroup!.name} (${_groupStateManager.currentUserGroup!.members.length} thành viên)',
                            style: TextStyle(
                              color: _isCurrentUserGroupLeader ? AppColors.primary : AppColors.warning,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _showGroupBanner = false;
                            });
                          },
                          icon: Icon(
                            Icons.close,
                            size: 18,
                            color: _isCurrentUserGroupLeader ? AppColors.primary : AppColors.warning,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 24,
                            minHeight: 24,
                          ),
                        ),
                      ],
                    ),
                    if (!_isCurrentUserGroupLeader) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.person_off,
                            size: 14,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Chỉ nhóm trưởng mới có thể mời thành viên mới',
                              style: TextStyle(
                                color: AppColors.warning,
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.marginRegular),
            ],
            // Show group info button when banner is hidden
            if (_groupStateManager.currentUserGroup != null && !_showGroupBanner) ...[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppDimens.marginMedium),
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _showGroupBanner = true;
                    });
                  },
                  icon: Icon(
                    Icons.info_outline,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  label: Text(
                    'Hiển thị thông tin nhóm',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.marginMedium,
                      vertical: 8,
                    ),
                    backgroundColor: AppColors.primary.withOpacity(0.05),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusRegular),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.marginRegular),
            ],
            // Content
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: AnimatedLoadingIndicator(),
      );
    }

    if (_filteredStudents.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadStudents,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppDimens.marginMedium),
        itemCount: _filteredStudents.length,
        itemBuilder: (context, index) {
          final student = _filteredStudents[index];
          return _buildStudentCard(student);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _searchQuery.isEmpty ? Icons.group_off : Icons.search_off,
                size: 48,
                color: AppColors.primary.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: AppDimens.marginMedium),
            Text(
              _searchQuery.isEmpty
                  ? 'Không có sinh viên khả dụng'
                  : 'Không tìm thấy sinh viên nào',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimens.marginRegular),
            Text(
              _searchQuery.isEmpty
                  ? 'Tất cả sinh viên đều đã có nhóm hoặc không khả dụng'
                  : 'Thử với từ khóa khác hoặc xóa bộ lọc',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            if (_searchQuery.isNotEmpty) ...[
              const SizedBox(height: AppDimens.marginMedium),
              TextButton.icon(
                onPressed: () {
                  _searchController.clear();
                  _filterStudents('');
                },
                icon: const Icon(Icons.clear),
                label: const Text('Xóa bộ lọc'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStudentCard(StudentModel student) {
    final bool hasInvited = _sentInvites.contains(student.id);

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.marginMedium),
      child: Card(
        elevation: 2,
        shadowColor: AppColors.primary.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.marginMedium),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                ),
                child: Center(
                  child: Text(
                    student.fullName.isNotEmpty
                        ? student.fullName[0].toUpperCase()
                        : 'S',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.marginMedium),
              // Student Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.fullName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'MSSV: ${student.studentCode}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          'Ngành: ${student.majorName}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (_groupStateManager.currentUserGroup != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
                            ),
                            child: Text(
                              'Khả dụng',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.success,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimens.marginMedium),
              // Action Button
              _buildActionButton(student, hasInvited),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(StudentModel student, bool hasInvited) {
    final currentUserGroup = _groupStateManager.currentUserGroup;
    
    // If user is not a group leader, show disabled state
    if (currentUserGroup != null && !_isCurrentUserGroupLeader) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: AppColors.textSecondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimens.radiusRegular),
          border: Border.all(color: AppColors.textSecondary.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.block,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              'Không có quyền',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    if (hasInvited) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: AppColors.warning.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimens.radiusRegular),
          border: Border.all(color: AppColors.warning.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.schedule,
              size: 16,
              color: AppColors.warning,
            ),
            const SizedBox(width: 4),
            Text(
              'Đã mời',
              style: TextStyle(
                color: AppColors.warning,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: () => _sendInvite(student),
      icon: const Icon(Icons.person_add, size: 18),
      label: const Text('Mời'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.marginMedium,
          vertical: 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusRegular),
        ),
        elevation: 2,
      ),
    );
  }
}
