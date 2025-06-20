import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/models/group_models.dart';
import 'package:thesis_manage_project/screens/group/bloc/group_bloc.dart';
import 'package:thesis_manage_project/components/animated_loading.dart';
import 'package:thesis_manage_project/config/constants.dart';

class InvitationsView extends StatefulWidget {
  const InvitationsView({Key? key}) : super(key: key);

  @override
  State<InvitationsView> createState() => _InvitationsViewState();
}

class _InvitationsViewState extends State<InvitationsView>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Load invitations when the screen initializes
    context.read<GroupBloc>().add(GetMyInvitesEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Custom Tab Bar
          Container(
            margin: const EdgeInsets.all(AppDimens.marginMedium),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
              ),
              labelColor: AppColors.textLight,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              tabs: const [
                Tab(
                  text: 'Đã nhận',
                  icon: Icon(Icons.inbox, size: 18),
                ),
                Tab(
                  text: 'Đã gửi',
                  icon: Icon(Icons.send, size: 18),
                ),
              ],
            ),
          ),
          // Tab Content
          Expanded(
            child: BlocConsumer<GroupBloc, GroupState>(
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
                } else if (state is InviteActionSuccessState) {
                  String message;
                  Color backgroundColor;
                  IconData icon;
                  
                  switch (state.action) {
                    case "accepted":
                      message = 'Đã chấp nhận lời mời';
                      backgroundColor = AppColors.success;
                      icon = Icons.check_circle_outline;
                      break;
                    case "rejected":
                      message = 'Đã từ chối lời mời';
                      backgroundColor = AppColors.warning;
                      icon = Icons.cancel_outlined;
                      break;
                    case "revoked":
                      message = 'Đã hủy lời mời';
                      backgroundColor = AppColors.info;
                      icon = Icons.undo_outlined;
                      break;
                    default:
                      message = 'Đã xử lý lời mời';
                      backgroundColor = AppColors.success;
                      icon = Icons.check_circle_outline;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(icon, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(message),
                        ],
                      ),
                      backgroundColor: backgroundColor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  );

                  // Reload invites after action
                  context.read<GroupBloc>().add(GetMyInvitesEvent());
                }
              },
              builder: (context, state) {
                if (state is GroupLoadingState) {
                  return const Center(child: AnimatedLoadingIndicator());
                } else if (state is InvitesLoadedState) {
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildReceivedInvitesList(state.allInvites.receivedInvites),
                      _buildSentInvitesList(state.allInvites.sentInvites),
                    ],
                  );
                } else {
                  return _buildEmptyState();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
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
              Icons.inbox,
              size: 48,
              color: AppColors.primary.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: AppDimens.marginMedium),
          const Text(
            'Đang tải lời mời...',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceivedInvitesList(List<InviteDetailModel> invites) {
    // Filter pending invites only
    final pendingInvites =
        invites.where((invite) => invite.status == 1).toList();

    if (pendingInvites.isEmpty) {
      return _buildEmptyListMessage(
        'Không có lời mời nào',
        Icons.inbox_outlined,
        'Bạn chưa nhận được lời mời tham gia nhóm nào.',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<GroupBloc>().add(GetMyInvitesEvent());
      },
      child: ListView.builder(
        itemCount: pendingInvites.length,
        padding: const EdgeInsets.all(AppDimens.marginMedium),
        itemBuilder: (context, index) {
          final invite = pendingInvites[index];
          return _buildReceivedInviteCard(invite);
        },
      ),
    );
  }

  Widget _buildSentInvitesList(List<InviteDetailModel> invites) {
    // Filter pending invites only
    final pendingInvites =
        invites.where((invite) => invite.status == 1).toList();
    
    if (pendingInvites.isEmpty) {
      return _buildEmptyListMessage(
        'Bạn chưa gửi lời mời nào',
        Icons.send_outlined,
        'Hãy mời bạn bè tham gia nhóm của bạn.',
      );
    }
    
    return RefreshIndicator(
      onRefresh: () async {
        context.read<GroupBloc>().add(GetMyInvitesEvent());
      },
      child: ListView.builder(
        itemCount: pendingInvites.length,
        padding: const EdgeInsets.all(AppDimens.marginMedium),
        itemBuilder: (context, index) {
          final invite = pendingInvites[index];
          return _buildSentInviteCard(invite);
        },
      ),
    );
  }

  Widget _buildEmptyListMessage(String title, IconData icon, String message) {
    return Center(
      child: SingleChildScrollView(
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
                icon,
                size: 48,
                color: AppColors.primary.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: AppDimens.marginMedium),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimens.marginRegular),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceivedInviteCard(InviteDetailModel invite) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.marginMedium),
      child: Card(
        elevation: 2,
        shadowColor: AppColors.primary.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.marginMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sender Info
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                    ),
                    child: Icon(
                      Icons.person,
                      color: AppColors.success,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppDimens.marginMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          invite.sender.fullName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (invite.sender.studentCode != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            'MSSV: ${invite.sender.studentCode}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.marginMedium),
              // Group Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimens.radiusRegular),
                  border: Border.all(color: AppColors.info.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.groups, color: AppColors.info, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        invite.group?.name != null
                            ? 'Mời bạn tham gia nhóm "${invite.group!.name}"'
                            : 'Mời bạn tham gia nhóm',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.marginMedium),
              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _rejectInvite(invite.id),
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Từ chối'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimens.radiusRegular),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimens.marginMedium),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _acceptInvite(invite.id),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Chấp nhận'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: AppColors.textLight,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimens.radiusRegular),
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
      ),
    );
  }

  Widget _buildSentInviteCard(InviteDetailModel invite) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.marginMedium),
      child: Card(
        elevation: 2,
        shadowColor: AppColors.accent.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.marginMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Receiver Info
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                    ),
                    child: Icon(
                      Icons.person_outline,
                      color: AppColors.accent,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppDimens.marginMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          invite.receiver.fullName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (invite.receiver.studentCode != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            'MSSV: ${invite.receiver.studentCode}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppDimens.radiusRegular),
                    ),
                    child: Text(
                      'Chờ phản hồi',
                      style: TextStyle(
                        color: AppColors.warning,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.marginMedium),
              // Group Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimens.radiusRegular),
                  border: Border.all(color: AppColors.info.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.groups, color: AppColors.info, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        invite.group?.name != null
                            ? 'Đã mời tham gia nhóm "${invite.group!.name}"'
                            : 'Đã mời tham gia nhóm',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.marginMedium),
              // Revoke Action
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _revokeInvite(invite.id),
                    icon: Icon(Icons.cancel_outlined, size: 18),
                    label: const Text('Hủy lời mời'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.warning,
                      side: BorderSide(color: AppColors.warning),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.marginMedium,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.radiusRegular),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _acceptInvite(String inviteId) {
    context.read<GroupBloc>().add(AcceptInviteEvent(inviteId: inviteId));
  }

  void _rejectInvite(String inviteId) {
    context.read<GroupBloc>().add(RejectInviteEvent(inviteId: inviteId));
  }

  void _revokeInvite(String inviteId) {
    context.read<GroupBloc>().add(RevokeInviteEvent(inviteId: inviteId));
  }
}
