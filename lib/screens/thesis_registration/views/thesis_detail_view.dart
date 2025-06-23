import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/models/thesis_models.dart';
import 'package:thesis_manage_project/screens/thesis_registration/blocs/thesis_registration_bloc.dart';
import 'package:thesis_manage_project/screens/auth/blocs/auth_bloc.dart';

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
  void initState() {
    super.initState();
    _loadMyGroups();
  }

  // Load danh sách nhóm của user hiện tại
  void _loadMyGroups() {
    context.read<ThesisRegistrationBloc>().add(const LoadMyGroups());
  }
  @override
  void dispose() {
    // When the view is disposed (including when back button is pressed),
    // reload the thesis list data
    context.read<ThesisRegistrationBloc>().add(const LoadMyGroups());
    _notesController.dispose();
    super.dispose();
  }@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đề tài'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Pop and trigger reload
            Navigator.of(context).pop();
          },
        ),
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
            _buildRegistrationInfoCard(),            const SizedBox(height: AppDimens.marginLarge),
            BlocBuilder<ThesisRegistrationBloc, ThesisRegistrationState>(
              builder: (context, state) {
                bool userHasRegisteredThesis = false;
                
                // Kiểm tra từ state GroupsLoaded xem có nhóm nào đã đăng ký đề tài chưa
                if (state is GroupsLoaded) {
                  final authState = context.read<AuthBloc>().state;
                  if (authState is Authenticated) {
                    final currentUserId = authState.user['id']?.toString();
                    final userGroups = state.groups.where((group) => group.leaderId == currentUserId).toList();
                    userHasRegisteredThesis = userGroups.any((group) => group.thesisId != null && group.thesisId!.isNotEmpty);
                  }
                }
                
                if (widget.thesis.isRegistrationOpen && !userHasRegisteredThesis) {
                  return _buildRegisterButton();
                } else if (userHasRegisteredThesis) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.block),
                      label: const Text('Bạn đã đăng ký đề tài khác'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: AppDimens.marginMedium),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
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
      width: double.infinity,      child: ElevatedButton.icon(
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
    // Load groups first
    context.read<ThesisRegistrationBloc>().add(const LoadMyGroups());
    
    showDialog(
      context: context,
      builder: (dialogContext) => BlocConsumer<ThesisRegistrationBloc, ThesisRegistrationState>(
        bloc: context.read<ThesisRegistrationBloc>(),
        listener: (context, state) {
          if (state is ThesisRegistrationSuccess) {
            Navigator.pop(dialogContext);
            ScaffoldMessenger.of(this.context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ThesisRegistrationError) {
            Navigator.pop(dialogContext);
            ScaffoldMessenger.of(this.context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GroupsLoading) {
            return const AlertDialog(
              title: Text('Đang tải...'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Đang tải danh sách nhóm...'),
                ],
              ),
            );
          } else if (state is GroupsLoaded) {
            final authState = this.context.read<AuthBloc>().state;
            if (authState is! Authenticated) {
              return AlertDialog(
                title: const Text('Lỗi'),
                content: const Text('Phiên đăng nhập đã hết hạn'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Đóng'),
                  ),
                ],
              );
            }

            final currentUserId = authState.user['id']?.toString();
            final leaderGroups = state.groups.where((group) => group.leaderId == currentUserId).toList();
            
            if (leaderGroups.isEmpty) {
              return AlertDialog(
                title: const Text('Không có nhóm'),
                content: const Text('Bạn chưa là trưởng nhóm của nhóm nào. Vui lòng tạo nhóm hoặc được chỉ định làm trưởng nhóm.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Đóng'),
                  ),
                ],
              );
            }

            // Lọc các nhóm chưa đăng ký đề tài nào
            final availableGroups = leaderGroups.where((group) => group.thesisId == null || group.thesisId!.isEmpty).toList();

            if (availableGroups.isEmpty) {
              return AlertDialog(
                title: const Text('Không có nhóm khả dụng'),
                content: const Text('Tất cả nhóm của bạn đã đăng ký đề tài khác rồi.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Đóng'),
                  ),
                ],
              );
            }

            return AlertDialog(
              title: const Text('Chọn nhóm để đăng ký'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: availableGroups.length,
                  itemBuilder: (context, index) {
                    final group = availableGroups[index];
                    return ListTile(
                      title: Text(group.name ?? 'Nhóm ${index + 1}'),
                      subtitle: Text('Trưởng nhóm • ${group.members.length} thành viên'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _registerThesisForGroup(group.id),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Hủy'),
                ),
              ],
            );
          } else if (state is GroupsError) {
            return AlertDialog(
              title: const Text('Lỗi'),
              content: Text(state.message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Đóng'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<ThesisRegistrationBloc>().add(const LoadMyGroups());
                  },
                  child: const Text('Thử lại'),
                ),
              ],
            );
          } else if (state is ThesisRegistering) {
            return const AlertDialog(
              title: Text('Đang đăng ký...'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Đang đăng ký đề tài...'),
                ],
              ),
            );
          }

          // Default state
          return AlertDialog(
            title: const Text('Đang tải...'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Vui lòng chờ...'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Hủy'),
              ),
            ],
          );
        },
      ),
    );
  }

  // Đăng ký đề tài cho nhóm
  void _registerThesisForGroup(String groupId) {
    // Hiển thị dialog xác nhận
    showDialog(
      context: context,
      builder: (confirmContext) => AlertDialog(
        title: const Text('Xác nhận đăng ký'),
        content: Text('Bạn có chắc chắn muốn đăng ký đề tài "${widget.thesis.title}" cho nhóm này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(confirmContext),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(confirmContext);
              // Gọi bloc để đăng ký
              context.read<ThesisRegistrationBloc>().add(
                RegisterThesisForGroup(
                  groupId: groupId,
                  thesisId: widget.thesis.id,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
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
