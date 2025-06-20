import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/screens/group/bloc/group_bloc.dart';
import 'package:thesis_manage_project/screens/group/group_screen.dart';
import 'package:thesis_manage_project/screens/group/views/invitations_view.dart';
import 'package:thesis_manage_project/screens/group/views/student_list_view.dart';

class AppRoutes {
  static const home = '/';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
  static const profile = '/profile';
  static const groups = '/groups';
  static const invitations = '/invitations';
  static const students = '/students';
  static const theses = '/theses';
  static const thesisDetails = '/thesis-details';
  static const thesisRegistration = '/thesis-registration';
  static const adminDashboard = '/admin-dashboard';
  static const lecturerDashboard = '/lecturer-dashboard';
  static const studentDashboard = '/student-dashboard';
}

final Map<String, WidgetBuilder> routes = {
  AppRoutes.groups: (context) => const GroupScreen(),
  AppRoutes.invitations: (context) => BlocProvider.value(
        value: BlocProvider.of<GroupBloc>(context),
        child: const InvitationsView(),
      ),
  AppRoutes.students: (context) => BlocProvider.value(
        value: BlocProvider.of<GroupBloc>(context),
        child: const StudentListView(),
      ),
  // Add other routes here as they are implemented
};
