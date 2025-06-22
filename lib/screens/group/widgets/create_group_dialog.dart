import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/screens/group/bloc/group_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';

class CreateGroupDialog extends StatefulWidget {
  const CreateGroupDialog({Key? key}) : super(key: key);

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => const CreateGroupDialog(),
    );
  }

  @override
  State<CreateGroupDialog> createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends State<CreateGroupDialog> {
  final TextEditingController _nameController = TextEditingController();
  final ValueNotifier<String?> _errorText = ValueNotifier<String?>(null);

  @override
  void dispose() {
    _nameController.dispose();
    _errorText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
      ),
      title: Row(
        children: [
          Icon(
            Icons.group_add,
            color: AppColors.primary,
            size: 24,
          ),
          const SizedBox(width: 8),
          const Text(
            'Tạo nhóm mới',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nhập tên nhóm để tạo nhóm mới',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: AppDimens.marginMedium),
          ValueListenableBuilder<String?>(
            valueListenable: _errorText,
            builder: (context, error, child) {
              return TextField(
                controller: _nameController,
                maxLength: 50,
                onChanged: (value) {
                  if (error != null && value.trim().isNotEmpty) {
                    _errorText.value = null;
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Ví dụ: Nhóm 1, Nhóm ABC...',
                  labelText: 'Tên nhóm *',
                  errorText: error,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusRegular),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusRegular),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusRegular),
                    borderSide: const BorderSide(color: AppColors.error),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.marginMedium,
                    vertical: AppDimens.marginMedium,
                  ),
                  counterText: '',
                ),
                autofocus: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _handleCreateGroup(),
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Hủy',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        BlocConsumer<GroupBloc, GroupState>(          listener: (context, state) {
            if (state is GroupCreatedState) {
              Navigator.of(context).pop();
              final memberCount = state.group.members.length;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle_outline, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tạo nhóm "${state.group.name}" thành công! ($memberCount thành viên)',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  duration: const Duration(seconds: 3),
                ),
              );
            } else if (state is GroupErrorState) {
              _errorText.value = _getReadableError(state.error);
            }
          },          builder: (context, state) {
            final isLoading = state is GroupLoadingState || state is GroupCreatingState;
            String buttonText = 'Tạo nhóm';
            
            if (state is GroupCreatingState) {
              buttonText = state.message;
            }
            
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusRegular),
                ),
              ),
              onPressed: isLoading ? null : _handleCreateGroup,
              child: isLoading
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        if (state is GroupCreatingState) ...[
                          const SizedBox(width: 8),
                          Text(
                            buttonText,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    )
                  : Text(
                      buttonText,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
            );
          },
        ),
      ],
    );
  }

  void _handleCreateGroup() {
    final groupName = _nameController.text.trim();
    
    if (groupName.isEmpty) {
      _errorText.value = 'Vui lòng nhập tên nhóm';
      return;
    }
    
    if (groupName.length < 2) {
      _errorText.value = 'Tên nhóm phải có ít nhất 2 ký tự';
      return;
    }
    
    // Debug logging
    print('Creating group with name: $groupName');
    
    context.read<GroupBloc>().add(CreateGroupEvent(name: groupName));
  }

  String _getReadableError(String error) {
    if (error.contains('Connection') || error.contains('network')) {
      return 'Lỗi kết nối mạng. Vui lòng thử lại.';
    }
    if (error.contains('timeout')) {
      return 'Kết nối quá chậm. Vui lòng thử lại.';
    }
    if (error.contains('duplicate') || error.contains('already exists')) {
      return 'Tên nhóm đã tồn tại. Vui lòng chọn tên khác.';
    }
    if (error.contains('unauthorized') || error.contains('403')) {
      return 'Bạn không có quyền thực hiện thao tác này.';
    }
    if (error.contains('400')) {
      return 'Thông tin không hợp lệ. Vui lòng kiểm tra lại.';
    }
    return 'Có lỗi xảy ra. Vui lòng thử lại sau.';
  }
}
