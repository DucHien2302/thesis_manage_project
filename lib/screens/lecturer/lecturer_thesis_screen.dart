import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/screens/lecturer/bloc/lecturer_thesis_bloc.dart';
import 'package:thesis_manage_project/screens/lecturer/views/thesis_management_view.dart';
import 'package:thesis_manage_project/screens/lecturer/views/thesis_overview_view.dart';
import 'package:thesis_manage_project/screens/lecturer/views/thesis_approval_screen.dart';
import 'package:thesis_manage_project/repositories/lecturer_thesis_repository.dart';
import 'package:thesis_manage_project/utils/api_service.dart';
import 'package:thesis_manage_project/config/constants.dart';

class LecturerThesisScreen extends StatefulWidget {
  const LecturerThesisScreen({Key? key}) : super(key: key);

  @override
  State<LecturerThesisScreen> createState() => _LecturerThesisScreenState();
}

class _LecturerThesisScreenState extends State<LecturerThesisScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;  @override
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
    // Không load data tại đây nữa vì context chưa sẵn sàng
    // Để các view tự load data khi được build
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LecturerThesisBloc(
        repository: LecturerThesisRepository(
          apiService: ApiService(),
        ),
      )..add(const LoadLecturerTheses()),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'Quản lý đề tài',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),            tabs: const [
              Tab(
                icon: Icon(Icons.dashboard_outlined),
                text: 'Tổng quan',
              ),
              Tab(
                icon: Icon(Icons.assignment_outlined),
                text: 'Quản lý đề tài',
              ),              Tab(
                icon: Icon(Icons.check_circle_outline),
                text: 'Duyệt đề tài',
              ),
            ],
          ),
        ),        body: TabBarView(
          controller: _tabController,
          children: [
            ThesisOverviewView(tabController: _tabController),
            const ThesisManagementView(),
            const ThesisApprovalScreen(),
          ],
        ),
      ),
    );
  }
}
