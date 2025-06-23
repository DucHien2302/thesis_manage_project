import 'package:flutter/material.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/widgets/modern_card.dart';

class LecturerThesisTab extends StatelessWidget {
  const LecturerThesisTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModernCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.school_outlined, color: AppColors.primary, size: 28),
                    const SizedBox(width: 12),
                    const Text(
                      'Quản lý đề tài',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Quản lý đề tài, theo dõi tiến độ, thống kê và báo cáo.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/lecturer-thesis');
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Vào trang quản lý đề tài'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
