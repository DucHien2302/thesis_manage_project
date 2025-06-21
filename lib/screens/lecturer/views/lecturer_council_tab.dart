import 'package:flutter/material.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/widgets/modern_card.dart';

class LecturerCouncilTab extends StatelessWidget {
  const LecturerCouncilTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientCard(
            gradientColors: [
              AppColors.accent.withOpacity(0.8),
              AppColors.accent,
            ],
            child: Row(
              children: [
                Icon(Icons.people, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Hội đồng đánh giá',
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
          
          // Thống kê hội đồng
          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.groups,
                  title: 'Hội đồng',
                  value: '3',
                  subtitle: 'Đang tham gia',
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  icon: Icons.event,
                  title: 'Lịch bảo vệ',
                  value: '5',
                  subtitle: 'Tuần này',
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Hội đồng đang tham gia
          const Text(
            'Hội đồng đang tham gia',
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
                _buildCouncilItem(
                  'Hội đồng Khoa học máy tính K65',
                  'Chủ tịch',
                  '5 đề tài',
                  '25/06/2025',
                  AppColors.primary,
                ),
                const Divider(),
                _buildCouncilItem(
                  'Hội đồng Công nghệ thông tin K65',
                  'Ủy viên',
                  '8 đề tài',
                  '28/06/2025',
                  AppColors.info,
                ),
                const Divider(),
                _buildCouncilItem(
                  'Hội đồng An toàn thông tin K65',
                  'Thư ký',
                  '3 đề tài',
                  '02/07/2025',
                  AppColors.warning,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Lịch bảo vệ sắp tới
          const Text(
            'Lịch bảo vệ sắp tới',
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
                _buildScheduleItem(
                  'Nguyễn Văn A - Trần Thị B',
                  'Phát triển ứng dụng di động',
                  '09:00 - 09:30',
                  '25/06/2025',
                  AppColors.primary,
                ),
                const Divider(),
                _buildScheduleItem(
                  'Lê Văn C',
                  'Hệ thống quản lý thư viện',
                  '09:30 - 10:00',
                  '25/06/2025',
                  AppColors.primary,
                ),
                const Divider(),
                _buildScheduleItem(
                  'Phạm Thị D - Hoàng Văn E',
                  'Ứng dụng AI trong giáo dục',
                  '10:00 - 10:30',
                  '25/06/2025',
                  AppColors.primary,
                ),
                const Divider(),
                _buildScheduleItem(
                  'Võ Thị F',
                  'Website thương mại điện tử',
                  '14:00 - 14:30',
                  '28/06/2025',
                  AppColors.info,
                ),
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
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Xem lịch đầy đủ'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
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
                  icon: const Icon(Icons.notifications),
                  label: const Text('Thông báo'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accent,
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

  Widget _buildCouncilItem(String name, String role, String thesisCount, String date, Color color) {
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
            child: Icon(Icons.groups, color: color, size: 20),
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
                Row(
                  children: [
                    Text(
                      role,
                      style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• $thesisCount',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            date,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(String students, String thesis, String time, String date, Color color) {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  students,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  thesis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
