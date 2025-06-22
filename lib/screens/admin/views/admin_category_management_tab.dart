import 'package:flutter/material.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/widgets/modern_card.dart';
import 'package:thesis_manage_project/widgets/ui_components.dart';

class AdminCategoryManagementTab extends StatelessWidget {
  const AdminCategoryManagementTab({super.key});

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
                Icon(Icons.category, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Quản lý danh mục',
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
          
          // Thống kê danh mục
          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.school,
                  title: 'Khoa/Ngành',
                  value: '12',
                  subtitle: 'Danh mục',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  icon: Icons.topic,
                  title: 'Chủ đề',
                  value: '45',
                  subtitle: 'Đề tài',
                  color: AppColors.info,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Quản lý khoa/ngành
          const Text(
            'Quản lý khoa/ngành',
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
                _buildCategoryItem(
                  'Khoa Công nghệ thông tin',
                  'Công nghệ phần mềm, An toàn thông tin, Khoa học máy tính',
                  '156 sinh viên',
                  AppColors.primary,
                ),
                const Divider(),
                _buildCategoryItem(
                  'Khoa Kinh tế',
                  'Quản trị kinh doanh, Tài chính ngân hàng, Marketing',
                  '234 sinh viên',
                  AppColors.info,
                ),
                const Divider(),
                _buildCategoryItem(
                  'Khoa Kỹ thuật',
                  'Kỹ thuật điện, Kỹ thuật cơ khí, Kỹ thuật xây dựng',
                  '189 sinh viên',
                  AppColors.warning,
                ),
                const Divider(),
                _buildCategoryItem(
                  'Khoa Ngoại ngữ',
                  'Tiếng Anh, Tiếng Trung, Tiếng Nhật',
                  '123 sinh viên',
                  AppColors.success,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Chủ đề đề tài
          const Text(
            'Chủ đề đề tài',
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
                _buildTopicItem('Trí tuệ nhân tạo', '23 đề tài', AppColors.primary),
                const Divider(),
                _buildTopicItem('Phát triển ứng dụng', '18 đề tài', AppColors.info),
                const Divider(),
                _buildTopicItem('An toàn thông tin', '12 đề tài', AppColors.warning),
                const Divider(),
                _buildTopicItem('IoT và Smart City', '15 đề tài', AppColors.success),
                const Divider(),
                _buildTopicItem('Blockchain', '8 đề tài', AppColors.accent),
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
                  label: const Text('Thêm danh mục'),
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
                  icon: const Icon(Icons.edit),
                  label: const Text('Chỉnh sửa'),
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
  Widget _buildCategoryItem(String name, String majors, String studentCount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.school, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  majors,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  studentCount,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tính năng đang phát triển')),
                );
              },
              icon: const Icon(Icons.more_vert),
              iconSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicItem(String topic, String count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
              topic,
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
