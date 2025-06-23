import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/models/thesis_models.dart';
import 'package:thesis_manage_project/screens/thesis_registration/blocs/thesis_registration_bloc.dart';
import 'package:thesis_manage_project/screens/auth/blocs/auth_bloc.dart';
import 'package:thesis_manage_project/widgets/thesis_detail_common.dart';

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
  }  @override
  Widget build(BuildContext context) {
    return ThesisDetailCommon(
      thesis: widget.thesis,
      isLecturerView: false,
      actionButtons: _buildStudentActionButtons(),
    );
  }

  Widget _buildStudentActionButtons() {
    return BlocBuilder<ThesisRegistrationBloc, ThesisRegistrationState>(
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
    );
  }  Widget _buildRegisterButton() {
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
  }  void _showRegisterDialog() {
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
        content: Text('Bạn có chắc chắn muốn đăng ký đề tài "${widget.thesis.name}" cho nhóm này?'),
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
}
