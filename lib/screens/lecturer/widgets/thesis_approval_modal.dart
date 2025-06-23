import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/models/thesis_approval_models.dart';
import 'package:thesis_manage_project/models/thesis_models.dart';
import 'package:thesis_manage_project/screens/lecturer/bloc/thesis_approval_bloc.dart';
import 'package:thesis_manage_project/widgets/modern_card.dart';

class ThesisApprovalModal extends StatefulWidget {
  final ThesisModel thesis;
  final ApprovalType approvalType;
  final ThesisApprovalBloc? bloc;

  const ThesisApprovalModal({
    super.key,
    required this.thesis,
    required this.approvalType,
    this.bloc,
  });

  @override
  State<ThesisApprovalModal> createState() => _ThesisApprovalModalState();

  static Future<bool?> show(
    BuildContext context,
    ThesisModel thesis,
    ApprovalType approvalType,
  ) {
    // Get the bloc from the current context
    final bloc = context.read<ThesisApprovalBloc>();
    
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => BlocProvider<ThesisApprovalBloc>.value(
        value: bloc,
        child: ThesisApprovalModal(
          thesis: thesis,
          approvalType: approvalType,
          bloc: bloc,
        ),
      ),
    );
  }
}

class _ThesisApprovalModalState extends State<ThesisApprovalModal> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
  void _showApprovalDialog() {
    final bloc = widget.bloc ?? context.read<ThesisApprovalBloc>();
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Duyệt đề tài: ${widget.approvalType.displayName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bạn có chắc chắn muốn duyệt đề tài "${widget.thesis.name}"?'),
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
              
              final newStatus = widget.approvalType == ApprovalType.department
                  ? ThesisStatus.departmentApproved
                  : ThesisStatus.facultyApproved;
              
              bloc.add(
                ApproveThesis(
                  thesisId: widget.thesis.id,
                  newStatus: newStatus,
                ),
              );
              
              Navigator.pop(context, true);
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
    // Get the bloc before showing dialog to avoid context issues
    final bloc = widget.bloc ?? context.read<ThesisApprovalBloc>();
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Từ chối đề tài: ${widget.approvalType.displayName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bạn có chắc chắn muốn từ chối đề tài "${widget.thesis.name}"?'),
            const SizedBox(height: 16),
            TextField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Lý do từ chối *',
                border: OutlineInputBorder(),
                hintText: 'Nhập lý do từ chối đề tài...',
              ),
              maxLines: 3,
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
              if (_reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Vui lòng nhập lý do từ chối'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              
              Navigator.pop(dialogContext);
              
              // Use the captured bloc instance instead of context.read
              bloc.add(
                RejectThesis(
                  thesisId: widget.thesis.id,
                  reason: _reasonController.text.trim(),
                ),
              );
              
              Navigator.pop(context, true);
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
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Chi tiết đề tài',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thesis Title
                      ModernCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.assignment,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text(
                                    'Tên đề tài',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(widget.thesis.status).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    widget.thesis.status,
                                    style: TextStyle(
                                      color: _getStatusColor(widget.thesis.status),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              widget.thesis.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Description
                      ModernCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.description,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Mô tả đề tài',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              widget.thesis.description,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Thesis Information
                      ModernCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Thông tin đề tài',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                              _buildInfoRow('Ngành học', widget.thesis.major),
                            _buildInfoRow('Bộ môn', widget.thesis.department?.name ?? 'Chưa xác định'),
                            _buildInfoRow('Loại đề tài', widget.thesis.thesisType.toString()),
                            _buildInfoRow(
                              'Giảng viên hướng dẫn', 
                              widget.thesis.instructors.isNotEmpty
                                  ? widget.thesis.instructors.map((i) => i.name).join(', ')
                                  : 'Chưa có GVHD',
                            ),
                            _buildInfoRow(
                              'Đợt',
                              widget.thesis.batch.name,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _showRejectDialog,
                              icon: const Icon(Icons.close, size: 18),
                              label: const Text('Từ chối'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.error,
                                side: BorderSide(color: AppColors.error),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed: _showApprovalDialog,
                              icon: const Icon(Icons.check, size: 18),
                              label: const Text('Duyệt đề tài'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.success,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
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
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          const Text(': '),
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
