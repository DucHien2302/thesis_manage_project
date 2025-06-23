import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/app_view.dart';
import 'package:thesis_manage_project/repositories/auth_repository.dart';
import 'package:thesis_manage_project/repositories/group_repository.dart';
import 'package:thesis_manage_project/repositories/mission_repository.dart';
import 'package:thesis_manage_project/repositories/role_repository.dart';
import 'package:thesis_manage_project/repositories/profile_repository.dart';
import 'package:thesis_manage_project/repositories/student_repository.dart';
import 'package:thesis_manage_project/repositories/thesis_repository.dart';
import 'package:thesis_manage_project/screens/auth/blocs/auth_bloc.dart';
import 'package:thesis_manage_project/screens/group/bloc/group_bloc.dart';
import 'package:thesis_manage_project/screens/profile/bloc/profile_bloc.dart';
import 'package:thesis_manage_project/screens/student/bloc/mission_bloc.dart';
import 'package:thesis_manage_project/services/permission_service.dart';
import 'package:thesis_manage_project/utils/api_service.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // API Service
        RepositoryProvider<ApiService>(
          create: (context) => ApiService(),
        ),
        // Auth Repository
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(
            apiService: context.read<ApiService>(),
          ),
        ),
        // Group Repository
        RepositoryProvider<GroupRepository>(
          create: (context) => GroupRepository(
            apiService: context.read<ApiService>(),
          ),
        ),        // Role Repository
        RepositoryProvider<RoleRepository>(
          create: (context) => RoleRepository(
            apiService: context.read<ApiService>(),
          ),
        ),        // Profile Repository
        RepositoryProvider<ProfileRepository>(
          create: (context) => ProfileRepository(
            apiService: context.read<ApiService>(),
          ),        ),
        // Student Repository
        RepositoryProvider<StudentRepository>(
          create: (context) => StudentRepository(
            apiService: context.read<ApiService>(),
          ),
        ),
        // Thesis Repository
        RepositoryProvider<ThesisRepository>(
          create: (context) => ThesisRepository(
            apiService: context.read<ApiService>(),
          ),
        ),        // Permission Service
        RepositoryProvider<PermissionService>(
          create: (context) => PermissionService(
            roleRepository: context.read<RoleRepository>(),
          ),
        ),        // Mission Repository
        RepositoryProvider<MissionRepository>(
          create: (context) => MissionRepository(
            apiService: context.read<ApiService>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          // Auth Bloc
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
              permissionService: context.read<PermissionService>(),
            )..add(AuthStatusChecked()),
          ),          // Group Bloc
          BlocProvider<GroupBloc>(
            create: (context) => GroupBloc(
              groupRepository: context.read<GroupRepository>(),
            ),
          ),          // Profile Bloc
          BlocProvider<ProfileBloc>(
            create: (context) => ProfileBloc(
              profileRepository: context.read<ProfileRepository>(),
            ),
          ),          // Mission Bloc
          BlocProvider<MissionBloc>(
            create: (context) => MissionBloc(
              missionRepository: context.read<MissionRepository>(),
            ),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}
