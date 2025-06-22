import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/models/thesis_models.dart';
import 'package:thesis_manage_project/screens/thesis_registration/blocs/thesis_registration_bloc.dart';

class StudentRegistrationsView extends StatefulWidget {
  final String studentId;

  const StudentRegistrationsView({
    super.key,
    required this.studentId,
  });

  @override
  State<StudentRegistrationsView> createState() => _StudentRegistrationsViewState();
}

class _StudentRegistrationsViewState extends State<StudentRegistrationsView> {
  @override
  void initState() {
    super.initState();
    _loadRegistrations();
  }

  void _loadRegistrations() {
    context.read<ThesisRegistrationBloc>().add(
      LoadStudentRegistrations(widget.studentId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng ký của tôi'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRegistrations,
          ),
        ],
      ),
      body: BlocConsumer<ThesisRegistrationBloc, ThesisRegistrationState>(
        listener: (context, state) {
          if (state is RegistrationCancelSuccess) {
            _showSuccessSnackBar(state.message);
            _loadRegistrations(); // Reload after cancellation
          }
          
          if (state is RegistrationCancelError) {
            _showErrorSnackBar(state.message);
          }
        },
        builder: (context, state) {
          if (state is StudentRegistrationsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (state is StudentRegistrationsError) {
            return _buildErrorView(state.message);
          }
          
          if (state is StudentRegistrationsLoaded) {
            return _buildRegistrationsList(state.registrations);
          }
          
          return const Center(
            child: Text('Chưa có dữ liệu'),
          );
        },
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.marginLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: AppDimens.marginMedium),
            Text(
              'Có lỗi xảy ra',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppDimens.marginRegular),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimens.marginLarge),
            ElevatedButton(
              onPressed: _loadRegistrations,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationsList(List<StudentThesisRegistrationModel> registrations) {
    if (registrations.isEmpty) {
      return _buildEmptyView();
    }

    return RefreshIndicator(
      onRefresh: () async => _loadRegistrations(),
      child: ListView.builder(
        padding: const EdgeInsets.all(AppDimens.marginMedium),
        itemCount: registrations.length,
        itemBuilder: (context, index) {
          return _buildRegistrationCard(registrations[index]);
        },
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.marginLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.assignment_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppDimens.marginMedium),
            Text(
              'Chưa có đăng ký nào',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppDimens.marginRegular),
            Text(
              'Bạn chưa đăng ký đề tài nào. Hãy tìm và đăng ký đề tài phù hợp.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationCard(StudentThesisRegistrationModel registration) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimens.marginMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.marginMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Đề tài ID: ${registration.thesisId}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStatusChip(registration),
              ],
            ),
            const SizedBox(height: AppDimens.marginMedium),
            _buildRegistrationInfo(registration),
            if (registration.notes != null && registration.notes!.isNotEmpty) ...[
              const SizedBox(height: AppDimens.marginMedium),
              _buildNotesSection(registration.notes!),
            ],
            const SizedBox(height: AppDimens.marginMedium),
            _buildActionButtons(registration),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(StudentThesisRegistrationModel registration) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (registration.status.toLowerCase()) {
      case 'pending':
        backgroundColor = AppColors.warning;
        textColor = AppColors.textPrimary;
        icon = Icons.schedule;
        break;
      case 'approved':
        backgroundColor = AppColors.success;
        textColor = AppColors.textLight;
        icon = Icons.check_circle;
        break;
      case 'rejected':
        backgroundColor = AppColors.error;
        textColor = AppColors.textLight;
        icon = Icons.cancel;
        break;
      default:
        backgroundColor = AppColors.textDisabled;
        textColor = AppColors.textLight;
        icon = Icons.help;
    }

    return Chip(
      avatar: Icon(
        icon,
        size: 16,
        color: textColor,
      ),
      label: Text(
        registration.statusName,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: backgroundColor,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildRegistrationInfo(StudentThesisRegistrationModel registration) {
    return Column(
      children: [
        _buildInfoRow(
          Icons.calendar_today,
          'Ngày đăng ký',
          _formatDate(registration.registrationDate),
        ),
        if (registration.approvalDate != null) ...[
          const SizedBox(height: AppDimens.marginRegular),
          _buildInfoRow(
            Icons.approval,
            'Ngày duyệt',
            _formatDate(registration.approvalDate!),
          ),
        ],
        const SizedBox(height: AppDimens.marginRegular),
        _buildInfoRow(
          Icons.update,
          'Cập nhật lần cuối',
          _formatDate(registration.updateDatetime),
        ),
      ],
    );
  }

  Widget _buildNotesSection(String notes) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.marginMedium),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimens.radiusRegular),
        border: Border.all(color: AppColors.textDisabled.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ghi chú:',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimens.marginSmall),
          Text(
            notes,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppDimens.marginRegular),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(StudentThesisRegistrationModel registration) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (registration.status.toLowerCase() == 'pending')
          BlocBuilder<ThesisRegistrationBloc, ThesisRegistrationState>(
            builder: (context, state) {
              final isLoading = state is RegistrationCancelling;
              
              return TextButton.icon(
                onPressed: isLoading ? null : () => _showCancelDialog(registration),
                icon: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.cancel, size: 16),
                label: Text(isLoading ? 'Đang hủy...' : 'Hủy đăng ký'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                ),
              );
            },
          ),
      ],
    );
  }

  void _showCancelDialog(StudentThesisRegistrationModel registration) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xác nhận hủy đăng ký'),
        content: const Text(
          'Bạn có chắc chắn muốn hủy đăng ký đề tài này? '
          'Hành động này không thể hoàn tác.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Không'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ThesisRegistrationBloc>().add(
                CancelRegistration(registration.id),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.textLight,
            ),
            child: const Text('Hủy đăng ký'),
          ),
        ],
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

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
