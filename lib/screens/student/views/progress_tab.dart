import 'package:flutter/material.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/widgets/modern_card.dart';
import 'package:thesis_manage_project/widgets/ui_components.dart';

class ProgressTab extends StatelessWidget {
  const ProgressTab({super.key});

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
                Icon(Icons.bar_chart, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Theo dõi tiến độ',
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
          
          // Tổng quan tiến độ
          StatCard(
            icon: Icons.timeline,
            title: 'Tiến độ tổng thể',
            value: '65%',
            subtitle: 'Đang đạt mục tiêu',
            color: AppColors.primary,
          ),
          
          const SizedBox(height: 20),
          
          const Text(
            'Chi tiết tiến độ từng giai đoạn',
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
                _buildProgressPhase(
                  'Nghiên cứu & Phân tích',
                  0.9,
                  AppColors.primary,
                  'Hoàn thành',
                ),
                const SizedBox(height: 16),
                _buildProgressPhase(
                  'Thiết kế hệ thống',
                  0.7,
                  AppColors.info,
                  'Đang thực hiện',
                ),
                const SizedBox(height: 16),
                _buildProgressPhase(
                  'Phát triển ứng dụng',
                  0.4,
                  AppColors.warning,
                  'Đang thực hiện',
                ),
                const SizedBox(height: 16),
                _buildProgressPhase(
                  'Kiểm thử & Triển khai',
                  0.1,
                  AppColors.error,
                  'Chưa bắt đầu',
                ),
                const SizedBox(height: 16),
                _buildProgressPhase(
                  'Hoàn thiện báo cáo',
                  0.2,
                  AppColors.error,
                  'Đang chuẩn bị',
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Milestone quan trọng
          const Text(
            'Milestone quan trọng',
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
                _buildMilestone(
                  'Báo cáo tiến độ tháng 1',
                  '15/01/2025',
                  true,
                  AppColors.primary,
                ),
                const Divider(),
                _buildMilestone(
                  'Demo sản phẩm lần 1',
                  '28/02/2025',
                  false,
                  AppColors.warning,
                ),
                const Divider(),
                _buildMilestone(
                  'Nộp báo cáo hoàn thiện',
                  '15/04/2025',
                  false,
                  AppColors.info,
                ),
                const Divider(),
                _buildMilestone(
                  'Bảo vệ khóa luận',
                  '30/05/2025',
                  false,
                  AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressPhase(String title, double progress, Color color, String status) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            StatusBadge(
              text: status,
              color: color,
            ),
          ],
        ),
        const SizedBox(height: 8),
        ProgressIndicatorWidget(
          progress: progress,
          color: color,
          showPercentage: true,
          height: 8,
        ),
      ],
    );
  }

  Widget _buildMilestone(String title, String date, bool isCompleted, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isCompleted ? color : Colors.transparent,
              border: Border.all(color: color, width: 2),
              shape: BoxShape.circle,
            ),
            child: isCompleted
                ? Icon(Icons.check, color: Colors.white, size: 12)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted ? Colors.grey[600] : Colors.black87,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (isCompleted)
            Icon(Icons.check_circle, color: color, size: 20),
        ],
      ),
    );
  }
}
