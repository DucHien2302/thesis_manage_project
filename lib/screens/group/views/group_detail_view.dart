import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/models/group_models.dart';
import 'package:thesis_manage_project/screens/auth/blocs/auth_bloc.dart';
import 'package:thesis_manage_project/screens/group/bloc/group_bloc.dart';
import 'package:thesis_manage_project/screens/group/views/invite_member_view.dart';
import 'package:thesis_manage_project/screens/thesis_registration/blocs/thesis_registration_bloc.dart';
import 'package:thesis_manage_project/screens/thesis_registration/views/thesis_list_view.dart';
import 'package:thesis_manage_project/services/thesis_service.dart';
import 'package:thesis_manage_project/widgets/custom_button.dart';
import 'package:thesis_manage_project/widgets/loading_indicator.dart';
import 'package:thesis_manage_project/config/constants.dart';

class GroupDetailView extends StatefulWidget {
  final GroupModel group;

  const GroupDetailView({Key? key, required this.group}) : super(key: key);

  @override
  State<GroupDetailView> createState() => _GroupDetailViewState();
}

class _GroupDetailViewState extends State<GroupDetailView> {
  late GroupModel currentGroup;
  bool _isTransferringLeadership = false;

  @override
  void initState() {
    super.initState();
    currentGroup = widget.group;
    // Load group members when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<GroupBloc>().add(GetGroupMembersEvent(groupId: currentGroup.id));
      }
    });
  }

  bool _isLeader(String? currentUserId) => currentUserId != null && currentGroup.leaderId == currentUserId;

  bool _isCurrentUserMember(List<MemberDetailModel> members, String? currentUserId) {
    if (currentUserId == null) return false;
    return members.any((member) => member.userId == currentUserId);
  }

  int _getCurrentMemberCount() {
    final state = context.read<GroupBloc>().state;
    if (state is GroupMembersLoadedState) {
      return state.members.length;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        String? currentUserId;
        if (authState is Authenticated) {
          currentUserId = authState.user['id']?.toString();
        }

        return WillPopScope(
          onWillPop: () async {
            context.read<GroupBloc>().add(GetMyGroupsEvent());
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(currentGroup.name ?? 'Nhóm'),
              actions: [
                if (_isLeader(currentUserId))
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditGroupDialog(context);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Đổi tên nhóm'),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            body: BlocListener<GroupBloc, GroupState>(
              listener: (context, state) {
                if (state is GroupErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                } else if (state is MemberRemovedState) {
                  context.read<GroupBloc>().add(GetGroupMembersEvent(groupId: currentGroup.id));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã xóa thành viên khỏi nhóm')),
                  );
                } else if (state is LeadershipTransferredState) {
                  _isTransferringLeadership = true;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã chuyển quyền nhóm trưởng')),
                  );
                  context.read<GroupBloc>().add(GetMyGroupsEvent());
                  context.read<GroupBloc>().add(GetGroupMembersEvent(groupId: currentGroup.id));
                } else if (state is MyGroupsLoadedState && _isTransferringLeadership) {
                  _isTransferringLeadership = false;
                  if (mounted) {
                    Navigator.pop(context);
                  }
                } else if (state is GroupNameUpdatedState) {
                  setState(() {
                    currentGroup = state.updatedGroup;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã cập nhật tên nhóm')),
                  );
                  // Load complete group details after name update
                  context.read<GroupBloc>().add(GetGroupDetailsEvent(groupId: currentGroup.id));
                } else if (state is GroupDetailsLoadedState) {
                  setState(() {
                    currentGroup = state.group;
                  });
                  context.read<GroupBloc>().add(GetGroupMembersEvent(groupId: currentGroup.id));
                } else if (state is GroupDissolvedState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nhóm đã được giải tán thành công')),
                  );
                  Navigator.pop(context);
                }
              },
              child: BlocBuilder<GroupBloc, GroupState>(
                builder: (context, state) {
                  if (state is GroupMembersLoadedState) {
                    if (!_isCurrentUserMember(state.members, currentUserId)) {
                      return _buildNotMemberView();
                    }
                    return _buildGroupDetails(state.members, currentUserId);
                  } else if (state is GroupErrorState) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text('Có lỗi xảy ra'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<GroupBloc>().add(GetGroupMembersEvent(groupId: currentGroup.id));
                            },
                            child: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const LoadingIndicator(message: 'Đang tải dữ liệu nhóm...');
                  }
                },
              ),
            ),
            floatingActionButton: (_isLeader(currentUserId) && _getCurrentMemberCount() < 3)
                ? FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InviteMemberView(groupId: currentGroup.id),
                        ),
                      );
                    },
                    child: const Icon(Icons.person_add),
                  )
                : null,
          ),
        );
      },
    );
  }

  Widget _buildNotMemberView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.block,
              size: 80,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 24),
            Text(
              'Không có quyền truy cập',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Bạn không còn là thành viên của nhóm này hoặc đã bị loại khỏi nhóm.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                context.read<GroupBloc>().add(GetMyGroupsEvent());
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Quay lại danh sách nhóm'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupDetails(List<MemberDetailModel> members, String? currentUserId) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thông tin nhóm',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const Divider(height: 24),                  _infoRow('Tên nhóm:', currentGroup.name ?? 'Chưa có tên'),
                  const SizedBox(height: 8),
                  _infoRow('ID nhóm:', currentGroup.id),
                  const SizedBox(height: 8),
                  _infoRow('Số thành viên:', '${members.length}/3'),
                  const SizedBox(height: 8),
                  _infoRow('Trạng thái đề tài:', currentGroup.thesisId != null ? 'Đã đăng ký đề tài' : 'Chưa đăng ký đề tài'),
                  if (currentGroup.thesisId != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green.shade800, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Nhóm đã đăng ký đề tài thành công',
                              style: TextStyle(
                                color: Colors.green.shade800,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (members.length >= 3) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.orange.shade800, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Nhóm đã đạt tối đa 3 thành viên',
                              style: TextStyle(
                                color: Colors.orange.shade800,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Danh sách thành viên',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          _buildMembersList(members, currentUserId),
          const SizedBox(height: 24),
          if (_isLeader(currentUserId)) ...[
            if (members.length < 3) ...[
              CustomButton(
                text: 'Mời thành viên',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InviteMemberView(groupId: currentGroup.id),
                    ),
                  );
                },
                backgroundColor: AppColors.primary,
                textColor: Colors.white,
              ),
              const SizedBox(height: 16),            ],            CustomButton(
              text: currentGroup.thesisId != null ? 'Đã đăng ký đề tài' : 'Đăng ký đề tài',
              onPressed: currentGroup.thesisId != null ? null : () => _navigateToThesisRegistration(context),
              backgroundColor: currentGroup.thesisId != null ? Colors.grey : AppColors.accent,
              textColor: Colors.white,
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Đổi tên nhóm',
              onPressed: () => _showEditGroupDialog(context),
              backgroundColor: Colors.blueAccent,
              textColor: Colors.white,
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Giải tán nhóm',
              onPressed: () => _showDissolveGroupConfirmation(context),
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }

  Widget _buildMembersList(List<MemberDetailModel> members, String? currentUserId) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        final bool memberIsLeader = member.isLeader;
        final bool currentUserIsThisMember = member.userId == currentUserId;

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 8),
          color: memberIsLeader ? Colors.amber.shade50 : null,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: memberIsLeader ? Colors.amber : Colors.blue.shade100,
              child: Icon(
                memberIsLeader ? Icons.stars : Icons.person,
                color: memberIsLeader ? Colors.orange.shade800 : Colors.blue,
              ),
            ),
            title: Text(
              member.fullName,              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: currentUserIsThisMember ? AppColors.primary : Colors.black,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MSSV: ${member.studentCode}'),
                Text(
                  memberIsLeader ? 'Trưởng nhóm' : 'Thành viên',
                  style: TextStyle(
                    color: memberIsLeader ? Colors.orange.shade800 : Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            trailing: _isLeader(currentUserId) && !currentUserIsThisMember
                ? PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'transfer_leader') {
                        _showTransferLeaderConfirmation(context, member);
                      } else if (value == 'remove') {
                        _showRemoveMemberConfirmation(context, member);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'transfer_leader',
                        child: Row(
                          children: [
                            Icon(Icons.arrow_upward, color: Colors.amber),
                            SizedBox(width: 8),
                            Text('Chuyển quyền trưởng nhóm'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'remove',
                        child: Row(
                          children: [
                            Icon(Icons.remove_circle, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Xóa khỏi nhóm'),
                          ],
                        ),
                      ),
                    ],
                  )
                : null,
          ),
        );
      },
    );
  }

  void _showEditGroupDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: currentGroup.name);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Đổi tên nhóm'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Nhập tên nhóm mới',
              labelText: 'Tên nhóm',
            ),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Lưu'),
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  context.read<GroupBloc>().add(
                        UpdateGroupNameEvent(
                          groupId: currentGroup.id,
                          newName: nameController.text.trim(),
                        ),
                      );
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showTransferLeaderConfirmation(BuildContext context, MemberDetailModel member) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Chuyển quyền trưởng nhóm'),
          content: Text(
            'Bạn có chắc chắn muốn chuyển quyền trưởng nhóm cho ${member.fullName}? '
            'Bạn sẽ trở thành thành viên thường sau khi chuyển quyền.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Chuyển quyền'),
              onPressed: () {
                context.read<GroupBloc>().add(
                      TransferGroupLeadershipEvent(
                        groupId: currentGroup.id,
                        newLeaderId: member.userId,
                      ),
                    );
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showRemoveMemberConfirmation(BuildContext context, MemberDetailModel member) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Xóa thành viên'),
          content: Text('Bạn có chắc chắn muốn xóa ${member.fullName} khỏi nhóm?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
              onPressed: () {
                context.read<GroupBloc>().add(
                      RemoveGroupMemberEvent(
                        groupId: currentGroup.id,
                        memberId: member.userId,
                      ),
                    );
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDissolveGroupConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Giải tán nhóm'),
          content: const Text(
            'Bạn có chắc chắn muốn giải tán nhóm này? '
            'Thao tác này sẽ xóa nhóm và loại bỏ tất cả thành viên khỏi nhóm. '
            'Thao tác này không thể hoàn tác.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Giải tán nhóm', style: TextStyle(color: Colors.red)),
              onPressed: () {
                context.read<GroupBloc>().add(
                      DissolveGroupEvent(groupId: currentGroup.id),
                    );
                Navigator.of(dialogContext).pop();
              },
            ),
          ],        );
      },
    );
  }  void _navigateToThesisRegistration(BuildContext context) {
    // Kiểm tra xem nhóm đã đăng ký đề tài hay chưa
    if (currentGroup.thesisId != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nhóm này đã đăng ký đề tài rồi'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Lấy user ID từ auth state
    final authState = context.read<AuthBloc>().state;
    String? currentUserId;
    if (authState is Authenticated) {
      currentUserId = authState.user['id']?.toString();
    }

    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể xác định thông tin người dùng'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ThesisRegistrationBloc(
            thesisService: ThesisService(),
          ),
          child: ThesisListView(studentId: currentUserId!), // Safe to use ! here due to null check above
        ),
      ),
    ).then((result) {
      // Refresh group data nếu có thay đổi
      if (result != null) {
        context.read<GroupBloc>().add(GetGroupMembersEvent(groupId: currentGroup.id));
      }
    });
  }
}