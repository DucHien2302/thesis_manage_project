import 'package:flutter/material.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/widgets/modern_card.dart';
import 'package:thesis_manage_project/widgets/ui_components.dart';

class AdminOverviewTab extends StatelessWidget {
  const AdminOverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
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
                        Icons.admin_panel_settings,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Quản trị hệ thống',
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
                    'Theo dõi và quản lý toàn bộ hệ thống quản lý khóa luận',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Thống kê tổng quan
            const Text(
              'Thống kê tổng quan',
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
                  icon: Icons.people,
                  title: 'Tổng người dùng',
                  value: '1,245',
                  subtitle: '+12 tuần này',
                  color: AppColors.primary,
                ),
                StatCard(
                  icon: Icons.school,
                  title: 'Sinh viên',
                  value: '1,089',
                  subtitle: 'Đang học',
                  color: AppColors.info,
                ),
                StatCard(
                  icon: Icons.person_4,
                  title: 'Giảng viên',
                  value: '156',
                  subtitle: 'Đang hoạt động',
                  color: AppColors.warning,
                ),
                StatCard(
                  icon: Icons.assignment,
                  title: 'Đề tài',
                  value: '234',
                  subtitle: 'Đang thực hiện',
                  color: AppColors.success,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
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
            
            ModernCard(
              child: Column(
                children: [
                  _buildActivityItem(
                    'Người dùng mới đăng ký',
                    'Nguyễn Văn A đã tạo tài khoản sinh viên',
                    '5 phút trước',
                    Icons.person_add,
                    AppColors.primary,
                  ),
                  const Divider(),
                  _buildActivityItem(
                    'Đề tài mới',
                    'GV. Trần Thị B đã tạo đề tài "AI trong giáo dục"',
                    '15 phút trước',
                    Icons.assignment_add,
                    AppColors.info,
                  ),
                  const Divider(),
                  _buildActivityItem(
                    'Báo cáo nộp',
                    'Sinh viên Lê Văn C đã nộp báo cáo tiến độ',
                    '30 phút trước',
                    Icons.upload_file,
                    AppColors.success,
                  ),
                  const Divider(),
                  _buildActivityItem(
                    'Hệ thống',
                    'Backup dữ liệu đã hoàn thành',
                    '2 giờ trước',
                    Icons.backup,
                    AppColors.warning,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Thống kê chi tiết
            const Text(
              'Thống kê chi tiết',
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
                  child: StatCard(
                    icon: Icons.trending_up,
                    title: 'Tăng trưởng',
                    value: '+15%',
                    subtitle: 'So với tháng trước',
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: StatCard(
                    icon: Icons.schedule,
                    title: 'Thời gian online',
                    value: '98.5%',
                    subtitle: 'Uptime hệ thống',
                    color: AppColors.primary,
                  ),
                ),
              ],
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
                    icon: Icons.person_add,
                    label: 'Thêm người dùng',
                    onPressed: () {
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
                    icon: Icons.backup,
                    label: 'Sao lưu',
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
                    icon: Icons.analytics,
                    label: 'Báo cáo',
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
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String description, String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
