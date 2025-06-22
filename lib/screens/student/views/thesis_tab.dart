import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/screens/thesis_registration/thesis_registration.dart';
import 'package:thesis_manage_project/services/thesis_service.dart';
import 'package:thesis_manage_project/widgets/modern_card.dart';
import 'package:thesis_manage_project/models/profile_models.dart';

class ThesisTab extends StatelessWidget {
  final StudentFullProfileModel? student;
  
  const ThesisTab({
    super.key,
    this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          ModernCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.assignment, color: AppColors.info, size: 28),
                    const SizedBox(width: 12),
                    const Text(
                      'Quản lý đề tài',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tìm kiếm và đăng ký đề tài khóa luận tốt nghiệp',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
            // Main Action Cards
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9, // Giảm aspect ratio để tạo chiều cao hơn
              children: [
                _buildActionCard(
                  context,
                  title: 'Tìm đề tài',
                  subtitle: 'Tìm kiếm đề tài phù hợp',
                  icon: Icons.search,
                  color: AppColors.primary,
                  onTap: () => _navigateToThesisList(context),
                ),
                _buildActionCard(
                  context,
                  title: 'Đăng ký của tôi',
                  subtitle: 'Xem đăng ký hiện tại',
                  icon: Icons.list_alt,
                  color: AppColors.success,
                  onTap: () => _navigateToMyRegistrations(context),
                ),
                _buildActionCard(
                  context,
                  title: 'Hướng dẫn',
                  subtitle: 'Quy trình đăng ký',
                  icon: Icons.help_outline,
                  color: AppColors.warning,
                  onTap: () => _showGuideDialog(context),
                ),
                _buildActionCard(
                  context,
                  title: 'Thống kê',
                  subtitle: 'Tình hình đề tài',
                  icon: Icons.analytics,
                  color: AppColors.info,
                  onTap: () => _showStatsDialog(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ModernCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0), // Giảm padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Thêm mainAxisSize.min
            children: [
              Container(
                padding: const EdgeInsets.all(12), // Giảm padding
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1), // Sửa deprecated withOpacity
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 28, // Giảm size icon
                  color: color,
                ),
              ),
              const SizedBox(height: 8), // Giảm height
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14, // Giảm fontSize
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1, // Giới hạn 1 dòng
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2), // Giảm height
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11, // Giảm fontSize
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 2, // Giới hạn 2 dòng
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToThesisList(BuildContext context) {
    if (student == null) {
      _showErrorSnackBar(context, 'Không thể xác định thông tin sinh viên');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ThesisRegistrationBloc(
            thesisService: ThesisService(),
          ),          child: ThesisListView(
            studentId: student!.userId,
          ),
        ),
      ),
    );
  }

  void _navigateToMyRegistrations(BuildContext context) {
    if (student == null) {
      _showErrorSnackBar(context, 'Không thể xác định thông tin sinh viên');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ThesisRegistrationBloc(
            thesisService: ThesisService(),
          ),          child: StudentRegistrationsView(
            studentId: student!.userId,
          ),
        ),
      ),
    );
  }

  void _showGuideDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hướng dẫn đăng ký đề tài'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Quy trình đăng ký đề tài:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('1. Tìm kiếm đề tài phù hợp với chuyên ngành'),
              Text('2. Xem chi tiết thông tin đề tài'),
              Text('3. Đăng ký đề tài (có thể thêm ghi chú)'),
              Text('4. Chờ giảng viên duyệt đơn đăng ký'),
              Text('5. Nhận thông báo kết quả'),
              SizedBox(height: 12),
              Text(
                'Lưu ý:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('• Mỗi sinh viên chỉ có thể đăng ký một đề tài'),
              Text('• Có thể hủy đăng ký khi đang chờ duyệt'),
              Text('• Liên hệ giảng viên nếu có thắc mắc'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đã hiểu'),
          ),
        ],
      ),
    );
  }

  void _showStatsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thống kê đề tài'),
        content: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Thông tin tổng quan:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('📊 Tổng số đề tài: Đang tải...'),
            Text('✅ Đề tài đang mở: Đang tải...'),
            Text('👥 Đề tài còn slot: Đang tải...'),
            SizedBox(height: 12),
            Text(
              'Chức năng này sẽ được cập nhật để hiển thị thống kê chi tiết.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
