import 'package:flutter/material.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/widgets/modern_card.dart';
import 'package:thesis_manage_project/widgets/ui_components.dart';

class LecturerStudentTab extends StatelessWidget {
  const LecturerStudentTab({super.key});

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
                Icon(Icons.group, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Quản lý sinh viên',
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
          
          // Thống kê sinh viên
          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.people,
                  title: 'Tổng sinh viên',
                  value: '24',
                  color: AppColors.info,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  icon: Icons.group_work,
                  title: 'Số nhóm',
                  value: '12',
                  color: AppColors.primary,
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
                  icon: const Icon(Icons.add_circle),
                  label: const Text('Thêm sinh viên'),
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
                  icon: const Icon(Icons.search),
                  label: const Text('Tìm kiếm'),
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
          
          const SizedBox(height: 20),
          
          // Danh sách sinh viên
          const Text(
            'Sinh viên đang hướng dẫn',
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
                _buildStudentItem(
                  'Nguyễn Văn A',
                  '20210001',
                  'CNTT-K65',
                  'Phát triển ứng dụng di động',
                  AppColors.primary,
                  'Tốt',
                ),
                const Divider(),
                _buildStudentItem(
                  'Trần Thị B',
                  '20210002',
                  'CNTT-K65',
                  'Phát triển ứng dụng di động',
                  AppColors.primary,
                  'Tốt',
                ),
                const Divider(),
                _buildStudentItem(
                  'Lê Văn C',
                  '20210003',
                  'CNTT-K65',
                  'Hệ thống quản lý thư viện',
                  AppColors.warning,
                  'Trung bình',
                ),
                const Divider(),
                _buildStudentItem(
                  'Phạm Thị D',
                  '20210004',
                  'CNTT-K65',
                  'Ứng dụng AI trong giáo dục',
                  AppColors.info,
                  'Tốt',
                ),
                const Divider(),
                _buildStudentItem(
                  'Hoàng Văn E',
                  '20210005',
                  'CNTT-K65',
                  'Ứng dụng AI trong giáo dục',
                  AppColors.info,
                  'Tốt',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentItem(String name, String studentCode, String className, String thesis, Color color, String performance) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.2),
            child: Text(
              name.substring(0, 1),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
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
                const SizedBox(height: 2),
                Text(
                  '$studentCode - $className',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  thesis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          StatusBadge(
            text: performance,
            color: color,
          ),
        ],
      ),
    );
  }
}
