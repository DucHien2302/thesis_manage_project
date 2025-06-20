import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/repositories/group_repository.dart';
import 'package:thesis_manage_project/screens/group/bloc/group_bloc.dart';
import 'package:thesis_manage_project/screens/group/views/invitations_view.dart';
import 'package:thesis_manage_project/screens/group/views/my_groups_view.dart';
import 'package:thesis_manage_project/screens/group/views/student_list_view.dart';
import 'package:thesis_manage_project/utils/api_service.dart';
import 'package:thesis_manage_project/config/constants.dart';

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
        length: 3,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text(
              'Quản lý nhóm',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textLight,
            elevation: 0,
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: AppColors.textLight,
              indicatorWeight: 3,
              labelColor: AppColors.textLight,
              unselectedLabelColor: AppColors.textLight.withOpacity(0.7),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
              tabs: const [
                Tab(
                  text: 'Nhóm của tôi',
                  icon: Icon(Icons.groups, size: 20),
                ),
                Tab(
                  text: 'Lời mời',
                  icon: Icon(Icons.mail_outline, size: 20),
                ),
                Tab(
                  text: 'Mời thành viên',
                  icon: Icon(Icons.person_add_alt, size: 20),
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              MyGroupsView(),
              InvitationsView(),
              StudentListView(),
            ],
          ),
        ),
      ),
    );
  }
}
