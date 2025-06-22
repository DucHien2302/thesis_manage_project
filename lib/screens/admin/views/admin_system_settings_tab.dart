import 'package:flutter/material.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/widgets/modern_card.dart';

class AdminSystemSettingsTab extends StatelessWidget {
  const AdminSystemSettingsTab({super.key});

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
                Icon(Icons.settings, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Cài đặt hệ thống',
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
          
          // Cài đặt chung
          const Text(
            'Cài đặt chung',
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
                _buildSettingItem(
                  'Tên hệ thống',
                  'Hệ thống quản lý khóa luận',
                  Icons.title,
                  AppColors.primary,
                ),
                const Divider(),
                _buildSettingItem(
                  'Phiên bản',
                  'v1.0.0',
                  Icons.info,
                  AppColors.info,
                ),
                const Divider(),
                _buildSettingItem(
                  'Email hỗ trợ',
                  'support@university.edu.vn',
                  Icons.email,
                  AppColors.warning,
                ),
                const Divider(),
                _buildSettingItem(
                  'Múi giờ',
                  'UTC+7 (Việt Nam)',
                  Icons.schedule,
                  AppColors.success,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Cài đặt bảo mật
          const Text(
            'Cài đặt bảo mật',
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
                _buildToggleItem(
                  'Xác thực 2 lớp',
                  'Bắt buộc người dùng sử dụng 2FA',
                  Icons.security,
                  AppColors.primary,
                  true,
                ),
                const Divider(),
                _buildToggleItem(
                  'Đăng nhập tự động',
                  'Cho phép ghi nhớ đăng nhập',
                  Icons.login,
                  AppColors.info,
                  false,
                ),
                const Divider(),
                _buildToggleItem(
                  'Thông báo bảo mật',
                  'Gửi email khi có hoạt động đáng ngờ',
                  Icons.notifications_active,
                  AppColors.warning,
                  true,
                ),
                const Divider(),
                _buildToggleItem(
                  'Mã hóa dữ liệu',
                  'Mã hóa tất cả dữ liệu nhạy cảm',
                  Icons.lock,
                  AppColors.error,
                  true,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Cài đặt sao lưu
          const Text(
            'Sao lưu & Phục hồi',
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
                _buildActionItem(
                  'Sao lưu tự động',
                  'Lần cuối: 22/06/2025 02:00',
                  Icons.backup,
                  AppColors.primary,
                  'Cấu hình',
                ),
                const Divider(),
                _buildActionItem(
                  'Sao lưu thủ công',
                  'Tạo bản sao lưu ngay',
                  Icons.save,
                  AppColors.info,
                  'Thực hiện',
                ),
                const Divider(),
                _buildActionItem(
                  'Phục hồi dữ liệu',
                  'Khôi phục từ bản sao lưu',
                  Icons.restore,
                  AppColors.warning,
                  'Khôi phục',
                ),
                const Divider(),
                _buildActionItem(
                  'Lịch sử sao lưu',
                  'Xem tất cả bản sao lưu',
                  Icons.history,
                  AppColors.success,
                  'Xem',
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Cài đặt hiệu suất
          const Text(
            'Hiệu suất hệ thống',
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
                  icon: Icons.memory,
                  title: 'RAM sử dụng',
                  value: '2.4GB',
                  subtitle: 'Trên 8GB',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  icon: Icons.storage,
                  title: 'Dung lượng',
                  value: '125GB',
                  subtitle: 'Trên 500GB',
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
                  icon: Icons.speed,
                  title: 'CPU',
                  value: '45%',
                  subtitle: 'Tải trung bình',
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  icon: Icons.wifi,
                  title: 'Kết nối',
                  value: '98.5%',
                  subtitle: 'Uptime',
                  color: AppColors.success,
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
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Khởi động lại'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
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

  Widget _buildSettingItem(String title, String value, IconData icon, Color color) {
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
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem(String title, String description, IconData icon, Color color, bool isEnabled) {
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
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: (value) {},
            activeColor: color,
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(String title, String description, IconData icon, Color color, String actionText) {
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
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              actionText,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
