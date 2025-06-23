import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/screens/auth/blocs/auth_bloc.dart';
import 'package:thesis_manage_project/screens/profile/bloc/profile_bloc.dart';
import 'package:thesis_manage_project/screens/student/bloc/mission_bloc.dart';
import 'package:thesis_manage_project/repositories/profile_repository.dart';
import 'package:thesis_manage_project/repositories/group_repository.dart';
import 'package:thesis_manage_project/repositories/thesis_repository.dart';
import 'package:thesis_manage_project/models/group_models.dart';
import 'package:thesis_manage_project/models/thesis_models.dart' as thesis_models;
import 'package:thesis_manage_project/models/mission_models.dart';
import 'package:thesis_manage_project/utils/api_service.dart';
import 'package:thesis_manage_project/widgets/modern_card.dart';

class OverviewTab extends StatefulWidget {
  final Function(int)? onTabChange;
  
  const OverviewTab({super.key, this.onTabChange});

  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {
  late ProfileBloc _profileBloc;
  late GroupRepository _groupRepository;
  late ThesisRepository _thesisRepository;
  GroupModel? _currentGroup;
  thesis_models.ThesisModel? _currentThesis;
  String? _thesisId;
  List<Task> _currentTasks = [];
  bool _isLoadingGroup = false;
  bool _isLoadingThesis = false;
  bool _isLoadingTasks = false;  @override
  void initState() {
    super.initState();
    _profileBloc = ProfileBloc(
      profileRepository: ProfileRepository(apiService: ApiService())
    );
    _groupRepository = GroupRepository(apiService: ApiService());
    _thesisRepository = ThesisRepository(apiService: ApiService());
    
    // Load profile data and group data
    _loadProfile();
    _loadGroupInfo();
  }

  void _loadProfile() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      final userId = authState.user['id']?.toString() ?? '';
      _profileBloc.add(LoadProfile(
        userType: AppConfig.userTypeStudent,
        userId: userId,
      ));
    }
  }  void _loadGroupInfo() async {
    setState(() {
      _isLoadingGroup = true;
      _isLoadingThesis = true;
      _isLoadingTasks = true;
    });
    
    try {
      final currentGroup = await _groupRepository.getCurrentUserGroup();
      if (mounted) {
        setState(() {
          _currentGroup = currentGroup;
          _isLoadingGroup = false;
        });
        
        // Load thesis information if group has a thesis
        if (currentGroup != null && currentGroup.thesisId != null) {
          _thesisId = currentGroup.thesisId!;
          _loadThesisInfo(currentGroup.thesisId!);
          _loadTasksInfo(currentGroup.thesisId!);
        } else {
          setState(() {
            _currentThesis = null;
            _isLoadingThesis = false;
            _currentTasks = [];
            _isLoadingTasks = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _currentGroup = null;
          _isLoadingGroup = false;
          _currentThesis = null;
          _isLoadingThesis = false;
          _currentTasks = [];
          _isLoadingTasks = false;
        });
      }
    }
  }
    // Method to load thesis information
  void _loadThesisInfo(String thesisId) async {
    try {
      final thesis = await _thesisRepository.getThesisById(thesisId);
      if (mounted) {
        setState(() {
          _currentThesis = thesis;
          _isLoadingThesis = false;
        });
      }
    } catch (e) {
      print('Error loading thesis: $e');
      if (mounted) {
        setState(() {
          _currentThesis = null;
          _isLoadingThesis = false;
        });
      }
    }
  }
  
  // Method to load tasks information
  void _loadTasksInfo(String thesisId) async {
    try {
      // Access the MissionBloc from context
      final missionBloc = context.read<MissionBloc>();
      
      // Listen to the bloc state changes
      final subscription = missionBloc.stream.listen((state) {
        if (mounted) {
          if (state is TasksLoaded) {
            setState(() {
              _currentTasks = state.tasks;
              _isLoadingTasks = false;
            });
          } else if (state is MissionError) {
            setState(() {
              _currentTasks = [];
              _isLoadingTasks = false;
            });
          }
        }
      });
      
      // Load tasks for the thesis
      missionBloc.add(LoadTasksForThesis(thesisId: thesisId));
      
      // Clean up subscription after a delay
      Future.delayed(const Duration(seconds: 5), () {
        subscription.cancel();
      });
    } catch (e) {
      print('Error loading tasks: $e');
      if (mounted) {
        setState(() {
          _currentTasks = [];
          _isLoadingTasks = false;
        });
      }
    }
  }
  // Helper methods để tính toán tiến độ thực tế
  double _calculateOverallProgress() {
    if (_currentTasks.isEmpty) return 0.0;
    final completedTasks = _currentTasks.where((task) => task.isCompleted).length;
    return completedTasks / _currentTasks.length;
  }
  
  String _getProgressText() {
    if (_isLoadingTasks) return 'Đang tải...';
    if (_currentTasks.isEmpty) return 'Chưa có nhiệm vụ';
    
    final progress = _calculateOverallProgress();
    final percent = (progress * 100).round();
    
    if (percent >= 80) return 'Gần hoàn thành';
    if (percent >= 60) return 'Đang tiến triển tốt';
    if (percent >= 40) return 'Đang thực hiện';
    if (percent >= 20) return 'Mới bắt đầu';
    return 'Chưa bắt đầu';
  }
  
  Color _getProgressColor() {
    if (_isLoadingTasks || _currentTasks.isEmpty) return AppColors.info;
    
    final progress = _calculateOverallProgress();
    
    if (progress >= 0.8) return AppColors.success;
    if (progress >= 0.6) return AppColors.primary;
    if (progress >= 0.4) return AppColors.warning;
    return AppColors.error;
  }

  // Helper methods để hiển thị thông tin nhóm
  String _getGroupDisplayValue() {
    if (_isLoadingGroup) {
      return 'Đang tải...';
    }
    
    if (_currentGroup == null) {
      return 'Chưa có nhóm';
    }
    
    // Nếu nhóm có tên thì hiển thị tên, nếu không thì tạo tên mặc định
    if (_currentGroup!.name != null && _currentGroup!.name!.isNotEmpty) {
      return _currentGroup!.name!;
    } else {
      // Tạo tên nhóm mặc định dựa trên số thành viên và ID
      final memberCount = _currentGroup!.members.length;
      if (memberCount <= 1) {
        return 'Nhóm cá nhân';
      } else {
        // Tạo tên dựa trên ID nhóm (lấy 2 ký tự cuối)
        final shortId = _currentGroup!.id.length >= 2 
            ? _currentGroup!.id.substring(_currentGroup!.id.length - 2)
            : _currentGroup!.id;
        return 'Nhóm ${shortId.toUpperCase()}';
      }
    }
  }
  
  String _getGroupSubtitle() {
    if (_isLoadingGroup) {
      return 'Đang tải...';
    }
    
    if (_currentGroup == null) {
      return 'Tạo nhóm mới';
    }
    
    final memberCount = _currentGroup!.members.length;
    if (memberCount == 0) {
      return 'Chưa có thành viên';
    } else if (memberCount == 1) {
      return '1 thành viên';
    } else {
      return '$memberCount thành viên';
    }
  }
  // Helper method để lấy trạng thái đề tài
  String _getThesisStatus() {
    if (_isLoadingThesis) {
      return 'Đang tải...';
    }
    
    if (_currentGroup == null) {
      return 'Chưa có đề tài';
    }
    
    if (_currentGroup!.thesisId == null) {
      return 'Chưa đăng ký';
    }
    
    if (_currentThesis == null) {
      return 'Đã đăng ký';
    }
    
    // Map status từ API thành các trạng thái hiển thị người dùng
    switch (_currentThesis!.status.toLowerCase()) {
      case 'pending':
        return 'Chờ xét duyệt';
      case 'approved':
        return 'Được chấp thuận';
      case 'in progress':
        return 'Đang thực hiện';
      case 'completed':
        return 'Đã hoàn thành';
      case 'rejected':
        return 'Bị từ chối';
      case 'đang thực hiện':
        return 'Đang thực hiện';
      case 'hoàn thành':
        return 'Đã hoàn thành';
      default:
        return 'Đang thực hiện';
    }
  }
  
  // Helper method để lấy màu cho trạng thái đề tài
  Color _getThesisStatusColor() {
    if (_isLoadingThesis || _currentGroup == null || _currentGroup!.thesisId == null) {
      return AppColors.info;  // Default blue
    }
    
    if (_currentThesis == null) {
      return AppColors.primary;  // Primary color
    }
    
    switch (_currentThesis!.status.toLowerCase()) {
      case 'pending':
        return AppColors.warning;  // Yellow for pending
      case 'approved':
        return AppColors.success;  // Green for approved
      case 'in progress':
        return AppColors.info;     // Blue for in progress
      case 'completed':
        return AppColors.success;  // Green for completed
      case 'rejected':
        return AppColors.error;    // Red for rejected
      case 'đang thực hiện':
        return AppColors.info;     // Blue for in progress
      case 'hoàn thành':
        return AppColors.success;  // Green for completed
      default:
        return AppColors.info;     // Default blue
    }
  }

  // Helper method để lấy tiêu đề của đề tài (nếu có)
  String? _getThesisName() {
    if (_isLoadingThesis) {
      return 'Đang tải...';
    }
    
    if (_currentGroup == null || _currentGroup!.thesisId == null) {
      return null;
    }
    
    if (_currentThesis == null) {
      return null;
    }
    
    // Trả về tên của đề tài
    return _currentThesis!.name.length > 20 
        ? _currentThesis!.name.substring(0, 20) + '...' 
        : _currentThesis!.name;
  }

  @override
  void dispose() {
    _profileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _profileBloc,
      child: RefreshIndicator(        onRefresh: () async {
          _loadProfile();
          _loadGroupInfo();
          // Also reload tasks if we have thesis ID
          if (_thesisId != null) {
            context.read<MissionBloc>().add(LoadTasksForThesis(thesisId: _thesisId!));
          }
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              GradientCard(
                gradientColors: [
                  AppColors.primary.withOpacity(0.8),
                  AppColors.primary,
                ],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.waving_hand,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Chào mừng Sinh viên!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Theo dõi tiến độ và quản lý khóa luận của bạn',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Thống kê nhanh
              const Text(
                'Thống kê nhanh',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  StatCard(
                    icon: Icons.assignment,
                    title: 'Trạng thái đề tài',
                    value: _getThesisStatus(),
                    subtitle: _getThesisName(),
                    color: _getThesisStatusColor(),
                  ),                  StatCard(
                    icon: Icons.trending_up,
                    title: 'Tiến độ',
                    value: _isLoadingTasks 
                        ? 'Đang tải...' 
                        : _currentTasks.isEmpty 
                          ? '0%' 
                          : '${(_calculateOverallProgress() * 100).round()}%',
                    subtitle: _getProgressText(),
                    color: _getProgressColor(),
                  ),
                  StatCard(
                    icon: Icons.task_alt,
                    title: 'Nhiệm vụ',
                    value: _isLoadingTasks 
                        ? 'Đang tải...' 
                        : _currentTasks.where((task) => !task.isCompleted).length.toString(),
                    subtitle: 'Còn lại',
                    color: AppColors.error,
                  ),
                  StatCard(
                    icon: Icons.group,
                    title: 'Nhóm',
                    value: _getGroupDisplayValue(),
                    subtitle: _getGroupSubtitle(),
                    color: AppColors.primary,
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Thông tin cá nhân
              const Text(
                'Thông tin cá nhân',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              // Hiển thị thông tin sinh viên từ ProfileBloc
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  print('DEBUG: ProfileBloc state: $state');
                  
                  if (state is ProfileLoading) {
                    print('DEBUG: ProfileLoading state');
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  
                  if (state is ProfileError) {
                    print('DEBUG: ProfileError state: ${state.message}');
                    return _buildEmptyProfileCards();
                  }
                  
                  if (state is ProfileLoaded && state.studentProfile != null) {
                    print('DEBUG: ProfileLoaded state with data');
                    final profile = state.studentProfile!;
                    final information = profile.information;
                    final studentInfo = profile.studentInfo;
                    
                    print('DEBUG: Information - firstName: ${information.firstName}, lastName: ${information.lastName}');
                    print('DEBUG: StudentInfo - studentCode: ${studentInfo.studentCode}, className: ${studentInfo.className}');
                    
                    return _buildProfileCards(information, studentInfo);
                  }
                  
                  print('DEBUG: Default case - no data');
                  // Trường hợp mặc định - chưa có dữ liệu
                  return _buildEmptyProfileCards();
                },
              ),
              
              const SizedBox(height: 20),
                // Actions nhanh
              const Text(
                'Hành động nhanh',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [                  _buildQuickActionCard(
                    icon: Icons.group,
                    title: 'Quản lý nhóm',
                    subtitle: _currentGroup == null ? 'Tạo nhóm mới' : 'Xem nhóm',
                    onPressed: () {
                      if (widget.onTabChange != null) {
                        widget.onTabChange!(1); // Index 1 = Nhóm tab
                      } else {
                        Navigator.pushNamed(context, '/groups');
                      }
                    },
                    color: AppColors.primary,
                  ),
                  _buildQuickActionCard(
                    icon: Icons.assignment,
                    title: 'Đề tài',
                    subtitle: _currentThesis == null ? 'Tìm đề tài' : 'Xem đăng ký',
                    onPressed: () {
                      if (widget.onTabChange != null) {
                        widget.onTabChange!(2); // Index 2 = Đề tài tab
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.info, color: Colors.white),
                                SizedBox(width: 8),
                                Text('Chuyển sang tab "Đề tài" để quản lý'),
                              ],
                            ),
                            backgroundColor: AppColors.info,
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    color: AppColors.info,
                  ),
                  _buildQuickActionCard(
                    icon: Icons.trending_up,
                    title: 'Tiến độ',
                    subtitle: _currentTasks.isEmpty ? 'Chưa có nhiệm vụ' : '${_currentTasks.where((t) => !t.isCompleted).length} việc còn lại',
                    onPressed: () {
                      if (widget.onTabChange != null) {
                        widget.onTabChange!(3); // Index 3 = Tiến độ tab
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.info, color: Colors.white),
                                SizedBox(width: 8),
                                Text('Chuyển sang tab "Tiến độ" để xem chi tiết'),
                              ],
                            ),
                            backgroundColor: AppColors.primary,
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    color: _getProgressColor(),
                  ),
                  _buildQuickActionCard(
                    icon: Icons.person,
                    title: 'Hồ sơ',
                    subtitle: 'Cập nhật thông tin',
                    onPressed: () {
                      if (widget.onTabChange != null) {
                        widget.onTabChange!(4); // Index 4 = Hồ sơ tab
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.info, color: Colors.white),
                                SizedBox(width: 8),
                                Text('Chuyển sang tab "Hồ sơ" để cập nhật'),
                              ],
                            ),
                            backgroundColor: AppColors.accent,
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    color: AppColors.accent,
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
                // Tiến độ dự án - Thiết kế mới
              const Text(
                'Tiến độ dự án',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              
              _buildProgressSection(),
              
              const SizedBox(height: 20),
                // Hoạt động gần đây
              const Text(
                'Hoạt động gần đây',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              
              _buildRecentActivities(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );  }

  // Widget cho Quick Action Card
  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // Widget cho Recent Activities
  Widget _buildRecentActivities() {
    List<Map<String, dynamic>> activities = _generateRecentActivities();
    
    if (activities.isEmpty) {
      return ModernCard(
        child: Column(
          children: [
            Icon(
              Icons.history,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có hoạt động nào',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Các hoạt động gần đây sẽ được hiển thị ở đây',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ModernCard(
      child: Column(
        children: activities.map((activity) => _buildActivityItem(
          activity['title'] as String,
          activity['time'] as String,
          activity['color'] as Color,
          activity['icon'] as IconData,
        )).toList(),
      ),
    );
  }

  // Generate recent activities based on current data
  List<Map<String, dynamic>> _generateRecentActivities() {
    List<Map<String, dynamic>> activities = [];

    // Activity based on group status
    if (_currentGroup != null) {
      activities.add({
        'title': 'Tham gia nhóm ${_getGroupDisplayValue()}',
        'time': 'Gần đây',
        'color': AppColors.primary,
        'icon': Icons.group,
      });
    }

    // Activity based on thesis status
    if (_currentThesis != null) {
      activities.add({
        'title': 'Đăng ký đề tài: ${_currentThesis!.name.length > 30 ? _currentThesis!.name.substring(0, 30) + '...' : _currentThesis!.name}',
        'time': 'Gần đây',
        'color': AppColors.info,
        'icon': Icons.assignment,
      });
    }

    // Activity based on completed tasks
    if (_currentTasks.isNotEmpty) {
      final completedTasks = _currentTasks.where((task) => task.isCompleted).length;
      if (completedTasks > 0) {
        activities.add({
          'title': 'Hoàn thành $completedTasks nhiệm vụ',
          'time': 'Hôm nay',
          'color': AppColors.success,
          'icon': Icons.task_alt,
        });
      }

      // Show pending tasks
      final pendingTasks = _currentTasks.where((task) => !task.isCompleted).length;
      if (pendingTasks > 0) {
        activities.add({
          'title': 'Còn $pendingTasks nhiệm vụ cần hoàn thành',
          'time': 'Cần làm',
          'color': AppColors.warning,
          'icon': Icons.pending_actions,
        });
      }
    }

    // Limit to 3 most recent activities
    return activities.take(3).toList();
  }

  Widget _buildActivityItem(String title, String time, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method để hiển thị profile cards với dữ liệu thực
  Widget _buildProfileCards(dynamic information, dynamic studentInfo) {
    // Helper function để format ngày sinh
    String formatBirthDate(DateTime? dateTime) {
      if (dateTime == null) return 'Đang cập nhật...';
      
      // Kiểm tra nếu là ngày mặc định (1970-01-01)
      if (dateTime.year == 1970 && dateTime.month == 1 && dateTime.day == 1) {
        return 'Đang cập nhật...';
      }
      
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
    }

    // Helper function để kiểm tra chuỗi rỗng hoặc null
    String getDisplayValue(String? value) {
      if (value == null || value.isEmpty || value.trim().isEmpty) {
        return 'Đang cập nhật...';
      }
      return value;
    }

    // Helper function để format họ tên
    String formatFullName(String? firstName, String? lastName) {
      final first = firstName?.trim() ?? '';
      final last = lastName?.trim() ?? '';
      
      if (first.isEmpty && last.isEmpty) {
        return 'Đang cập nhật...';
      }
      
      return '$first $last'.trim();
    }

    return Column(
      children: [
        InfoCard(
          icon: Icons.badge,
          title: 'MSSV',
          value: getDisplayValue(studentInfo.studentCode),
          iconColor: AppColors.primary,
        ),
        InfoCard(
          icon: Icons.person_outline,
          title: 'Họ tên',
          value: formatFullName(information.firstName, information.lastName),
          iconColor: AppColors.primary,
        ),
        InfoCard(
          icon: Icons.school,
          title: 'Lớp',
          value: getDisplayValue(studentInfo.className),
          iconColor: AppColors.info,
        ),
        InfoCard(
          icon: Icons.business,
          title: 'Ngành',
          value: getDisplayValue(studentInfo.majorName),
          iconColor: AppColors.warning,
        ),
        InfoCard(
          icon: Icons.cake,
          title: 'Ngày sinh',
          value: formatBirthDate(information.dateOfBirth),
          iconColor: AppColors.error,
        ),
        InfoCard(
          icon: Icons.location_on,
          title: 'Địa chỉ',
          value: getDisplayValue(information.address),
          iconColor: AppColors.accent,
        ),
        InfoCard(
          icon: Icons.phone,
          title: 'Điện thoại',
          value: getDisplayValue(information.telPhone),
          iconColor: AppColors.info,
        ),
      ],
    );
  }

  // Helper method để hiển thị profile cards rỗng
  Widget _buildEmptyProfileCards() {
    return Column(
      children: [
        InfoCard(
          icon: Icons.badge,
          title: 'MSSV',
          value: 'Đang cập nhật...',
          iconColor: AppColors.primary,
        ),
        InfoCard(
          icon: Icons.person_outline,
          title: 'Họ tên',
          value: 'Đang cập nhật...',
          iconColor: AppColors.primary,
        ),
        InfoCard(
          icon: Icons.school,
          title: 'Lớp',
          value: 'Đang cập nhật...',
          iconColor: AppColors.info,
        ),
        InfoCard(
          icon: Icons.business,
          title: 'Ngành',
          value: 'Đang cập nhật...',
          iconColor: AppColors.warning,
        ),
        InfoCard(
          icon: Icons.cake,
          title: 'Ngày sinh',
          value: 'Đang cập nhật...',
          iconColor: AppColors.error,
        ),
        InfoCard(
          icon: Icons.location_on,
          title: 'Địa chỉ',
          value: 'Đang cập nhật...',
          iconColor: AppColors.accent,
        ),
        InfoCard(
          icon: Icons.phone,
          title: 'Điện thoại',
          value: 'Đang cập nhật...',
          iconColor: AppColors.info,
        ),      ],
    );
  }

  // Widget mới cho phần tiến độ dự án
  Widget _buildProgressSection() {
    if (_isLoadingTasks) {
      return ModernCard(
        child: Column(
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang tải thông tin tiến độ...'),
          ],
        ),
      );
    }

    if (_thesisId == null || _currentTasks.isEmpty) {
      return ModernCard(
        child: Column(
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có nhiệm vụ nào',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Nhiệm vụ sẽ được giao sau khi đăng ký đề tài thành công',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    final completedTasks = _currentTasks.where((task) => task.isCompleted).length;
    final totalTasks = _currentTasks.length;
    final progress = _calculateOverallProgress();
    final progressPercent = (progress * 100).round();

    return Column(
      children: [
        // Main progress card
        GradientCard(
          gradientColors: [
            _getProgressColor().withOpacity(0.8),
            _getProgressColor(),
          ],
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.trending_up,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tổng tiến độ thực hiện',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          _getProgressText(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '$progressPercent%',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$completedTasks/$totalTasks nhiệm vụ hoàn thành',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  if (totalTasks > completedTasks)
                    Text(
                      '${totalTasks - completedTasks} nhiệm vụ còn lại',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Task summary and action
        ModernCard(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nhiệm vụ gần đây',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (_currentTasks.isNotEmpty) ...[
                          ..._currentTasks
                              .where((task) => !task.isCompleted)
                              .take(2)
                              .map((task) => _buildCompactTaskItem(task)),
                          if (_currentTasks.where((task) => !task.isCompleted).length > 2)
                            Text(
                              '+ ${_currentTasks.where((task) => !task.isCompleted).length - 2} nhiệm vụ khác',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ] else ...[
                          Text(
                            'Tất cả nhiệm vụ đã hoàn thành! 🎉',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.success,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(                  onPressed: () {
                    if (widget.onTabChange != null) {
                      widget.onTabChange!(3); // Index 3 = Tiến độ tab
                    } else {
                      // Show guidance to user since we can't directly navigate to tab
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.info, color: Colors.white),
                              SizedBox(width: 8),
                              Text('Chuyển sang tab "Tiến độ" để xem chi tiết'),
                            ],
                          ),
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.assignment),
                  label: const Text('Xem tất cả nhiệm vụ'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactTaskItem(Task task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.circle_outlined,
            size: 16,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              task.title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (task.dueDate != null)
            Text(
              _formatDateCompact(task.dueDate!),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
        ],
      ),
    );
  }

  String _formatDateCompact(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);
    
    if (difference.inDays < 0) {
      return 'Quá hạn';
    } else if (difference.inDays == 0) {
      return 'Hôm nay';
    } else if (difference.inDays == 1) {
      return 'Ngày mai';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày';
    } else {
      return '${date.day}/${date.month}';
    }
  }
}
