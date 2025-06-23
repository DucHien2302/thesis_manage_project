import 'package:flutter/material.dart';
import 'package:thesis_manage_project/models/thesis_models.dart';
import 'package:thesis_manage_project/widgets/thesis_detail_common.dart';
import 'package:thesis_manage_project/config/constants.dart';

class LecturerThesisDetailScreen extends StatelessWidget {
  final ThesisModel thesis;

  const LecturerThesisDetailScreen({
    super.key,
    required this.thesis,
  });

  @override
  Widget build(BuildContext context) {
    return ThesisDetailCommon(
      thesis: thesis,
      isLecturerView: true,
      actionButtons: _buildActionButtons(context),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                _editThesis(context);
              },
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Chỉnh sửa'),
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
          const SizedBox(width: 16),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                _showThesisOptions(context);
              },
              icon: const Icon(Icons.more_horiz),
              label: const Text('Thêm'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editThesis(BuildContext context) {
    // Navigate to edit thesis screen
    // You can implement this based on your edit thesis screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chức năng chỉnh sửa đề tài đang được phát triển'),
      ),
    );
  }

  void _showThesisOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Thao tác với đề tài',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(Icons.people_outlined, color: AppColors.primary),
                title: const Text('Xem danh sách sinh viên đăng ký'),
                subtitle: const Text('Xem các nhóm sinh viên đã đăng ký đề tài này'),
                onTap: () {
                  Navigator.pop(context);
                  _viewRegisteredStudents(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.assignment_outlined, color: Colors.blue),
                title: const Text('Quản lý nhiệm vụ'),
                subtitle: const Text('Tạo và quản lý nhiệm vụ cho đề tài'),
                onTap: () {
                  Navigator.pop(context);
                  _manageTasks(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.timeline_outlined, color: Colors.green),
                title: const Text('Theo dõi tiến độ'),
                subtitle: const Text('Xem tiến độ thực hiện của sinh viên'),
                onTap: () {
                  Navigator.pop(context);
                  _viewProgress(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.download_outlined, color: Colors.orange),
                title: const Text('Xuất báo cáo'),
                subtitle: const Text('Xuất báo cáo chi tiết về đề tài'),
                onTap: () {
                  Navigator.pop(context);
                  _exportReport(context);
                },
              ),
              if (thesis.status.toLowerCase() == 'chờ duyệt') ...[
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text('Xóa đề tài'),
                  subtitle: const Text('Xóa đề tài khỏi hệ thống'),
                  onTap: () {
                    Navigator.pop(context);
                    _confirmDeleteThesis(context);
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _viewRegisteredStudents(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chức năng xem sinh viên đăng ký đang được phát triển'),
      ),
    );
  }

  void _manageTasks(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chức năng quản lý nhiệm vụ đang được phát triển'),
      ),
    );
  }

  void _viewProgress(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chức năng theo dõi tiến độ đang được phát triển'),
      ),
    );
  }

  void _exportReport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chức năng xuất báo cáo đang được phát triển'),
      ),
    );
  }

  void _confirmDeleteThesis(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa đề tài "${thesis.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteThesis(context);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  void _deleteThesis(BuildContext context) {
    // Implement delete thesis logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chức năng xóa đề tài đang được phát triển'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
