import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thesis_manage_project/repositories/auth_repository.dart';

// Auth Events
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  LoginRequested({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

class RegisterRequested extends AuthEvent {
  final String username;
  final String password;
  final int userType;

  RegisterRequested({
    required this.username, 
    required this.password, 
    required this.userType
  });

  @override
  List<Object?> get props => [username, password, userType];
}

class LogoutRequested extends AuthEvent {}

class AuthStatusChecked extends AuthEvent {}

// Auth States
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final Map<String, dynamic> user;

  Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// Auth Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<AuthStatusChecked>(_onAuthStatusChecked);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAuthStatusChecked(
    AuthStatusChecked event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      if (isLoggedIn) {
        final user = await _authRepository.getCurrentUser();
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }    } catch (e) {
      emit(Unauthenticated());
    }
  }
  
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.login(
        event.username, 
        event.password
      );
      
      // Kiểm tra lỗi
      if (response.containsKey('error')) {
        emit(AuthFailure(response['error'].toString()));
        return;
      }
      
      // Kiểm tra thông tin xác thực
      if (!response.containsKey('access_token')) {
        emit(AuthFailure('Đăng nhập thất bại. Access token không hợp lệ.'));
        return;
      }
      
      // Kiểm tra user
      final user = response['user'];
      if (user != null && user is Map<String, dynamic>) {
        emit(Authenticated(user));
      } else {
        // Trường hợp không có thông tin user, thử gọi API getCurrentUser
        try {
          final userData = await _authRepository.getCurrentUser();
          if (userData.isNotEmpty && !userData.containsKey('error')) {
            emit(Authenticated(userData));
          } else {
            emit(AuthFailure('Đăng nhập thành công nhưng không lấy được thông tin người dùng.'));
          }
        } catch (e) {
          print('Lỗi lấy thông tin người dùng: ${e.toString()}');
          emit(AuthFailure('Đăng nhập thành công nhưng không lấy được thông tin người dùng.'));
        }
      }
    } catch (e) {
      print('Lỗi xử lý đăng nhập trong bloc: ${e.toString()}');
      emit(AuthFailure('Đăng nhập thất bại: ${e.toString()}'));
    }
  }
  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final registerResponse = await _authRepository.register(
        event.username,
        event.password,
        event.userType,
      );
      
      // Kiểm tra lỗi đăng ký
      if (registerResponse.containsKey('error')) {
        emit(AuthFailure('Đăng ký thất bại: ${registerResponse['error']}'));
        return;
      }
      
      // Sau khi đăng ký, tự động đăng nhập
      final loginResponse = await _authRepository.login(
        event.username,
        event.password,
      );
      
      // Kiểm tra lỗi đăng nhập
      if (loginResponse.containsKey('error')) {
        emit(AuthFailure('Đăng nhập sau đăng ký thất bại: ${loginResponse['error']}'));
        return;
      }
      
      // Kiểm tra user
      final user = loginResponse['user'];
      if (user != null && user is Map<String, dynamic>) {
        emit(Authenticated(user));
      } else {
        emit(AuthFailure('Đăng ký thành công nhưng không lấy được thông tin người dùng'));
      }
    } catch (e) {
      print('Lỗi xử lý đăng ký trong bloc: ${e.toString()}');
      emit(AuthFailure('Đăng ký thất bại: ${e.toString()}'));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.logout();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthFailure('Đăng xuất thất bại. Vui lòng thử lại.'));
    }
  }
}
