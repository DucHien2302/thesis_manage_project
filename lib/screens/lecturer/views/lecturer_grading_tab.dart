import 'package:flutter/material.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/widgets/modern_card.dart';

class LecturerGradingTab extends StatelessWidget {
  const LecturerGradingTab({super.key});

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
                Icon(Icons.assignment, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Chấm điểm khóa luận',
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
          
          // Thống kê chấm điểm
          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.pending,
                  title: 'Chờ chấm',
                  value: '5',
                  subtitle: 'Báo cáo',
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  icon: Icons.check_circle,
                  title: 'Đã chấm',
                  value: '18',
                  subtitle: 'Báo cáo',
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Báo cáo chờ chấm điểm
          const Text(
            'Báo cáo chờ chấm điểm',
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
                _buildGradingItem(
                  'Báo cáo tiến độ tháng 6',
                  'Nguyễn Văn A - Trần Thị B',
                  'Phát triển ứng dụng di động',
                  '22/06/2025',
                  AppColors.warning,
                  false,
                ),
                const Divider(),
                _buildGradingItem(
                  'Báo cáo hoàn thiện',
                  'Lê Văn C',
                  'Hệ thống quản lý thư viện',
                  '20/06/2025',
                  AppColors.error,
                  false,
                ),
                const Divider(),
                _buildGradingItem(
                  'Báo cáo chapter 3',
                  'Phạm Thị D - Hoàng Văn E',
                  'Ứng dụng AI trong giáo dục',
                  '21/06/2025',
                  AppColors.warning,
                  false,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Báo cáo đã chấm gần đây
          const Text(
            'Đã chấm gần đây',
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
                _buildGradingItem(
                  'Báo cáo tiến độ tháng 5',
                  'Võ Thị F',
                  'Website thương mại điện tử',
                  '18/06/2025',
                  AppColors.success,
                  true,
                  score: '8.5',
                ),
                const Divider(),
                _buildGradingItem(
                  'Báo cáo chapter 2',
                  'Nguyễn Văn G',
                  'Hệ thống IoT thông minh',
                  '17/06/2025',
                  AppColors.success,
                  true,
                  score: '7.8',
                ),
                const Divider(),
                _buildGradingItem(
                  'Báo cáo đề cương',
                  'Trần Thị H - Lê Văn I',
                  'Blockchain trong giáo dục',
                  '16/06/2025',
                  AppColors.success,
                  true,
                  score: '9.0',
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
                  icon: const Icon(Icons.rate_review),
                  label: const Text('Chấm điểm mới'),
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
                  icon: const Icon(Icons.history),
                  label: const Text('Lịch sử'),
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
  Widget _buildGradingItem(String reportTitle, String students, String thesis, String date, Color color, bool isGraded, {String? score}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Builder(
        builder: (context) => Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isGraded ? Icons.check_circle : Icons.pending,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reportTitle,
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
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    thesis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
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
                if (isGraded && score != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      score,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                ] else ...[
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tính năng đang phát triển')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Chấm',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
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
      ),
    );
  }
}
