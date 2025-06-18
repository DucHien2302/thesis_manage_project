import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/app.dart';
import 'package:thesis_manage_project/simple_bloc_observer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Đăng ký BlocObserver để theo dõi trạng thái Bloc
  Bloc.observer = SimpleBlocObserver();
  
  runApp(const App());
}
