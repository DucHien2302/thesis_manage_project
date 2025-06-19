import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/screens/auth/blocs/auth_bloc.dart';
import 'package:thesis_manage_project/screens/profile/profile_screen.dart';

/// Lecturer Dashboard - Giao diện dành cho Giảng viên
class LecturerDashboard extends StatefulWidget {
  const LecturerDashboard({Key? key}) : super(key: key);

  @override
  State<LecturerDashboard> createState() => _LecturerDashboardState();
}

class _LecturerDashboardState extends State<LecturerDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Add a listener to ensure tab controller updates the state
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final userData = authState is Authenticated ? authState.user : {};
    final userName = userData['user_name'] ?? 'Giảng viên';    return Scaffold(
      appBar: AppBar(
        title: Text('Giảng viên - $userName'),
        backgroundColor: AppColors.info,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showLogoutDialog(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),          tabs: const [
            Tab(icon: Icon(Icons.dashboard_outlined), text: 'Tổng quan'),
            Tab(icon: Icon(Icons.book_outlined), text: 'Đề tài'),
            Tab(icon: Icon(Icons.group_outlined), text: 'Sinh viên'),
            Tab(icon: Icon(Icons.people_outlined), text: 'Hội đồng'),
            Tab(icon: Icon(Icons.assignment_outlined), text: 'Chấm điểm'),
            Tab(icon: Icon(Icons.person_outlined), text: 'Hồ sơ'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,        children: [
          _buildOverviewTab(),
          _buildThesisManagementTab(),
          _buildStudentManagementTab(),
          _buildCommitteeTab(),
          _buildGradingTab(),
          Builder(builder: (context) {
            // Create the ProfileScreen with proper context
            return const ProfileScreen();
          }),
        ],
      ),
    );
  }

  // Tab 1: Tổng quan
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tổng quan công việc',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          
          // Thống kê nhanh
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard('Đề tài hướng dẫn', '8', Icons.book, AppColors.primary),
              _buildStatCard('Sinh viên', '24', Icons.school, AppColors.success),
              _buildStatCard('Hội đồng tham gia', '3', Icons.people, AppColors.info),
              _buildStatCard('Chờ chấm điểm', '5', Icons.assignment, AppColors.warning),
            ],
          ),
          
          const SizedBox(height: 30),
          
          // Lịch họp sắp tới
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lịch họp sắp tới',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildMeetingItem('Họp hướng dẫn nhóm ABC', 'Hôm nay 14:00', 'Phòng 301'),
                  _buildMeetingItem('Bảo vệ đề cương nhóm XYZ', 'Ngày mai 09:00', 'Hội trường A'),
                  _buildMeetingItem('Họp hội đồng chấm', '25/06 10:00', 'Phòng họp khoa'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Nhiệm vụ cần làm
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nhiệm vụ cần hoàn thành',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildTaskItem('Phê duyệt đề cương nhóm ABC', 'Hạn: 20/06', false),
                  _buildTaskItem('Chấm điểm báo cáo tiến độ', 'Hạn: 22/06', false),
                  _buildTaskItem('Đánh giá kết quả nhóm XYZ', 'Hạn: 25/06', true),
                ],
              ),
            ),
          ),
        ],
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
    );
  }

  // Helper widgets
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingItem(String title, String time, String location) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.schedule, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('$time - $location', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String title, String deadline, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Checkbox(
            value: isCompleted,
            onChanged: (value) {},
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                Text(deadline, style: const TextStyle(color: Colors.grey)),
              ],
            ),
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
        );
      },
    );
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
                context.read<AuthBloc>().add(const LogoutRequested());
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
