import 'package:flutter/material.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/models/thesis_models.dart';

class ThesisDetailView extends StatefulWidget {
  final ThesisModel thesis;
  final String studentId;

  const ThesisDetailView({
    super.key,
    required this.thesis,
    required this.studentId,
  });

  @override
  State<ThesisDetailView> createState() => _ThesisDetailViewState();
}

class _ThesisDetailViewState extends State<ThesisDetailView> {
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đề tài'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.marginMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(),
            const SizedBox(height: AppDimens.marginMedium),
            _buildBasicInfoCard(),
            const SizedBox(height: AppDimens.marginMedium),
            _buildDescriptionCard(),
            const SizedBox(height: AppDimens.marginMedium),
            _buildLecturerInfoCard(),
            const SizedBox(height: AppDimens.marginMedium),
            _buildRegistrationInfoCard(),
            const SizedBox(height: AppDimens.marginLarge),
            if (widget.thesis.isRegistrationOpen)
              _buildRegisterButton(),
          ],
        ),
      ),
    );
  }
  Widget _buildStatusCard() {
    Color statusColor;
    IconData statusIcon;
    String statusText;
    String statusDescription;

    if (!widget.thesis.isRegistrationOpen) {
      statusColor = AppColors.textDisabled;
      statusIcon = Icons.lock;
      statusText = 'Đã đóng đăng ký';
      statusDescription = 'Đề tài này hiện không mở đăng ký';
    } else {
      statusColor = AppColors.success;
      statusIcon = Icons.check_circle;
      statusText = 'Đang mở đăng ký';
      statusDescription = 'Bạn có thể đăng ký đề tài này';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.marginMedium),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimens.marginRegular),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimens.radiusRegular),
              ),
              child: Icon(
                statusIcon,
                color: statusColor,
                size: 32,
              ),
            ),
            const SizedBox(width: AppDimens.marginMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statusText,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppDimens.marginSmall),
                  Text(
                    statusDescription,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.marginMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông tin cơ bản',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimens.marginMedium),
            Text(
              widget.thesis.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppDimens.marginMedium),            _buildInfoRow(
              Icons.category,
              'Loại đề tài',
              widget.thesis.thesisTypeName,
            ),
            const SizedBox(height: AppDimens.marginRegular),
            _buildInfoRow(
              Icons.school,
              'Chuyên ngành',
              widget.thesis.major,
            ),
            const SizedBox(height: AppDimens.marginRegular),
            _buildInfoRow(
              Icons.info,
              'Trạng thái',
              widget.thesis.status,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.marginMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mô tả đề tài',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimens.marginMedium),
            Text(
              widget.thesis.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppDimens.marginRegular),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _showRegisterDialog,
        icon: const Icon(Icons.add),
        label: const Text('Đăng ký đề tài'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: AppDimens.marginMedium),
        ),
      ),
    );
  }

  void _showRegisterDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xác nhận đăng ký'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bạn có muốn đăng ký đề tài "${widget.thesis.title}"?'),
            const SizedBox(height: AppDimens.marginMedium),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Ghi chú (tùy chọn)',
                hintText: 'Nhập ghi chú cho đơn đăng ký...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              maxLength: 500,
            ),
            const SizedBox(height: AppDimens.marginRegular),
            const Text(
              'Lưu ý: Sau khi đăng ký, bạn cần chờ giảng viên duyệt.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // TODO: Hiển thị dialog chọn nhóm trước khi đăng ký
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chức năng đăng ký đang được phát triển'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('Đăng ký'),
          ),
        ],
      ),
    );
  }

  Widget _buildLecturerInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.marginMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông tin giảng viên hướng dẫn',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimens.marginMedium),
            if (widget.thesis.instructors.isNotEmpty) ...[
              ...widget.thesis.instructors.map((instructor) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimens.marginRegular),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppDimens.marginRegular),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppDimens.radiusRegular),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppDimens.marginMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            instructor.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppDimens.marginSmall),
                          Text(
                            instructor.email,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            'Mã giảng viên: ${instructor.lecturerCode}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (instructor.departmentName != null)
                            Text(
                              'Khoa: ${instructor.departmentName}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ] else ...[
              const Text('Chưa có thông tin giảng viên hướng dẫn'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.marginMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông tin đề tài',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimens.marginMedium),
            if (widget.thesis.startDate != null && widget.thesis.endDate != null) ...[
              _buildInfoRow(
                Icons.calendar_today,
                'Thời gian thực hiện',
                '${_formatDate(widget.thesis.startDate!)} - ${_formatDate(widget.thesis.endDate!)}',
              ),
              const SizedBox(height: AppDimens.marginRegular),
            ],
            _buildInfoRow(
              Icons.business,
              'Batch',
              widget.thesis.batch.name,
            ),
            const SizedBox(height: AppDimens.marginRegular),
            _buildInfoRow(
              Icons.school,
              'Học kỳ',
              widget.thesis.batch.semester.name,
            ),
            const SizedBox(height: AppDimens.marginRegular),
            if (widget.thesis.department != null) ...[
              _buildInfoRow(
                Icons.business,
                'Khoa',
                widget.thesis.department!.name,
              ),
              const SizedBox(height: AppDimens.marginRegular),
            ],
            _buildInfoRow(
              Icons.info,
              'Trạng thái',
              widget.thesis.status,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
