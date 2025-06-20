import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/models/group_models.dart';
import 'package:thesis_manage_project/screens/group/bloc/group_bloc.dart';
import 'package:thesis_manage_project/components/animated_loading.dart';

class InvitationsView extends StatefulWidget {
  const InvitationsView({Key? key}) : super(key: key);

  @override
  State<InvitationsView> createState() => _InvitationsViewState();
}

class _InvitationsViewState extends State<InvitationsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lời mời nhóm'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Đã nhận', icon: Icon(Icons.inbox)),
            Tab(text: 'Đã gửi', icon: Icon(Icons.send)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<GroupBloc>().add(GetMyInvitesEvent());
            },
          ),
        ],
      ),
      body: BlocConsumer<GroupBloc, GroupState>(
        listener: (context, state) {
          if (state is GroupErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is InviteActionSuccessState) {
            String message;
            switch (state.action) {
              case "accepted":
                message = 'Đã chấp nhận lời mời';
                break;
              case "rejected":  
                message = 'Đã từ chối lời mời';
                break;
              case "revoked":
                message = 'Đã hủy lời mời';
                break;
              default:
                message = 'Đã xử lý lời mời';
            }
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.green,
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
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Đang tải lời mời...',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildReceivedInvitesList(List<InviteDetailModel> invites) {
    // Filter pending invites only
    final pendingInvites = invites.where((invite) => invite.status == 1).toList();
    
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
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, index) {
          final invite = pendingInvites[index];
          return _buildReceivedInviteCard(invite);
        },
      ),
    );
  }

  Widget _buildSentInvitesList(List<InviteDetailModel> invites) {
    // Filter pending invites only
    final pendingInvites = invites.where((invite) => invite.status == 1).toList();
    
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
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, index) {
          final invite = pendingInvites[index];
          return _buildSentInviteCard(invite);
        },
      ),
    );
  }

  Widget _buildReceivedInviteCard(InviteDetailModel invite) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Text(
                    invite.sender.fullName.isNotEmpty
                        ? invite.sender.fullName[0].toUpperCase()
                        : 'S',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        invite.sender.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (invite.sender.studentCode != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          'MSSV: ${invite.sender.studentCode}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.group, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      invite.group?.name != null
                          ? 'Mời bạn tham gia nhóm "${invite.group!.name}"'
                          : 'Mời bạn tham gia nhóm',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _rejectInvite(invite.id),
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text('Từ chối'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => _acceptInvite(invite.id),
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Chấp nhận'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSentInviteCard(InviteDetailModel invite) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.orange.withOpacity(0.1),
                  child: Text(
                    invite.receiver.fullName.isNotEmpty
                        ? invite.receiver.fullName[0].toUpperCase()
                        : 'R',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        invite.receiver.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (invite.receiver.studentCode != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          'MSSV: ${invite.receiver.studentCode}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.schedule, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      invite.group?.name != null
                          ? 'Đã mời tham gia nhóm "${invite.group!.name}"'
                          : 'Đang chờ phản hồi',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _revokeInvite(invite.id),
                  icon: const Icon(Icons.cancel, size: 18),
                  label: const Text('Hủy mời'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange,
                    side: const BorderSide(color: Colors.orange),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyListMessage(String title, IconData icon, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
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
