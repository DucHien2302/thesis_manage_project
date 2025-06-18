import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/models/group_models.dart';
import 'package:thesis_manage_project/screens/auth/blocs/auth_bloc.dart';
import 'package:thesis_manage_project/screens/group/bloc/group_bloc.dart';
import 'package:thesis_manage_project/screens/group/views/group_detail_view.dart';
import 'package:thesis_manage_project/widgets/custom_button.dart';
import 'package:thesis_manage_project/widgets/loading_indicator.dart';

class MyGroupsView extends StatefulWidget {
  const MyGroupsView({Key? key}) : super(key: key);

  @override
  State<MyGroupsView> createState() => _MyGroupsViewState();
}

class _MyGroupsViewState extends State<MyGroupsView> {
  @override
  void initState() {
    super.initState();
    // Load groups when the screen initializes
    context.read<GroupBloc>().add(GetMyGroupsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý nhóm'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<GroupBloc>().add(GetMyGroupsEvent());
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
          } else if (state is GroupCreatedState) {
            // Refresh the list after creating a new group
            context.read<GroupBloc>().add(GetMyGroupsEvent());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tạo nhóm thành công')),
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
            return _buildGroupsList(state.groups);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateGroupDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyGroupMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.group_off,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'Bạn chưa tham gia nhóm nào',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tạo nhóm mới hoặc chờ lời mời từ thành viên khác',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Tạo nhóm mới',
            onPressed: () => _showCreateGroupDialog(context),
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.white,
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Xem lời mời',
            onPressed: () => Navigator.pushNamed(context, '/invitations'),
            backgroundColor: Colors.white,
            textColor: Theme.of(context).primaryColor,
            borderColor: Theme.of(context).primaryColor,
          ),
        ],
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
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        final group = groups[index];
        final isLeader = currentUserId != null && group.leaderId == currentUserId;
        
        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              group.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                isLeader ? 'Vai trò: Trưởng nhóm' : 'Vai trò: Thành viên',
                style: TextStyle(
                  color: isLeader ? Colors.green : Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
          title: const Text('Tạo nhóm mới'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Nhập tên nhóm',
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
              child: const Text('Tạo'),
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  context.read<GroupBloc>().add(
                    CreateGroupEvent(name: nameController.text.trim()),
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
}
