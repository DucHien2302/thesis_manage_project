import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/screens/group/bloc/group_bloc.dart';
import 'package:thesis_manage_project/screens/group/views/invitations_view.dart';
import 'package:thesis_manage_project/screens/group/views/my_groups_view.dart';
import 'package:thesis_manage_project/screens/group/views/student_list_view.dart';
import 'package:thesis_manage_project/config/constants.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({Key? key}) : super(key: key);

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Listen to tab changes
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      // Tab changed programmatically or user finished swiping
      if (_tabController.index == 0) {
        // Tab "Nhóm của tôi" was selected
        if (mounted) {
          context.read<GroupBloc>().add(GetMyGroupsEvent());
        }
      } else if (_tabController.index == 1) {
        // Tab "Lời mời" was selected
        if (mounted) {
          context.read<GroupBloc>().add(GetMyInvitesEvent());
        }
      } else if (_tabController.index == 2) {
        // Tab "Mời thành viên" was selected
        if (mounted) {
          context.read<GroupBloc>().add(GetMyGroupsEvent());
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            controller: _tabController,
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
        body: TabBarView(
          controller: _tabController,          children: const [
            MyGroupsView(),
            InvitationsView(),
            StudentListView(),
          ],
        ),
    );
  }
}
