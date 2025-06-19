import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/models/group_models.dart';
import 'package:thesis_manage_project/screens/auth/blocs/auth_bloc.dart';
import 'package:thesis_manage_project/screens/group/bloc/group_bloc.dart';
import 'package:thesis_manage_project/widgets/custom_button.dart';
import 'package:thesis_manage_project/widgets/loading_indicator.dart';

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
            Tab(text: 'Đã nhận'),
            Tab(text: 'Đã gửi'),
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
              SnackBar(content: Text(state.error)),
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
              SnackBar(content: Text(message)),
            );
            
            // Reload invites after action
            context.read<GroupBloc>().add(GetMyInvitesEvent());
          }
        },
        builder: (context, state) {
          if (state is GroupLoadingState) {
            return const LoadingIndicator();
          } else if (state is InvitesLoadedState) {
            // Get current user ID from AuthBloc
            final authState = context.watch<AuthBloc>().state;
            String? currentUserId;
    
            if (authState is Authenticated) {
              currentUserId = authState.user['id']?.toString();
            }
            
            final receivedInvites = currentUserId != null 
                ? state.invites.where((invite) => invite.status == 1 && invite.receiverId == currentUserId).toList() 
                : <InviteModel>[];
                
            final sentInvites = currentUserId != null
                ? state.invites.where((invite) => invite.status == 1 && invite.senderId == currentUserId).toList()
                : <InviteModel>[];
            
            return TabBarView(
              controller: _tabController,
              children: [
                _buildReceivedInvitesList(receivedInvites),
                _buildSentInvitesList(sentInvites),
              ],
            );
          } else {
            return const LoadingIndicator(message: 'Đang tải lời mời...');
          }
        },
      ),
    );
  }

  Widget _buildReceivedInvitesList(List<InviteModel> invites) {
    if (invites.isEmpty) {
      return _buildEmptyListMessage('Không có lời mời nào');
    }
    
    return ListView.builder(
      itemCount: invites.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        final invite = invites[index];
        
        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        invite.senderName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Mời bạn tham gia nhóm ${invite.groupName ?? ""}',
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      text: 'Từ chối',
                      onPressed: () => _rejectInvite(invite.id),
                      backgroundColor: Colors.white,
                      textColor: Colors.red,
                      borderColor: Colors.red,
                      fullWidth: false,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                    ),
                    const SizedBox(width: 16),
                    CustomButton(
                      text: 'Chấp nhận',
                      onPressed: () => _acceptInvite(invite.id),
                      backgroundColor: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      fullWidth: false,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSentInvitesList(List<InviteModel> invites) {
    if (invites.isEmpty) {
      return _buildEmptyListMessage('Bạn chưa gửi lời mời nào');
    }
    
    return ListView.builder(
      itemCount: invites.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        final invite = invites[index];
        
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person_outline, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      'Đã gửi lời mời tới', 
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: Text(
                    invite.groupName != null 
                        ? 'Mời tham gia nhóm ${invite.groupName}'
                        : 'Mời tạo nhóm mới',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: CustomButton(
                    text: 'Hủy lời mời',
                    onPressed: () => _revokeInvite(invite.id),
                    backgroundColor: Colors.white,
                    textColor: Colors.red,
                    borderColor: Colors.red,
                    fullWidth: false,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyListMessage(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.mail,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _acceptInvite(String inviteId) {
    context.read<GroupBloc>().add(AcceptInviteEvent(inviteId: inviteId));
    
    // Reload the groups list to show the newly joined group
    Future.delayed(const Duration(milliseconds: 500), () {
      context.read<GroupBloc>().add(GetMyGroupsEvent());
    });
  }

  void _rejectInvite(String inviteId) {
    context.read<GroupBloc>().add(RejectInviteEvent(inviteId: inviteId));
  }

  void _revokeInvite(String inviteId) {
    context.read<GroupBloc>().add(RevokeInviteEvent(inviteId: inviteId));
  }
}
