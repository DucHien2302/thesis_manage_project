import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/screens/admin/admin_dashboard.dart';
import 'package:thesis_manage_project/screens/auth/blocs/auth_bloc.dart';
import 'package:thesis_manage_project/screens/lecturer/lecturer_dashboard.dart';
import 'package:thesis_manage_project/screens/student/student_dashboard.dart';
import 'package:thesis_manage_project/screens/dashboard/views/dashboard_loading_view.dart';
import 'package:thesis_manage_project/screens/dashboard/views/dashboard_error_view.dart';

class RoleBasedDashboard extends StatefulWidget {
  const RoleBasedDashboard({super.key});

  @override
  State<RoleBasedDashboard> createState() => _RoleBasedDashboardState();
}

class _RoleBasedDashboardState extends State<RoleBasedDashboard> {
  int? userType;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserType();
  }

  Future<void> _loadUserType() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUserType = prefs.getInt(AppConfig.userTypeKey);
      
      setState(() {
        userType = savedUserType;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          // Khi có thông tin user mới, load lại user type
          _loadUserType();
        } else if (state is Unauthenticated) {
          // Khi đăng xuất, reset user type
          setState(() {
            userType = null;
            isLoading = false;
          });
        }
      },      child: isLoading
          ? const DashboardLoadingView()
          : _buildDashboardForUserType(),
    );
  }  Widget _buildDashboardForUserType() {
    if (userType == null) {
      return DashboardErrorView(
        onRetry: _loadUserType,
      );
    }
    
    switch (userType) {
      case AppConfig.userTypeAdmin:
        return const AdminDashboard();
      case AppConfig.userTypeLecturer:
        return const LecturerDashboard();
      case AppConfig.userTypeStudent:
        return const StudentDashboard();
      default:
        // Fallback to student dashboard if no user type is set
        return const StudentDashboard();
    }
  }
}
