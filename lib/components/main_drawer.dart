import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/components/permission_aware_widget.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/screens/auth/blocs/auth_bloc.dart';

class MainDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final VoidCallback onLogout;
  
  const MainDrawer({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.onLogout,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Get auth state for user info
    final authState = context.read<AuthBloc>().state;
    
    // Extract user info
    final Map<String, dynamic> userData = authState is Authenticated 
        ? authState.user 
        : {};
        
    final String userName = userData['user_name'] ?? 'Người dùng';
    final String userEmail = userData['email'] ?? '';
    final String userTypeName = userData['user_type_name'] ?? '';
    
    return Drawer(
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.05),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _buildUserHeader(userName, userEmail, userTypeName),
            
            const SizedBox(height: 8),
            
            // Dashboard - all users
            _buildDrawerItem(
              context,
              icon: Icons.dashboard_outlined,
              title: 'Tổng quan',
              subtitle: 'Dashboard chính',
              index: 0,
              isSelected: selectedIndex == 0,
            ),
            
            const Divider(height: 1, indent: 16, endIndent: 16),
              // Protected menu items
            PermissionAwareWidget(
              functionPath: FunctionPaths.thesisManagementPath,
              child: _buildDrawerItem(
                context,
                icon: Icons.book_outlined,
                title: 'Quản lý đề tài',
                subtitle: 'Danh sách đề tài',
                index: 1,
                isSelected: selectedIndex == 1,
              ),
            ),
            
            PermissionAwareWidget(
              functionPath: FunctionPaths.groupManagementPath,
              child: _buildDrawerItem(
                context,
                icon: Icons.group_outlined,
                title: 'Quản lý nhóm',
                subtitle: 'Thành viên nhóm',
                index: 2,
                isSelected: selectedIndex == 2,
              ),
            ),
            
            PermissionAwareWidget(
              functionPath: FunctionPaths.userManagementPath,
              child: _buildDrawerItem(
                context,
                icon: Icons.people_outlined,
                title: 'Quản lý người dùng',
                subtitle: 'Tài khoản hệ thống',
                index: 3,
                isSelected: selectedIndex == 3,
              ),
            ),
            
            PermissionAwareWidget(
              functionPath: FunctionPaths.reportPath,
              child: _buildDrawerItem(
                context,
                icon: Icons.assessment_outlined,
                title: 'Báo cáo',
                subtitle: 'Thống kê & báo cáo',
                index: 4,
                isSelected: selectedIndex == 4,
              ),
            ),
            
            const Divider(height: 1, indent: 16, endIndent: 16),
            
            // Profile - all users
            _buildDrawerItem(
              context,
              icon: Icons.person_outlined,
              title: 'Hồ sơ cá nhân',
              subtitle: 'Thông tin tài khoản',
              index: 5,
              isSelected: selectedIndex == 5,
            ),
            
            // Settings - all users
            _buildDrawerItem(
              context,
              icon: Icons.settings_outlined,
              title: 'Cài đặt',
              subtitle: 'Tùy chọn ứng dụng',
              index: 6,
              isSelected: selectedIndex == 6,
            ),
            
            const SizedBox(height: 20),
            
            // Debug section (only for admins in debug mode)
            if (kDebugMode) ...[
              PermissionAwareWidget(
                functionPath: FunctionPaths.debugPath,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                  ),
                  child: ExpansionTile(
                    leading: const Icon(Icons.bug_report, color: Colors.orange),
                    title: const Text(
                      'Công cụ Debug',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text('Chỉ trong môi trường phát triển'),
                    children: [
                      _buildDrawerItem(
                        context,
                        icon: Icons.api,
                        title: 'Test API',
                        subtitle: 'Kiểm tra kết nối API',
                        index: 100,
                        isSelected: selectedIndex == 100,
                        isDebugItem: true,
                      ),
                      _buildDrawerItem(
                        context,
                        icon: Icons.security,
                        title: 'Test Permission',
                        subtitle: 'Kiểm tra phân quyền',
                        index: 101,
                        isSelected: selectedIndex == 101,
                        isDebugItem: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 40),
            
            // Logout button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Đăng xuất'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  
  Widget _buildUserHeader(String name, String email, String userType) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getUserTypeIcon(userType),
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (email.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (userType.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    userType,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required int index,
    required bool isSelected,
    bool isDebugItem = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isSelected 
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.transparent,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppColors.primary.withValues(alpha: 0.2)
                : Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            color: isSelected 
                ? AppColors.primary
                : isDebugItem 
                    ? Colors.orange
                    : Colors.grey[600],
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected 
                ? AppColors.primary
                : isDebugItem 
                    ? Colors.orange
                    : Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        onTap: () {
          _navigateToPage(context, index);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
  
  IconData _getUserTypeIcon(String userType) {
    switch (userType.toLowerCase()) {
      case 'admin':
      case 'quản trị viên':
        return Icons.admin_panel_settings;
      case 'lecturer':
      case 'giảng viên':
        return Icons.school;
      case 'student':
      case 'sinh viên':
        return Icons.person;
      default:
        return Icons.account_circle;
    }
  }
  
  void _navigateToPage(BuildContext context, int index) {
    Navigator.pop(context); // Close drawer
    onItemTapped(index);
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
                Navigator.pop(context); // Close drawer
                onLogout();
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
}
