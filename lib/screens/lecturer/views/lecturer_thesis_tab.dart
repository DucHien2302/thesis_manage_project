import 'package:flutter/material.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/widgets/modern_card.dart';
import 'package:thesis_manage_project/widgets/ui_components.dart';

class LecturerThesisTab extends StatelessWidget {
  const LecturerThesisTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientCard(
            gradientColors: [
              AppColors.primary.withOpacity(0.8),
              AppColors.primary,
            ],
            child: Row(
              children: [
                Icon(Icons.book, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Quản lý đề tài',
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
          
          // Thống kê đề tài
          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.assignment,
                  title: 'Tổng đề tài',
                  value: '23',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  icon: Icons.pending_actions,
                  title: 'Đang thực hiện',
                  value: '8',
                  color: AppColors.warning,
                ),
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
                  icon: const Icon(Icons.add),
                  label: const Text('Tạo đề tài mới'),
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
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Danh sách đề tài
          const Text(
            'Danh sách đề tài',
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
                _buildThesisItem(
                  'Phát triển ứng dụng di động quản lý khóa luận',
                  'Nguyễn Văn A - Trần Thị B',
                  AppColors.primary,
                  'Đang thực hiện',
                  '75%',
                ),
                const Divider(),
                _buildThesisItem(
                  'Hệ thống quản lý thư viện thông minh',
                  'Lê Văn C',
                  AppColors.warning,
                  'Chờ bảo vệ',
                  '95%',
                ),
                const Divider(),
                _buildThesisItem(
                  'Ứng dụng AI trong giáo dục',
                  'Phạm Thị D - Hoàng Văn E',
                  AppColors.info,
                  'Đang nghiên cứu',
                  '40%',
                ),
                const Divider(),
                _buildThesisItem(
                  'Website thương mại điện tử',
                  'Võ Thị F',
                  AppColors.error,
                  'Cần hỗ trợ',
                  '20%',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThesisItem(String title, String students, Color color, String status, String progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      students,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge(
                text: status,
                color: color,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tiến độ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      progress,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ProgressIndicatorWidget(
                  progress: double.parse(progress.replaceAll('%', '')) / 100,
                  color: color,
                  height: 6,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
