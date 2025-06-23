import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/models/thesis_approval_models.dart';
import 'package:thesis_manage_project/repositories/thesis_approval_repository.dart';
import 'package:thesis_manage_project/screens/lecturer/bloc/thesis_approval_bloc.dart';
import 'package:thesis_manage_project/screens/lecturer/views/thesis_approval_department_view.dart';
import 'package:thesis_manage_project/screens/lecturer/views/thesis_approval_faculty_view.dart';
import 'package:thesis_manage_project/utils/api_service.dart';

class ThesisApprovalScreen extends StatefulWidget {
  const ThesisApprovalScreen({super.key});

  @override
  State<ThesisApprovalScreen> createState() => _ThesisApprovalScreenState();
}

class _ThesisApprovalScreenState extends State<ThesisApprovalScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ThesisApprovalBloc _departmentBloc;
  late ThesisApprovalBloc _facultyBloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Create separate BLoC instances for each approval type
    _departmentBloc = ThesisApprovalBloc(
      repository: ThesisApprovalRepository(apiService: ApiService()),
    );
    _facultyBloc = ThesisApprovalBloc(
      repository: ThesisApprovalRepository(apiService: ApiService()),
    );

    // Listen to tab changes and load appropriate data
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        if (_tabController.index == 0) {
          _departmentBloc.add(const LoadThesesForApproval(ApprovalType.department));
        } else {
          _facultyBloc.add(const LoadThesesForApproval(ApprovalType.faculty));
        }
      }
    });

    // Load initial data for department tab
    _departmentBloc.add(const LoadThesesForApproval(ApprovalType.department));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _departmentBloc.close();
    _facultyBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThesisApprovalBloc>.value(value: _departmentBloc),
        BlocProvider<ThesisApprovalBloc>.value(value: _facultyBloc),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Duyệt đề tài',
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
            ),
            tabs: const [
              Tab(
                icon: Icon(Icons.domain),
                text: 'Duyệt cấp bộ môn',
              ),
              Tab(
                icon: Icon(Icons.school),
                text: 'Duyệt cấp khoa',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            BlocProvider<ThesisApprovalBloc>.value(
              value: _departmentBloc,
              child: const ThesisApprovalDepartmentView(),
            ),
            BlocProvider<ThesisApprovalBloc>.value(
              value: _facultyBloc,
              child: const ThesisApprovalFacultyView(),
            ),
          ],
        ),
      ),
    );
  }
}
