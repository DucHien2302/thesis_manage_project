import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/screens/auth/blocs/auth_bloc.dart';
import 'package:thesis_manage_project/screens/profile/profile_screen.dart';
import 'package:thesis_manage_project/screens/profile/bloc/profile_bloc.dart';

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
  ];  @override
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
      body: AnimatedSwitcher(        duration: const Duration(milliseconds: 300),
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
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.school,
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
                                'MSGV: ${profileState.lecturerProfile!.lecturerInfo.lecturerCode}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                profileState.lecturerProfile!.lecturerInfo.departmentName ?? 'Chưa cập nhật khoa',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ] else if (profileState is ProfileError) ...[
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
                                'Lỗi tải thông tin',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 2,
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
        return _buildOverviewTab();
      case 1:
        return _buildThesisManagementTab();
      case 2:
        return _buildStudentManagementTab();
      case 3:
        return _buildCommitteeTab();
      case 4:
        return _buildGradingTab();
      case 5:
        return const ProfileScreen();
      default:
        return _buildOverviewTab();
    }
  }
  // Tab 1: Tổng quan
  Widget _buildOverviewTab() {
    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Implement refresh logic
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.info.withOpacity(0.8),
                    AppColors.info,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.info.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
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
                          'Chào mừng Giảng viên!',
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
                    'Quản lý và hướng dẫn sinh viên thực hiện khóa luận',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
          
            // Thống kê nhanh
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.analytics_outlined, color: AppColors.primary),
                      const SizedBox(width: 8),
                      const Text(
                        'Thống kê tổng quan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.3,
                    children: [
                      _buildModernStatCard('Đề tài hướng dẫn', '8', Icons.book, AppColors.primary),
                      _buildModernStatCard('Sinh viên', '24', Icons.school, AppColors.success),
                      _buildModernStatCard('Hội đồng tham gia', '3', Icons.people, AppColors.info),
                      _buildModernStatCard('Chờ chấm điểm', '5', Icons.assignment, AppColors.warning),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Lịch họp sắp tới
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, color: AppColors.info),
                      const SizedBox(width: 8),
                      const Text(
                        'Lịch họp sắp tới',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildModernMeetingItem('Họp hướng dẫn nhóm ABC', 'Hôm nay 14:00', 'Phòng 301', AppColors.primary),
                  const SizedBox(height: 12),
                  _buildModernMeetingItem('Bảo vệ đề cương nhóm XYZ', 'Ngày mai 09:00', 'Hội trường A', AppColors.success),
                  const SizedBox(height: 12),
                  _buildModernMeetingItem('Họp hội đồng chấm', '25/06 10:00', 'Phòng họp khoa', AppColors.warning),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Nhiệm vụ cần làm
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.task_alt_outlined, color: AppColors.error),
                      const SizedBox(width: 8),
                      const Text(
                        'Nhiệm vụ cần hoàn thành',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),                  const SizedBox(height: 16),
                  _buildModernTaskItem('Phê duyệt đề cương nhóm ABC', 'Hạn: 20/06', false, AppColors.warning),
                  const SizedBox(height: 8),
                  _buildModernTaskItem('Chấm điểm báo cáo tiến độ', 'Hạn: 22/06', false, AppColors.info),
                  const SizedBox(height: 8),
                  _buildModernTaskItem('Đánh giá kết quả nhóm XYZ', 'Hạn: 25/06', true, AppColors.success),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Tab 2: Quản lý đề tài
  Widget _buildThesisManagementTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quản lý đề tài',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showCreateThesisDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Tạo đề tài mới'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Bộ lọc
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm đề tài...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              DropdownButton<String>(
                value: 'all',
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('Tất cả')),
                  DropdownMenuItem(value: 'active', child: Text('Đang thực hiện')),
                  DropdownMenuItem(value: 'completed', child: Text('Hoàn thành')),
                  DropdownMenuItem(value: 'pending', child: Text('Chờ phê duyệt')),
                ],
                onChanged: (value) {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Danh sách đề tài
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            itemBuilder: (context, index) {
              return _buildThesisCard(index);
            },
          ),
        ],
      ),
    );
  }

  // Tab 3: Quản lý sinh viên
  Widget _buildStudentManagementTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sinh viên hướng dẫn',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          
          // Thống kê sinh viên
          Row(
            children: [
              Expanded(
                child: Card(
                  color: AppColors.success.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          '24',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                        const Text('Tổng sinh viên'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card(
                  color: AppColors.warning.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          '6',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.warning,
                          ),
                        ),
                        const Text('Nhóm hướng dẫn'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Danh sách nhóm sinh viên
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            itemBuilder: (context, index) {
              return _buildStudentGroupCard(index);
            },
          ),
        ],
      ),
    );
  }

  // Tab 4: Hội đồng chấm
  Widget _buildCommitteeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Hội đồng chấm',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showCreateCommitteeDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Tạo hội đồng'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Các hội đồng
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return _buildCommitteeCard(index);
            },
          ),
        ],
      ),
    );
  }

  // Tab 5: Chấm điểm
  Widget _buildGradingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chấm điểm sinh viên',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          
          // Bộ lọc chấm điểm
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Loại điểm'),
                      items: const [
                        DropdownMenuItem(value: 'progress', child: Text('Điểm tiến độ')),
                        DropdownMenuItem(value: 'presentation', child: Text('Điểm thuyết trình')),
                        DropdownMenuItem(value: 'final', child: Text('Điểm tổng kết')),
                        DropdownMenuItem(value: 'committee', child: Text('Điểm hội đồng')),
                      ],
                      onChanged: (value) {},
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Học kỳ'),
                      items: const [
                        DropdownMenuItem(value: '1', child: Text('Học kỳ 1 - 2024-2025')),
                        DropdownMenuItem(value: '2', child: Text('Học kỳ 2 - 2024-2025')),
                      ],
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Danh sách sinh viên cần chấm điểm
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 8,
            itemBuilder: (context, index) {
              return _buildGradingCard(index);
            },
          ),
        ],
      ),
    );  }

  // Helper widgets - Modern UI components
  Widget _buildModernStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildModernMeetingItem(String title, String time, String location, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.schedule, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$time - $location',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: color,
          ),
        ],
      ),
    );
  }

  Widget _buildModernTaskItem(String title, String deadline, bool isCompleted, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.green.withOpacity(0.1) : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCompleted ? Colors.green.withOpacity(0.2) : color.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isCompleted ? Colors.green : color,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              isCompleted ? Icons.check : Icons.pending,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted ? Colors.grey : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  deadline,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (!isCompleted)
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: color,
            ),
        ],
      ),
    );
  }

  Widget _buildThesisCard(int index) {
    final theses = [
      {
        'title': 'Xây dựng ứng dụng quản lý đề tài khóa luận',
        'group': 'Nhóm ABC',
        'students': 3,
        'status': 'Đang thực hiện',
        'progress': 0.65,
      },
      {
        'title': 'Nghiên cứu thuật toán machine learning',
        'group': 'Nhóm XYZ',
        'students': 2,
        'status': 'Chờ phê duyệt',
        'progress': 0.2,
      },
      {
        'title': 'Phát triển hệ thống IoT thông minh',
        'group': 'Nhóm DEF',
        'students': 4,
        'status': 'Hoàn thành',
        'progress': 1.0,
      },
    ];
    
    final thesis = theses[index % theses.length];
    Color statusColor = thesis['status'] == 'Hoàn thành' 
        ? AppColors.success 
        : thesis['status'] == 'Đang thực hiện' 
            ? AppColors.primary 
            : AppColors.warning;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    thesis['title'] as String,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    thesis['status'] as String,
                    style: TextStyle(color: statusColor, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('${thesis['group']} - ${thesis['students']} sinh viên'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: thesis['progress'] as double,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  ),
                ),
                const SizedBox(width: 8),
                Text('${((thesis['progress'] as double) * 100).toInt()}%'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.visibility),
                  label: const Text('Xem chi tiết'),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat),
                  label: const Text('Nhắn tin'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentGroupCard(int index) {
    final groups = [
      {'name': 'Nhóm ABC', 'members': ['Nguyễn Văn A', 'Trần Thị B', 'Lê Văn C'], 'thesis': 'Ứng dụng quản lý'},
      {'name': 'Nhóm XYZ', 'members': ['Phạm Thị D', 'Hoàng Văn E'], 'thesis': 'Machine Learning'},
      {'name': 'Nhóm DEF', 'members': ['Đỗ Văn F', 'Ngô Thị G', 'Vũ Văn H', 'Bùi Thị I'], 'thesis': 'IoT System'},
    ];
    
    final group = groups[index % groups.length];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  group['name'] as String,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${(group['members'] as List).length} thành viên',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Đề tài: ${group['thesis']}',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: (group['members'] as List<String>).map((member) {
                return Chip(
                  label: Text(member, style: const TextStyle(fontSize: 12)),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.message),
                  label: const Text('Nhắn tin'),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.assignment),
                  label: const Text('Giao việc'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommitteeCard(int index) {
    final committees = [
      {'name': 'Hội đồng 1', 'chair': 'PGS.TS Nguyễn Văn X', 'members': 3, 'theses': 2},
      {'name': 'Hội đồng 2', 'chair': 'TS. Trần Thị Y', 'members': 5, 'theses': 4},
      {'name': 'Hội đồng 3', 'chair': 'PGS.TS Lê Văn Z', 'members': 4, 'theses': 3},
    ];
    
    final committee = committees[index % committees.length];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              committee['name'] as String,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Chủ tịch: ${committee['chair']}'),
            Text('${committee['members']} thành viên - ${committee['theses']} đề tài'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.people),
                  label: const Text('Thành viên'),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.schedule),
                  label: const Text('Lịch chấm'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradingCard(int index) {
    final students = [
      {'name': 'Nguyễn Văn A', 'id': '20194001', 'thesis': 'Ứng dụng quản lý', 'type': 'Điểm tiến độ'},
      {'name': 'Trần Thị B', 'id': '20194002', 'thesis': 'Machine Learning', 'type': 'Điểm thuyết trình'},
      {'name': 'Lê Văn C', 'id': '20194003', 'thesis': 'IoT System', 'type': 'Điểm tổng kết'},
    ];
    
    final student = students[index % students.length];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student['name'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('MSSV: ${student['id']}'),
                  Text('Đề tài: ${student['thesis']}'),
                  Text('Loại: ${student['type']}'),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const Text('Điểm'),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 80,
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '0.0',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.save, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog methods
  void _showCreateThesisDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tạo đề tài mới'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Tên đề tài'),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(labelText: 'Mô tả'),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Loại đề tài'),
                  items: const [
                    DropdownMenuItem(value: 'capstone', child: Text('Đồ án tốt nghiệp')),
                    DropdownMenuItem(value: 'thesis', child: Text('Khóa luận tốt nghiệp')),
                  ],
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(labelText: 'Số lượng sinh viên tối đa'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tạo'),
            ),
          ],
        );
      },
    );
  }

  void _showCreateCommitteeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tạo hội đồng mới'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Tên hội đồng'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Chủ tịch hội đồng'),
                items: const [
                  DropdownMenuItem(value: 'lecturer1', child: Text('PGS.TS Nguyễn Văn X')),
                  DropdownMenuItem(value: 'lecturer2', child: Text('TS. Trần Thị Y')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(labelText: 'Thành viên (cách nhau bởi dấu phẩy)'),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tạo'),
            ),
          ],
        );      },
    );
  }
}
