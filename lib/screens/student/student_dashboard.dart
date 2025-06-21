import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/screens/auth/blocs/auth_bloc.dart';
import 'package:thesis_manage_project/screens/profile/profile_screen.dart';
import 'package:thesis_manage_project/screens/profile/bloc/profile_bloc.dart';
import 'package:thesis_manage_project/repositories/profile_repository.dart';
import 'package:thesis_manage_project/repositories/group_repository.dart';
import 'package:thesis_manage_project/models/group_models.dart';
import 'package:thesis_manage_project/utils/api_service.dart';
import 'package:thesis_manage_project/widgets/modern_card.dart';
import 'package:thesis_manage_project/widgets/ui_components.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _currentIndex = 0;
  String _currentPageTitle = 'Tổng quan';

  final List<Map<String, dynamic>> _menuItems = [
    {
      'icon': Icons.dashboard_outlined,
      'activeIcon': Icons.dashboard,
      'title': 'Tổng quan',
      'pageTitle': 'Tổng quan',
    },
    {
      'icon': Icons.group_outlined,
      'activeIcon': Icons.group,
      'title': 'Nhóm',
      'pageTitle': 'Nhóm của tôi',
    },
    {
      'icon': Icons.assignment_outlined,
      'activeIcon': Icons.assignment,
      'title': 'Đề tài',
      'pageTitle': 'Đề tài',
    },
    {
      'icon': Icons.task_outlined,
      'activeIcon': Icons.task,
      'title': 'Nhiệm vụ',
      'pageTitle': 'Nhiệm vụ',
    },
    {
      'icon': Icons.bar_chart_outlined,
      'activeIcon': Icons.bar_chart,
      'title': 'Tiến độ',
      'pageTitle': 'Tiến độ',
    },
    {
      'icon': Icons.person_outlined,
      'activeIcon': Icons.person,
      'title': 'Hồ sơ',
      'pageTitle': 'Hồ sơ',
    },
  ];  @override
  void initState() {
    super.initState();
    // Load profile data after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated) {
        context.read<ProfileBloc>().add(LoadProfile(
          userType: authState.user['user_type'] ?? 0,
          userId: authState.user['id'] ?? '',
        ));
      }
    });
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Icon(Icons.logout, color: AppColors.error),
              const SizedBox(width: 8),
              const Text('Xác nhận đăng xuất'),
            ],
          ),
          content: const Text('Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                BlocProvider.of<AuthBloc>(context).add(const LogoutRequested());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Đăng xuất'),
            ),
          ],
        );
      },
    );
  }  @override
  Widget build(BuildContext context) {
    return Scaffold(      appBar: AppBar(
        title: Text(_currentPageTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implement notifications
            },
            tooltip: 'Thông báo',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
            tooltip: 'Đăng xuất',
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildCurrentPage(),
      ),floatingActionButton: _currentIndex == 0 
          ? FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    title: const Text('Tạo mới'),
                    content: const Text('Bạn muốn tạo gì?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Hủy'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Tính năng đang phát triển')),
                          );
                        },
                        child: const Text('Tạo nhiệm vụ'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.add),              label: const Text('Tạo mới'),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            )
          : null,
    );  }
  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [          // Drawer Header với thông tin từ API
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, profileState) {
              return Container(
                padding: const EdgeInsets.all(16),                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,                        child: Icon(
                          Icons.school,
                          size: 28,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (profileState is ProfileLoaded && profileState.studentProfile != null) ...[
                              Text(
                                '${profileState.studentProfile!.information.firstName} ${profileState.studentProfile!.information.lastName}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'MSSV: ${profileState.studentProfile!.studentInfo.studentCode}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                profileState.studentProfile!.studentInfo.majorName ?? 'Chưa cập nhật ngành',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ] else ...[
                              const Text(
                                'Sinh viên',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Đang tải thông tin...',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Menu Items với Flexible thay vì Expanded
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              shrinkWrap: true,
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                final isSelected = index == _currentIndex;
                
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isSelected ? AppColors.primary.withOpacity(0.1) : null,
                  ),
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),                    leading: Icon(
                      isSelected ? item['activeIcon'] : item['icon'],
                      size: 22,
                      color: isSelected ? AppColors.primary : Colors.grey[600],
                    ),
                    title: Text(
                      item['title'],                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppColors.primary : Colors.grey[800],
                      ),
                    ),                    onTap: () {
                      setState(() {
                        _currentIndex = index;
                        _currentPageTitle = item['pageTitle'];
                      });
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),
          
          // Footer - Divider và Logout
          const Divider(height: 1),
          ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Icon(Icons.logout, color: AppColors.error, size: 22),
            title: Text(
              'Đăng xuất',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.error,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return const _OverviewTab();
      case 1:
        return const _GroupTab();
      case 2:
        return const _ThesisTab();
      case 3:
        return const _TaskTab();
      case 4:
        return const _ProgressTab();
      case 5:
        return const ProfileScreen();
      default:
        return const _OverviewTab();
    }
  }
}

// Tab Tổng quan
class _OverviewTab extends StatefulWidget {
  const _OverviewTab();

  @override
  State<_OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<_OverviewTab> {
  late ProfileBloc _profileBloc;
  late GroupRepository _groupRepository;
  GroupModel? _currentGroup;
  bool _isLoadingGroup = false;
    @override
  void initState() {
    super.initState();
    _profileBloc = ProfileBloc(
      profileRepository: ProfileRepository(apiService: ApiService())
    );
    _groupRepository = GroupRepository(apiService: ApiService());
    
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
  }

  void _loadGroupInfo() async {
    setState(() {
      _isLoadingGroup = true;
    });
    
    try {
      final currentGroup = await _groupRepository.getCurrentUserGroup();
      if (mounted) {
        setState(() {
          _currentGroup = currentGroup;
          _isLoadingGroup = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _currentGroup = null;
          _isLoadingGroup = false;
        });
      }
    }  }

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
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [            // Welcome section
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
                  value: 'Đang thực hiện',
                  color: AppColors.info,
                ),
                StatCard(
                  icon: Icons.trending_up,
                  title: 'Tiến độ',
                  value: '65%',
                  subtitle: 'Đang tốt',
                  color: AppColors.warning,
                ),
                StatCard(
                  icon: Icons.task_alt,
                  title: 'Nhiệm vụ',
                  value: '3',
                  subtitle: 'Còn lại',
                  color: AppColors.error,
                ),                StatCard(
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
            const SizedBox(height: 12),            // Hiển thị thông tin sinh viên từ ProfileBloc
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
            
            Row(
              children: [
                Expanded(
                  child: QuickActionButton(
                    icon: Icons.add_task,
                    label: 'Tạo nhiệm vụ',                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tính năng đang phát triển')),
                      );
                    },
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: QuickActionButton(
                    icon: Icons.upload_file,
                    label: 'Nộp báo cáo',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tính năng đang phát triển')),
                      );
                    },
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: QuickActionButton(
                    icon: Icons.schedule,
                    label: 'Lịch hẹn',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tính năng đang phát triển')),
                      );
                    },
                    color: AppColors.info,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Tiến độ dự án
            const Text(
              'Tiến độ dự án',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            
            ModernCard(
              child: Column(
                children: [
                  ProgressIndicatorWidget(                  progress: 0.65,
                  label: 'Tổng tiến độ',
                  color: AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  ProgressIndicatorWidget(
                    progress: 0.8,
                    label: 'Nghiên cứu lý thuyết',
                    color: AppColors.info,
                  ),
                  const SizedBox(height: 16),
                  ProgressIndicatorWidget(
                    progress: 0.4,
                    label: 'Phát triển ứng dụng',
                    color: AppColors.warning,
                  ),
                  const SizedBox(height: 16),
                  ProgressIndicatorWidget(
                    progress: 0.2,
                    label: 'Viết báo cáo',
                    color: AppColors.error,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Thông báo gần đây
            const Text(
              'Thông báo gần đây',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            
            ModernCard(
              child: Column(
                children: [
                  _buildNotificationItem(                  'Có nhiệm vụ mới được giao',
                  '2 giờ trước',
                  AppColors.primary,
                  ),
                  _buildNotificationItem(
                    'Hạn nộp báo cáo tiến độ',
                    '1 ngày',
                    AppColors.warning,
                  ),                  _buildNotificationItem(
                    'Cuộc họp nhóm lúc 14:00',                    'Hôm nay',
                    AppColors.primary,
                  ),
                ],
              ),
            ),            const SizedBox(height: 20),          ],
        ),
      ),
      ),

    );
  }

  Widget _buildNotificationItem(String title, String date, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.circle, color: color, size: 8),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            date,
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
        InfoCard(          icon: Icons.person_outline,
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
        ),        InfoCard(
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
        InfoCard(          icon: Icons.person_outline,
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
        ),
      ],
    );
  }
}

// Tab Nhóm
class _GroupTab extends StatelessWidget {
  const _GroupTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModernCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.group, color: AppColors.primary, size: 28),
                    const SizedBox(width: 12),
                    const Text(
                      'Quản lý nhóm',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tạo nhóm, mời thành viên và quản lý các hoạt động nhóm.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/groups');
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Vào trang quản lý nhóm'),                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Tab Đề tài
class _ThesisTab extends StatelessWidget {
  const _ThesisTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModernCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.assignment, color: AppColors.info, size: 28),
                    const SizedBox(width: 12),
                    const Text(
                      'Quản lý đề tài',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Chức năng quản lý đề tài sẽ được phát triển tại đây.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Tab Nhiệm vụ
class _TaskTab extends StatelessWidget {
  const _TaskTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientCard(
            gradientColors: [
              AppColors.warning.withOpacity(0.8),
              AppColors.warning,
            ],
            child: Row(
              children: [
                Icon(Icons.task, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Quản lý nhiệm vụ',
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Nhiệm vụ đang thực hiện
          const Text(
            'Nhiệm vụ đang thực hiện',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          
          ModernCard(
            child: Column(
              children: [                _buildTaskItem(
                  'Hoàn thành Chapter 1',
                  'Hôm nay',
                  AppColors.primary,
                  0.8,
                ),
                const Divider(),
                _buildTaskItem(
                  'Chuẩn bị báo cáo tiến độ',
                  'Ngày mai',
                  AppColors.warning,
                  0.3,
                ),
                const Divider(),
                _buildTaskItem(
                  'Phỏng vấn người dùng',
                  '3 ngày',
                  AppColors.info,
                  0.1,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tính năng đang phát triển')),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm nhiệm vụ'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warning,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tính năng đang phát triển')),
                    );
                  },
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Bộ lọc'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.warning,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String title, String deadline, Color color, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              StatusBadge(
                text: deadline,
                color: color,
                icon: Icons.schedule,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: ProgressIndicatorWidget(
              progress: progress,
              color: color,
              showPercentage: true,
              height: 6,
            ),
          ),
        ],
      ),
    );
  }
}

// Tab Tiến độ
class _ProgressTab extends StatelessWidget {
  const _ProgressTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [          GradientCard(
            gradientColors: [
              AppColors.primary.withOpacity(0.8),
              AppColors.primary,
            ],
            child: Row(
              children: [
                Icon(Icons.bar_chart, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Theo dõi tiến độ',
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Tổng quan tiến độ
          StatCard(
            icon: Icons.timeline,            title: 'Tiến độ tổng thể',
            value: '65%',
            subtitle: 'Đang đạt mục tiêu',
            color: AppColors.primary,
          ),
          
          const SizedBox(height: 20),
          
          const Text(
            'Chi tiết tiến độ từng giai đoạn',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          
          ModernCard(
            child: Column(
              children: [                _buildProgressPhase(
                  'Nghiên cứu & Phân tích',
                  0.9,
                  AppColors.primary,
                  'Hoàn thành',
                ),
                const SizedBox(height: 16),
                _buildProgressPhase(
                  'Thiết kế hệ thống',
                  0.7,
                  AppColors.info,
                  'Đang thực hiện',
                ),
                const SizedBox(height: 16),
                _buildProgressPhase(
                  'Phát triển ứng dụng',
                  0.4,
                  AppColors.warning,
                  'Đang thực hiện',
                ),
                const SizedBox(height: 16),
                _buildProgressPhase(
                  'Kiểm thử & Triển khai',
                  0.1,
                  AppColors.error,
                  'Chưa bắt đầu',
                ),
                const SizedBox(height: 16),
                _buildProgressPhase(
                  'Hoàn thiện báo cáo',
                  0.2,
                  AppColors.error,
                  'Đang chuẩn bị',
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Milestone quan trọng
          const Text(
            'Milestone quan trọng',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          
          ModernCard(
            child: Column(
              children: [                _buildMilestone(
                  'Báo cáo tiến độ tháng 1',
                  '15/01/2025',
                  true,
                  AppColors.primary,
                ),
                const Divider(),
                _buildMilestone(
                  'Demo sản phẩm lần 1',
                  '28/02/2025',
                  false,
                  AppColors.warning,
                ),
                const Divider(),
                _buildMilestone(
                  'Nộp báo cáo hoàn thiện',
                  '15/04/2025',
                  false,
                  AppColors.info,
                ),
                const Divider(),
                _buildMilestone(
                  'Bảo vệ khóa luận',
                  '30/05/2025',
                  false,
                  AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressPhase(String title, double progress, Color color, String status) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            StatusBadge(
              text: status,
              color: color,
            ),
          ],
        ),
        const SizedBox(height: 8),
        ProgressIndicatorWidget(
          progress: progress,
          color: color,
          showPercentage: true,
          height: 8,
        ),
      ],
    );
  }

  Widget _buildMilestone(String title, String date, bool isCompleted, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isCompleted ? color : Colors.transparent,
              border: Border.all(color: color, width: 2),
              shape: BoxShape.circle,
            ),
            child: isCompleted
                ? Icon(Icons.check, color: Colors.white, size: 12)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted ? Colors.grey[600] : Colors.black87,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (isCompleted)
            Icon(Icons.check_circle, color: color, size: 20),
        ],
      ),
    );
  }
}
