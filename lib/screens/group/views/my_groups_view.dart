import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/models/group_models.dart';
import 'package:thesis_manage_project/screens/auth/blocs/auth_bloc.dart';
import 'package:thesis_manage_project/screens/group/bloc/group_bloc.dart';
import 'package:thesis_manage_project/screens/group/views/group_detail_view.dart';
import 'package:thesis_manage_project/widgets/loading_indicator.dart';
import 'package:thesis_manage_project/config/constants.dart';

class MyGroupsView extends StatefulWidget {
  const MyGroupsView({Key? key}) : super(key: key);

  @override
  State<MyGroupsView> createState() => _MyGroupsViewState();
}

class _MyGroupsViewState extends State<MyGroupsView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Load groups when the screen initializes
    context.read<GroupBloc>().add(GetMyGroupsEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<GroupBloc, GroupState>(
        listener: (context, state) {
          if (state is GroupErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.error)),
                  ],
                ),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            );
          } else if (state is GroupCreatedState) {
            // Refresh the list after creating a new group
            context.read<GroupBloc>().add(GetMyGroupsEvent());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Tạo nhóm thành công'),
                  ],
                ),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GroupLoadingState) {
            return const LoadingIndicator();
          } else if (state is MyGroupsLoadedState) {
            if (state.groups.isEmpty) {
              return _buildEmptyGroupMessage();
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<GroupBloc>().add(GetMyGroupsEvent());
              },
              child: _buildGroupsList(state.groups),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () => _showCreateGroupDialog(context),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        elevation: 0,
        icon: const Icon(Icons.add, size: 20),
        label: const Text(
          'Tạo nhóm',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildEmptyGroupMessage() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.marginLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.groups_outlined,
                size: 64,
                color: AppColors.primary.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: AppDimens.marginLarge),
            const Text(
              'Chưa có nhóm nào',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimens.marginRegular),
            Text(
              'Tạo nhóm mới hoặc chờ lời mời từ thành viên khác để bắt đầu làm việc nhóm',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: AppDimens.marginExtraLarge),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showCreateGroupDialog(context),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Tạo nhóm mới'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textLight,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimens.radiusMedium),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupsList(List<GroupModel> groups) {
    // Get current user id from AuthBloc
    final authState = context.watch<AuthBloc>().state;
    String? currentUserId;

    if (authState is Authenticated) {
      currentUserId = authState.user['id']?.toString();
    }

    return ListView.builder(
      itemCount: groups.length,
      padding: const EdgeInsets.all(AppDimens.marginMedium),
      itemBuilder: (context, index) {
        final group = groups[index];
        final isLeader =
            currentUserId != null && group.leaderId == currentUserId;

        return Container(
          margin: const EdgeInsets.only(bottom: AppDimens.marginMedium),
          child: Card(
            elevation: 2,
            shadowColor: AppColors.primary.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupDetailView(group: group),
                  ),
                ).then((_) {
                  // Refresh the groups list when returning from details page
                  context.read<GroupBloc>().add(GetMyGroupsEvent());
                });
              },
              borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.marginMedium),
                child: Row(
                  children: [
                    // Group Avatar
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isLeader
                            ? AppColors.accent.withOpacity(0.2)
                            : AppColors.primary.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(AppDimens.radiusMedium),
                      ),
                      child: Icon(
                        isLeader ? Icons.star : Icons.group,
                        color: isLeader ? AppColors.accent : AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppDimens.marginMedium),
                    // Group Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            group.name ?? 'Nhóm',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isLeader
                                  ? AppColors.accent.withOpacity(0.2)
                                  : AppColors.info.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(
                                  AppDimens.radiusRegular),
                            ),
                            child: Text(
                              isLeader ? 'Trưởng nhóm' : 'Thành viên',
                              style: TextStyle(
                                color: isLeader
                                    ? AppColors.accent
                                    : AppColors.info,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Arrow Icon
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
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
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Ví dụ: Nhóm 1, Nhóm ABC...',
                  labelText: 'Tên nhóm *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusRegular),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusRegular),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.marginMedium,
                    vertical: AppDimens.marginMedium,
                  ),
                ),
                autofocus: true,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Hủy',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusRegular),
                ),
              ),
              child: const Text(
                'Tạo nhóm',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  context.read<GroupBloc>().add(
                    CreateGroupEvent(name: nameController.text.trim()),
                  );
                  Navigator.of(dialogContext).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Vui lòng nhập tên nhóm'),
                      backgroundColor: AppColors.warning,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
