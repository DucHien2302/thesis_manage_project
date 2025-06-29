import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/screens/auth/blocs/auth_bloc.dart';
import 'package:thesis_manage_project/screens/profile/profile_screen.dart';
import 'package:thesis_manage_project/screens/profile/bloc/profile_bloc.dart';
import 'package:thesis_manage_project/screens/lecturer/views/lecturer_overview_tab.dart';
import 'package:thesis_manage_project/screens/lecturer/views/lecturer_student_tab.dart';
import 'package:thesis_manage_project/screens/lecturer/views/lecturer_council_tab.dart';
import 'package:thesis_manage_project/screens/lecturer/views/lecturer_grading_tab.dart';

import 'views/lecturer_thesis_tab.dart';

/// Lecturer Dashboard - Giao diện dành cho Giảng viên
class LecturerDashboard extends StatefulWidget {
  const LecturerDashboard({Key? key}) : super(key: key);

  @override
  State<LecturerDashboard> createState() => _LecturerDashboardState();
}

class _LecturerDashboardState extends State<LecturerDashboard> {
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
      'icon': Icons.book_outlined,
      'activeIcon': Icons.book,
      'title': 'Đề tài',
      'pageTitle': 'Quản lý đề tài',
    },
    {
      'icon': Icons.group_outlined,
      'activeIcon': Icons.group,
      'title': 'Sinh viên',
      'pageTitle': 'Quản lý sinh viên',
    },
    {
      'icon': Icons.people_outlined,
      'activeIcon': Icons.people,
      'title': 'Hội đồng',
      'pageTitle': 'Hội đồng',
    },
    {
      'icon': Icons.assignment_outlined,
      'activeIcon': Icons.assignment,
      'title': 'Chấm điểm',
      'pageTitle': 'Chấm điểm',
    },
    {
      'icon': Icons.person_outlined,
      'activeIcon': Icons.person,
      'title': 'Hồ sơ',
      'pageTitle': 'Hồ sơ',
    },
  ];
  @override
  void initState() {
    super.initState();
    // Load profile data after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileData();
    });
  }

  void _loadProfileData() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      final userType = authState.user['user_type'] ?? 0;
      final userId = authState.user['id'] ?? '';
      
      // Only load if we're dealing with a lecturer
      if (userType == AppConfig.userTypeLecturer) {
        context.read<ProfileBloc>().add(LoadProfile(
          userType: userType,
          userId: userId,
        ));
      }
    }
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
  }

  void _showLecturerQuickInfo(BuildContext context, dynamic lecturerProfile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.info),
            const SizedBox(width: 8),
            const Text('Thông tin giảng viên'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Họ tên', '${lecturerProfile.information.firstName} ${lecturerProfile.information.lastName}'),
            _buildInfoRow('Mã GV', lecturerProfile.lecturerInfo.lecturerCode),
            _buildInfoRow('Khoa', lecturerProfile.lecturerInfo.departmentName ?? 'Chưa cập nhật'),
            _buildInfoRow('Chức danh', lecturerProfile.lecturerInfo.title.isNotEmpty ? lecturerProfile.lecturerInfo.title : 'Chưa cập nhật'),
            _buildInfoRow('Email', lecturerProfile.lecturerInfo.email.isNotEmpty ? lecturerProfile.lecturerInfo.email : 'Chưa cập nhật'),
            _buildInfoRow('Điện thoại', lecturerProfile.information.telPhone.isNotEmpty ? lecturerProfile.information.telPhone : 'Chưa cập nhật'),
            _buildInfoRow('Địa chỉ', lecturerProfile.information.address.isNotEmpty ? lecturerProfile.information.address : 'Chưa cập nhật'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentIndex = 5; // Navigate to profile page
                _currentPageTitle = 'Hồ sơ';
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.info,
              foregroundColor: Colors.white,
            ),
            child: const Text('Xem chi tiết'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        // Log state changes for debugging
        if (state is ProfileLoaded) {
          print('[LecturerDashboard] Profile loaded: ${state.lecturerProfile?.information.firstName} ${state.lecturerProfile?.information.lastName}');
        } else if (state is ProfileError) {
          print('[LecturerDashboard] Profile error: ${state.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi tải thông tin: ${state.message}'),
              backgroundColor: AppColors.error,
              action: SnackBarAction(
                label: 'Thử lại',
                onPressed: _loadProfileData,
              ),
            ),
          );
        } else if (state is ProfileLoading) {
          print('[LecturerDashboard] Profile loading...');
        }
      },
      child: Scaffold(
      appBar: AppBar(
        title: Text(_currentPageTitle),
        backgroundColor: AppColors.info,
        foregroundColor: Colors.white,
        elevation: 4,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.info, AppColors.info.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Refresh profile data when opening drawer
              _loadProfileData();
              Scaffold.of(context).openDrawer();
            },
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
      ),
      floatingActionButton: _currentIndex == 0 
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
                        child: const Text('Tạo đề tài'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Tạo mới'),
              backgroundColor: AppColors.info,
              foregroundColor: Colors.white,            )
          : null,
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [          // Drawer Header với thông tin từ API
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, profileState) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.info, AppColors.info.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: GestureDetector(
                    onLongPress: () {
                      if (profileState is ProfileLoaded && profileState.lecturerProfile != null) {
                        _showLecturerQuickInfo(context, profileState.lecturerProfile!);
                      }
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              child: profileState is ProfileLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.info),
                                      ),
                                    )
                                  : Icon(
                                      Icons.school,
                                      size: 32,
                                      color: AppColors.info,
                                    ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (profileState is ProfileLoaded && profileState.lecturerProfile != null) ...[
                                    Text(
                                      '${profileState.lecturerProfile!.information.firstName} ${profileState.lecturerProfile!.information.lastName}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'GV: ${profileState.lecturerProfile!.lecturerInfo.lecturerCode}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      profileState.lecturerProfile!.lecturerInfo.departmentName ?? 'Chưa cập nhật khoa',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white.withOpacity(0.9),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ] else if (profileState is ProfileLoading) ...[
                                    const Text(
                                      'Đang tải thông tin...',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Vui lòng chờ',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                    ),
                                  ] else if (profileState is ProfileError) ...[
                                    const Text(
                                      'Lỗi tải thông tin',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Nhấn để thử lại',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                    ),
                                  ] else ...[
                                    const Text(
                                      'Giảng viên',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Chưa có thông tin',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        // Add a refresh button if there's an error
                        if (profileState is ProfileError) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton.icon(
                              onPressed: _loadProfileData,
                              icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
                              label: const Text(
                                'Tải lại thông tin',
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                        
                        // Hint for long press
                        if (profileState is ProfileLoaded && profileState.lecturerProfile != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Nhấn giữ để xem thông tin chi tiết',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.7),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
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
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isSelected ? AppColors.info.withOpacity(0.1) : null,
                  ),
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Icon(
                      isSelected ? item['activeIcon'] : item['icon'],
                      size: 22,
                      color: isSelected ? AppColors.info : Colors.grey[600],
                    ),
                    title: Text(
                      item['title'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppColors.info : Colors.grey[800],
                      ),
                    ),
                    onTap: () {
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
              _showLogoutDialog(context);            },
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return const LecturerOverviewTab();
      case 1:
        return const LecturerThesisTab();
      case 2:
        return const LecturerStudentTab();
      case 3:
        return const LecturerCouncilTab();
      case 4:
        return const LecturerGradingTab();
      case 5:
        return const ProfileScreen();
      default:
        return const LecturerOverviewTab();
    }
  }
}
