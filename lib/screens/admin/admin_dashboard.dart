import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/screens/auth/blocs/auth_bloc.dart';
import 'package:thesis_manage_project/screens/admin/views/admin_overview_tab.dart';
import 'package:thesis_manage_project/screens/admin/views/admin_user_management_tab.dart';
import 'package:thesis_manage_project/screens/admin/views/admin_category_management_tab.dart';
import 'package:thesis_manage_project/screens/admin/views/admin_statistics_tab.dart';
import 'package:thesis_manage_project/screens/admin/views/admin_system_settings_tab.dart';

/// Admin Dashboard - Giao diện dành cho Quản trị viên
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;
  String _currentPageTitle = 'Tổng quan hệ thống';

  final List<Map<String, dynamic>> _menuItems = [
    {
      'icon': Icons.dashboard_outlined,
      'activeIcon': Icons.dashboard,
      'title': 'Tổng quan',
      'pageTitle': 'Tổng quan hệ thống',
    },
    {
      'icon': Icons.people_outlined,
      'activeIcon': Icons.people,
      'title': 'Người dùng',
      'pageTitle': 'Quản lý người dùng',
    },
    {
      'icon': Icons.category_outlined,
      'activeIcon': Icons.category,
      'title': 'Danh mục',
      'pageTitle': 'Quản lý danh mục',
    },
    {
      'icon': Icons.assessment_outlined,
      'activeIcon': Icons.assessment,
      'title': 'Thống kê',
      'pageTitle': 'Thống kê báo cáo',
    },
    {
      'icon': Icons.settings_outlined,
      'activeIcon': Icons.settings,
      'title': 'Hệ thống',
      'pageTitle': 'Cài đặt hệ thống',
    },
  ];

  @override
  void initState() {
    super.initState();
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
      ),
      floatingActionButton:
          _currentIndex == 0
              ? FloatingActionButton.extended(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: const Text('Quản trị'),
                          content: const Text('Chọn tác vụ quản trị?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Hủy'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Tính năng đang phát triển'),
                                  ),
                                );
                              },
                              child: const Text('Tạo mới'),
                            ),
                          ],
                        ),
                  );
                },
                icon: const Icon(Icons.admin_panel_settings),
                label: const Text('Quản trị'),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              )
              : null,
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header với chiều cao linh hoạt
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
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
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.admin_panel_settings,
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
                        const Text(
                          'Quản trị viên',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Hệ thống quản lý',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color:
                        isSelected ? AppColors.primary.withOpacity(0.1) : null,
                  ),
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    leading: Icon(
                      isSelected ? item['activeIcon'] : item['icon'],
                      size: 22,
                      color: isSelected ? AppColors.primary : Colors.grey[600],
                    ),
                    title: Text(
                      item['title'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color:
                            isSelected ? AppColors.primary : Colors.grey[800],
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Icon(Icons.logout, color: AppColors.error, size: 22),
            title: Text(
              'Đăng xuất',
              style: TextStyle(fontSize: 14, color: AppColors.error),
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
        return const AdminOverviewTab();
      case 1:
        return const AdminUserManagementTab();
      case 2:
        return const AdminCategoryManagementTab();
      case 3:
        return const AdminStatisticsTab();
      case 4:
        return const AdminSystemSettingsTab();
      default:
        return const AdminOverviewTab();
    }
  }
}
