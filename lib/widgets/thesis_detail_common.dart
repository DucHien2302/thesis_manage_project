import 'package:flutter/material.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/models/thesis_models.dart';
import 'package:thesis_manage_project/widgets/modern_card.dart';

class ThesisDetailCommon extends StatelessWidget {
  final ThesisModel thesis;
  final bool isLecturerView;
  final Widget? actionButtons;

  const ThesisDetailCommon({
    super.key,
    required this.thesis,
    this.isLecturerView = false,
    this.actionButtons,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đề tài'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Registration Status Card (for student view)
            if (!isLecturerView) ...[
              _buildRegistrationStatusCard(),
              const SizedBox(height: 16),
            ],
            
            // Basic Info Card
            _buildBasicInfoCard(),
            const SizedBox(height: 16),
            
            // Description Card
            _buildDescriptionCard(),
            const SizedBox(height: 16),
            
            // Timeline Card
            _buildTimelineCard(),
            const SizedBox(height: 16),
            
            // Instructors Card
            _buildInstructorsCard(),
            const SizedBox(height: 16),
            
            // Reviewers Card (if available)
            if (thesis.reviewers.isNotEmpty) ...[
              _buildReviewersCard(),
              const SizedBox(height: 16),
            ],
            
            // Batch Info Card
            _buildBatchInfoCard(),
            const SizedBox(height: 16),
            
            // Action buttons (if provided)
            if (actionButtons != null) actionButtons!,
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationStatusCard() {
    Color statusColor;
    IconData statusIcon;
    String statusText;
    String statusDescription;

    if (!thesis.isRegistrationOpen) {
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

    return ModernCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              statusIcon,
              color: statusColor,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusDescription,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.school_outlined,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      thesis.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildStatusChip(thesis.status),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Loại đề tài', _getThesisTypeText(thesis.thesisType)),
          const SizedBox(height: 8),
          _buildInfoRow('Mã đề tài', thesis.id),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Mô tả đề tài',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            thesis.description.isNotEmpty ? thesis.description : 'Chưa có mô tả',
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard() {
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.schedule_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Thời gian thực hiện',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [              Expanded(
                child: _buildTimelineItem(
                  'Ngày bắt đầu',
                  _formatDateString(thesis.startDate),
                  Icons.play_arrow_outlined,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTimelineItem(
                  'Ngày kết thúc',
                  _formatDateString(thesis.endDate),
                  Icons.stop_outlined,
                  Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInstructorsCard() {
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_outline,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Giảng viên hướng dẫn',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),          ...thesis.instructors.map((instructor) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _buildPersonCard(
                  name: instructor.name,
                  email: instructor.email,
                  code: instructor.lecturerCode,
                  department: instructor.departmentName,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildReviewersCard() {
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.rate_review_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Giảng viên phản biện',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),          ...thesis.reviewers.map((reviewer) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _buildPersonCard(
                  name: reviewer.name,
                  email: reviewer.email,
                  code: reviewer.lecturerCode,
                  department: reviewer.departmentName,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildBatchInfoCard() {
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.batch_prediction_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Thông tin đợt',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),          _buildInfoRow('Tên đợt', thesis.batch.name),
          const SizedBox(height: 8),
          _buildInfoRow('Học kỳ', thesis.batch.semester.name),
          const SizedBox(height: 8),
          _buildInfoRow('Năm học', thesis.batch.semester.academyYear?.name ?? 'N/A'),
          const SizedBox(height: 8),
          _buildInfoRow(
            'Thời gian đợt',
            '${_formatDateString(thesis.batch.startDate)} - ${_formatDateString(thesis.batch.endDate)}',
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    Color textColor = Colors.white;
    
    switch (status.toLowerCase()) {
      case 'đã duyệt':
        chipColor = Colors.green;
        break;
      case 'chờ duyệt':
        chipColor = Colors.orange;
        break;
      case 'từ chối':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.grey;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Text(': ', style: TextStyle(fontSize: 14)),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem(String label, String date, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonCard({
    required String name,
    required String email,
    required String code,
    String? department,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Icon(
              Icons.person,
              color: AppColors.primary,
              size: 20,
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
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  code,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                if (department != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    department,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            Icons.email_outlined,
            color: Colors.grey[400],
            size: 20,
          ),
        ],
      ),
    );
  }
  String _formatDateString(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString; // Return original string if parsing fails
    }
  }

  String _getThesisTypeText(int thesisType) {
    switch (thesisType) {
      case 1:
        return 'Đề tài nghiên cứu';
      case 2:
        return 'Đề tài ứng dụng';
      case 3:
        return 'Đề tài thiết kế';
      default:
        return 'Không xác định';
    }
  }
}
