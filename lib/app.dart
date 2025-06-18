import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/app_view.dart';
import 'package:thesis_manage_project/repositories/auth_repository.dart';
import 'package:thesis_manage_project/screens/auth/blocs/auth_bloc.dart';
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
      ],
      child: MultiBlocProvider(
        providers: [
          // Auth Bloc
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            )..add(AuthStatusChecked()),
          ),
          // Thêm các Bloc khác ở đây
        ],
        child: const AppView(),
      ),
    );
  }
}
