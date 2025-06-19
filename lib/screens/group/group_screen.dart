import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/repositories/group_repository.dart';
import 'package:thesis_manage_project/screens/group/bloc/group_bloc.dart';
import 'package:thesis_manage_project/screens/group/views/invitations_view.dart';
import 'package:thesis_manage_project/screens/group/views/my_groups_view.dart';
import 'package:thesis_manage_project/utils/api_service.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupBloc(
        groupRepository: GroupRepository(
          apiService: ApiService(),
        ),
      ),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Quản lý nhóm'),            bottom: const TabBar(
              tabs: [
                Tab(text: 'Nhóm của tôi', icon: Icon(Icons.group)),
                Tab(text: 'Lời mời', icon: Icon(Icons.mail)),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              MyGroupsView(),
              InvitationsView(),
            ],
          ),
        ),
      ),
    );
  }
}
