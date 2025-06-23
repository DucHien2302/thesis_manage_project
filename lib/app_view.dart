import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/config/theme.dart';
import 'package:thesis_manage_project/routes.dart';
import 'package:thesis_manage_project/screens/admin/admin_dashboard.dart';
import 'package:thesis_manage_project/screens/auth/blocs/auth_bloc.dart';
import 'package:thesis_manage_project/screens/auth/views/login_view.dart';
import 'package:thesis_manage_project/screens/dashboard/role_based_dashboard.dart';
import 'package:thesis_manage_project/screens/group/bloc/group_bloc.dart';
import 'package:thesis_manage_project/screens/group/group_screen.dart';
import 'package:thesis_manage_project/screens/group/views/invitations_view.dart';
import 'package:thesis_manage_project/screens/lecturer/lecturer_dashboard.dart';
import 'package:thesis_manage_project/screens/lecturer/lecturer_thesis_screen.dart';
import 'package:thesis_manage_project/screens/lecturer/views/create_thesis_screen.dart';
import 'package:thesis_manage_project/screens/lecturer/bloc/lecturer_thesis_bloc.dart';
import 'package:thesis_manage_project/repositories/lecturer_thesis_repository.dart';
import 'package:thesis_manage_project/utils/api_service.dart';
import 'package:thesis_manage_project/screens/student/student_dashboard.dart';

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,      routes: {
        AppRoutes.groups: (context) => const GroupScreen(),
        AppRoutes.lecturerThesis: (context) => const LecturerThesisScreen(),
        AppRoutes.createThesis: (context) => CreateThesisScreen(
          lecturerThesisBloc: LecturerThesisBloc(
            repository: LecturerThesisRepository(
              apiService: ApiService(),
            ),
          ),
        ),
        AppRoutes.invitations: (context) => BlocProvider.value(
          value: BlocProvider.of<GroupBloc>(context),
          child: const InvitationsView(),
        ),
        AppRoutes.adminDashboard: (context) => const AdminDashboard(),
        AppRoutes.lecturerDashboard: (context) => const LecturerDashboard(),
        AppRoutes.studentDashboard: (context) => const StudentDashboard(),
      },
      home: Builder(
        builder: (context) => Scaffold(
          body: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                    behavior: SnackBarBehavior.floating,
                    action: SnackBarAction(
                      label: 'Đóng',
                      textColor: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              // Hiển thị loading spinner khi đang xử lý
              if (state is AuthLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );              }
                // Khi đã xác thực => hiển thị Role-based Dashboard
              if (state is Authenticated) {
                return const RoleBasedDashboard();
              }
              
              // Khi chưa xác thực => hiển thị Login
              return const LoginView();
            },
          ),
        ),
      ),
    );
  }
}
