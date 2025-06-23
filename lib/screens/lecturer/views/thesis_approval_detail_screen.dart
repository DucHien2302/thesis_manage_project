import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/models/thesis_approval_models.dart';
import 'package:thesis_manage_project/models/thesis_models.dart';
import 'package:thesis_manage_project/screens/lecturer/bloc/thesis_approval_bloc.dart';
import 'package:thesis_manage_project/repositories/thesis_approval_repository.dart';
import 'package:thesis_manage_project/utils/api_service.dart';
import 'package:thesis_manage_project/widgets/modern_card.dart';

class ThesisApprovalDetailScreen extends StatelessWidget {
  final ThesisModel thesis;
  final ApprovalType approvalType;

  const ThesisApprovalDetailScreen({
    super.key,
    required this.thesis,
    required this.approvalType,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThesisApprovalBloc(
        repository: ThesisApprovalRepository(
          apiService: ApiService(),
        ),
      ),
      child: _ThesisApprovalDetailView(
        thesis: thesis,
        approvalType: approvalType,
      ),
    );
  }
}

class _ThesisApprovalDetailView extends StatefulWidget {
  final ThesisModel thesis;
  final ApprovalType approvalType;

  const _ThesisApprovalDetailView({
    required this.thesis,
    required this.approvalType,
  });
  @override
  State<_ThesisApprovalDetailView> createState() => _ThesisApprovalDetailViewState();
}

class _ThesisApprovalDetailViewState extends State<_ThesisApprovalDetailView> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _showApprovalDialog() {
    final bloc = BlocProvider.of<ThesisApprovalBloc>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Duyệt đề tài: ${widget.approvalType.displayName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bạn có chắc chắn muốn duyệt đề tài "${widget.thesis.name}"?'),
            const SizedBox(height: 16),
            TextField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Ghi chú (tùy chọn)',
                border: OutlineInputBorder(),
                hintText: 'Nhập ghi chú cho việc duyệt đề tài...',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              
              final newStatus = widget.approvalType == ApprovalType.department
                  ? ThesisStatus.departmentApproved
                  : ThesisStatus.facultyApproved;
              
              bloc.add(
                ApproveThesis(
                  thesisId: widget.thesis.id,
                  newStatus: newStatus,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
            ),
            child: const Text('Duyệt'),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog() {
    final bloc = BlocProvider.of<ThesisApprovalBloc>(context, listen: false);
    final TextEditingController rejectReasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Từ chối đề tài'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bạn có chắc chắn muốn từ chối đề tài "${widget.thesis.name}"?'),
            const SizedBox(height: 16),
            TextField(
              controller: rejectReasonController,
              decoration: const InputDecoration(
                labelText: 'Lý do từ chối *',
                border: OutlineInputBorder(),
                hintText: 'Nhập lý do từ chối đề tài...',
              ),
              maxLines: 3,
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (rejectReasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Vui lòng nhập lý do từ chối'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              
              Navigator.pop(context);
              bloc.add(
                RejectThesis(
                  thesisId: widget.thesis.id,
                  reason: rejectReasonController.text.trim(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Từ chối'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ThesisApprovalBloc, ThesisApprovalState>(
      listener: (context, state) {
        if (state is ThesisApprovalActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pop(context, true); // Return true to indicate success
        } else if (state is ThesisApprovalError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'Chi tiết đề tài',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              ModernCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Status
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.thesis.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(widget.thesis.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            widget.thesis.status,
                            style: TextStyle(
                              color: _getStatusColor(widget.thesis.status),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Approval Type Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        widget.approvalType.displayName,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Basic Info Card
              ModernCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thông tin cơ bản',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildInfoRow('Loại đề tài', widget.thesis.nameThesisType),
                    _buildInfoRow('Chuyên ngành', widget.thesis.major),
                    if (widget.thesis.department != null)
                      _buildInfoRow('Bộ môn', widget.thesis.department!.name),
                    if (widget.thesis.startDate != null)
                      _buildInfoRow('Ngày bắt đầu', widget.thesis.startDate!),
                    if (widget.thesis.endDate != null)
                      _buildInfoRow('Ngày kết thúc', widget.thesis.endDate!),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Description Card
              ModernCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mô tả đề tài',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.thesis.description,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Instructors Card
              if (widget.thesis.instructors.isNotEmpty)
                ModernCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Giảng viên hướng dẫn',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...widget.thesis.instructors.map((instructor) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    instructor.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    instructor.email,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              
              const SizedBox(height: 16),
              
              // Reviewers Card
              if (widget.thesis.reviewers.isNotEmpty)
                ModernCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Giảng viên phản biện',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...widget.thesis.reviewers.map((reviewer) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.rate_review,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reviewer.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    reviewer.email,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              
              const SizedBox(height: 16),
              
              // Batch Info Card
              ModernCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thông tin đợt đề tài',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('Tên đợt', widget.thesis.batch.name),
                    _buildInfoRow('Học kỳ', widget.thesis.batch.semester.name),
                    if (widget.thesis.batch.semester.academyYear != null)
                      _buildInfoRow('Năm học', widget.thesis.batch.semester.academyYear!.name),
                  ],
                ),
              ),
              
              // Reason Card (if available)
              if (widget.thesis.reason != null && widget.thesis.reason!.isNotEmpty) ...[
                const SizedBox(height: 16),
                ModernCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ghi chú',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.thesis.reason!,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 24),
              
              // Action Buttons
              _buildActionButtons(),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final currentStatus = ThesisStatus.getStatusFromString(widget.thesis.status);
    final allowedStatuses = widget.approvalType.allowedStatuses;
    
    // Only show action buttons if the thesis is in an allowed status for this approval type
    if (!allowedStatuses.contains(currentStatus)) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Đề tài này không thể duyệt ở cấp ${widget.approvalType.displayName.toLowerCase()}',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return BlocBuilder<ThesisApprovalBloc, ThesisApprovalState>(
      builder: (context, state) {
        final isProcessing = state is ThesisApprovalProcessing;
        
        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isProcessing ? null : _showRejectDialog,
                icon: const Icon(Icons.close),
                label: const Text('Từ chối'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: isProcessing ? null : _showApprovalDialog,
                icon: isProcessing 
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.check),
                label: Text(isProcessing ? 'Đang xử lý...' : 'Duyệt đề tài'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    if (status.contains('Chờ duyệt')) {
      return AppColors.warning;
    } else if (status.contains('Đã duyệt')) {
      return AppColors.success;
    } else if (status.contains('Từ chối')) {
      return AppColors.error;
    }
    return Colors.grey;
  }
}
