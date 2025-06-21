import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/screens/auth/blocs/auth_bloc.dart';
import 'package:thesis_manage_project/screens/profile/profile_screen.dart';
import 'package:thesis_manage_project/screens/profile/bloc/profile_bloc.dart';
import 'package:thesis_manage_project/screens/lecturer/views/lecturer_overview_tab.dart';
import 'package:thesis_manage_project/screens/lecturer/views/lecturer_thesis_tab.dart';
import 'package:thesis_manage_project/screens/lecturer/views/lecturer_student_tab.dart';
import 'package:thesis_manage_project/screens/lecturer/views/lecturer_council_tab.dart';
import 'package:thesis_manage_project/screens/lecturer/views/lecturer_grading_tab.dart';

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
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated) {
        // Reset ProfileBloc state first, then load new profile
        final profileBloc = context.read<ProfileBloc>();
        profileBloc.add(LoadProfile(
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              foregroundColor: Colors.white,
            )
          : null,
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header với thông tin từ API
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
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 28,
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'GV: ${profileState.lecturerProfile!.lecturerInfo.lecturerCode}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 1),                              Text(
                                profileState.lecturerProfile!.lecturerInfo.departmentName ?? 'Chưa cập nhật khoa',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
