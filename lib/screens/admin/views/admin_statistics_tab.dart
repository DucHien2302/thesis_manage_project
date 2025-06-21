import 'package:flutter/material.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/widgets/modern_card.dart';
import 'package:thesis_manage_project/widgets/ui_components.dart';

class AdminStatisticsTab extends StatelessWidget {
  const AdminStatisticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientCard(
            gradientColors: [
              AppColors.info.withOpacity(0.8),
              AppColors.info,
            ],
            child: Row(
              children: [
                Icon(Icons.assessment, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Thống kê báo cáo',
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
          
          // Thống kê theo thời gian
          const Text(
            'Thống kê theo thời gian',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.today,
                  title: 'Hôm nay',
                  value: '45',
                  subtitle: 'Hoạt động',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  icon: Icons.date_range,
                  title: 'Tuần này',
                  value: '289',
                  subtitle: 'Hoạt động',
                  color: AppColors.info,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 10),
          
          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.calendar_month,
                  title: 'Tháng này',
                  value: '1,234',
                  subtitle: 'Hoạt động',
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  icon: Icons.analytics,
                  title: 'Năm nay',
                  value: '15,678',
                  subtitle: 'Hoạt động',
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Thống kê đề tài
          const Text(
            'Thống kê đề tài',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          
          ModernCard(
            child: Column(
              children: [
                _buildStatItem(
                  'Đề tài hoàn thành',
                  '156',
                  AppColors.success,
                  '+12 tháng này',
                ),
                const Divider(),
                _buildStatItem(
                  'Đang thực hiện',
                  '234',
                  AppColors.primary,
                  '+8 tuần này',
                ),
                const Divider(),
                _buildStatItem(
                  'Chờ bảo vệ',
                  '45',
                  AppColors.warning,
                  '+5 tuần này',
                ),
                const Divider(),
                _buildStatItem(
                  'Bị hủy/Hoãn',
                  '12',
                  AppColors.error,
                  '+2 tháng này',
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Top khoa/ngành
          const Text(
            'Top khoa/ngành hoạt động',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          
          ModernCard(
            child: Column(
              children: [
                _buildRankingItem(1, 'Khoa Công nghệ thông tin', '89 đề tài', AppColors.primary),
                const Divider(),
                _buildRankingItem(2, 'Khoa Kinh tế', '67 đề tài', AppColors.info),
                const Divider(),
                _buildRankingItem(3, 'Khoa Kỹ thuật', '45 đề tài', AppColors.warning),
                const Divider(),
                _buildRankingItem(4, 'Khoa Ngoại ngữ', '23 đề tài', AppColors.success),
                const Divider(),
                _buildRankingItem(5, 'Khoa Toán - Lý', '18 đề tài', AppColors.accent),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Thống kê người dùng
          const Text(
            'Thống kê người dùng',
            style: TextStyle(
              fontSize: 18,
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
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              StatCard(
                icon: Icons.login,
                title: 'Đăng nhập',
                value: '2,456',
                subtitle: 'Hôm nay',
                color: AppColors.primary,
              ),
              StatCard(
                icon: Icons.person_add,
                title: 'Đăng ký mới',
                value: '23',
                subtitle: 'Tuần này',
                color: AppColors.success,
              ),
              StatCard(
                icon: Icons.access_time,
                title: 'Online',
                value: '189',
                subtitle: 'Hiện tại',
                color: AppColors.info,
              ),
              StatCard(
                icon: Icons.block,
                title: 'Bị khóa',
                value: '5',
                subtitle: 'Tài khoản',
                color: AppColors.error,
              ),
            ],
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
                  icon: const Icon(Icons.file_download),
                  label: const Text('Xuất báo cáo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.info,
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
                  icon: const Icon(Icons.refresh),
                  label: const Text('Làm mới'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.info,
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

  Widget _buildStatItem(String title, String value, Color color, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
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
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRankingItem(int rank, String faculty, String count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              faculty,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          StatusBadge(
            text: count,
            color: color,
          ),
        ],
      ),
    );
  }
}
