import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thesis_manage_project/repositories/auth_repository.dart';
import 'package:thesis_manage_project/services/permission_service.dart';
import 'package:thesis_manage_project/utils/logger.dart';

// Auth Events - Định nghĩa các sự kiện liên quan đến xác thực
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  
  @override
  List<Object?> get props => [];
}

// Sự kiện yêu cầu đăng nhập
class LoginRequested extends AuthEvent {
  final String username;
  final String password;
  final bool rememberMe;

  const LoginRequested({
    required this.username, 
    required this.password,
    this.rememberMe = false,
  });

  @override
  List<Object?> get props => [username, password, rememberMe];
}

// Sự kiện yêu cầu đăng ký
class RegisterRequested extends AuthEvent {
  final String username;
  final String password;
  final String confirmPassword;
  final int userType;

  const RegisterRequested({
    required this.username, 
    required this.password,
    required this.confirmPassword,
    required this.userType,
  });

  @override
  List<Object?> get props => [username, password, confirmPassword, userType];
}

// Sự kiện yêu cầu đăng xuất
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

// Sự kiện kiểm tra trang thái xác thực
class AuthStatusChecked extends AuthEvent {
  const AuthStatusChecked();
}

// Sự kiện làm mới token khi token hết hạn
class TokenRefreshed extends AuthEvent {
  const TokenRefreshed();
}

// Sự kiện yêu cầu đổi mật khẩu
class ChangePasswordRequested extends AuthEvent {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  const ChangePasswordRequested({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [oldPassword, newPassword, confirmPassword];
}

// Sự kiện yêu cầu lấy lại mật khẩu
class ForgotPasswordRequested extends AuthEvent {
  final String email;

  const ForgotPasswordRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

// Sự kiện đặt lại mật khẩu với token
class ResetPasswordRequested extends AuthEvent {
  final String token;
  final String newPassword;
  final String confirmPassword;

  const ResetPasswordRequested({
    required this.token,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [token, newPassword, confirmPassword];
}

// Sự kiện mock login với user type
class MockLoginRequested extends AuthEvent {
  final int userType;

  const MockLoginRequested({required this.userType});

  @override
  List<Object?> get props => [userType];
}

// Auth States - Định nghĩa các trạng thái liên quan đến xác thực
abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object?> get props => [];
}

// Trạng thái ban đầu
class AuthInitial extends AuthState {
  const AuthInitial();
}

// Trạng thái đang tải
class AuthLoading extends AuthState {
  const AuthLoading();
}

// Trạng thái đã xác thực
class Authenticated extends AuthState {
  final Map<String, dynamic> user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

// Trạng thái chưa xác thực
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

// Trạng thái lỗi xác thực
class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// Trạng thái đăng ký thành công
class RegisterSuccess extends AuthState {
  final String message;

  const RegisterSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// Trạng thái đổi mật khẩu thành công
class PasswordChangeSuccess extends AuthState {
  final String message;

  const PasswordChangeSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// Trạng thái gửi email quên mật khẩu thành công
class ForgotPasswordSuccess extends AuthState {
  final String message;

  const ForgotPasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// Trạng thái đặt lại mật khẩu thành công
class ResetPasswordSuccess extends AuthState {
  final String message;

  const ResetPasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// Auth Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final PermissionService? _permissionService;
  final Logger _logger = Logger('AuthBloc');
  AuthBloc({
    required AuthRepository authRepository,
    PermissionService? permissionService,
  })  : _authRepository = authRepository,
        _permissionService = permissionService,
        super(const AuthInitial()) {
    on<AuthStatusChecked>(_onAuthStatusChecked);
    on<LoginRequested>(_onLoginRequested);
    on<MockLoginRequested>(_onMockLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<TokenRefreshed>(_onTokenRefreshed);
    on<ChangePasswordRequested>(_onChangePasswordRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
  }

  /// Kiểm tra trạng thái đăng nhập của người dùng
  Future<void> _onAuthStatusChecked(
    AuthStatusChecked event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      if (isLoggedIn) {
        final user = await _authRepository.getCurrentUser();
        if (!user.containsKey('error')) {
          emit(Authenticated(user));
        } else {
          emit(const Unauthenticated());
        }
      } else {
        emit(const Unauthenticated());
      }
    } catch (e) {
      _logger.error('Lỗi khi kiểm tra trạng thái đăng nhập: $e');
      emit(const Unauthenticated());
    }
  }
  
  /// Xử lý đăng nhập
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      // Validate input
      if (event.username.isEmpty) {
        emit(const AuthFailure('Vui lòng nhập tên đăng nhập'));
        return;
      }
      
      if (event.password.isEmpty) {
        emit(const AuthFailure('Vui lòng nhập mật khẩu'));
        return;
      }
      
      // Gọi API đăng nhập
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
        emit(const AuthFailure('Đăng nhập thất bại. Access token không hợp lệ.'));
        return;
      }      
      // Kiểm tra user
      final user = response['user'];
      if (user != null && user is Map<String, dynamic>) {
        // Khởi tạo quyền nếu có permission service
        if (_permissionService != null && user.containsKey('id')) {
          try {
            await _permissionService.initPermissions(user['id'].toString());
            _logger.info('Khởi tạo quyền thành công cho user: ${user['id']}');
          } catch (e) {
            _logger.error('Lỗi khi khởi tạo quyền: $e');
          }
        }
        emit(Authenticated(user));
      } else {
        // Trường hợp không có thông tin user, thử gọi API getCurrentUser
        try {
          final userData = await _authRepository.getCurrentUser();          if (userData.isNotEmpty && !userData.containsKey('error')) {
            // Khởi tạo quyền nếu có permission service
            if (_permissionService != null && userData.containsKey('id')) {
              try {
                await _permissionService.initPermissions(userData['id'].toString());
                _logger.info('Khởi tạo quyền thành công cho user: ${userData['id']}');
              } catch (e) {
                _logger.error('Lỗi khi khởi tạo quyền: $e');
              }
            }
            emit(Authenticated(userData));
          } else {
            emit(const AuthFailure('Đăng nhập thành công nhưng không lấy được thông tin người dùng.'));
          }
        } catch (e) {
          _logger.error('Lỗi lấy thông tin người dùng: $e');
          emit(const AuthFailure('Đăng nhập thành công nhưng không lấy được thông tin người dùng.'));
        }
      }
    } catch (e) {
      _logger.error('Lỗi xử lý đăng nhập trong bloc: $e');
      emit(AuthFailure('Đăng nhập thất bại: ${e.toString()}'));
    }
  }

  /// Xử lý đăng ký
  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      // Validate input
      if (event.username.isEmpty) {
        emit(const AuthFailure('Vui lòng nhập tên đăng nhập'));
        return;
      }
      
      if (event.password.isEmpty) {
        emit(const AuthFailure('Vui lòng nhập mật khẩu'));
        return;
      }
      
      if (event.password != event.confirmPassword) {
        emit(const AuthFailure('Mật khẩu xác nhận không khớp'));
        return;
      }
      
      // Gọi API đăng ký
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

      emit(const RegisterSuccess('Đăng ký thành công! Vui lòng đăng nhập.'));
    } catch (e) {
      _logger.error('Lỗi xử lý đăng ký trong bloc: $e');
      emit(AuthFailure('Đăng ký thất bại: ${e.toString()}'));
    }
  }
  /// Xử lý đăng xuất
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {      // Xóa dữ liệu quyền nếu có permission service
      if (_permissionService != null) {
        _permissionService.clearPermissions();
        _logger.info('Đã xóa dữ liệu quyền');
      }
      
      final success = await _authRepository.logout();
      if (success) {
        emit(const Unauthenticated());
      } else {
        emit(const AuthFailure('Đăng xuất thất bại. Vui lòng thử lại.'));
      }
    } catch (e) {
      _logger.error('Lỗi xử lý đăng xuất trong bloc: $e');
      emit(const AuthFailure('Đăng xuất thất bại. Vui lòng thử lại.'));
    }
  }
  
  /// Xử lý làm mới token
  Future<void> _onTokenRefreshed(
    TokenRefreshed event,
    Emitter<AuthState> emit,
  ) async {
    // Không emit AuthLoading() để tránh làm gián đoạn UI
    try {
      final response = await _authRepository.refreshToken();
      
      if (response.containsKey('error')) {
        // Token refresh thất bại, đăng xuất
        await _authRepository.logout();
        emit(const Unauthenticated());
      } else {
        // Giữ nguyên trạng thái Authenticated hiện tại
        if (state is Authenticated) {
          // Cập nhật thông tin người dùng nếu cần
          final user = await _authRepository.getCurrentUser();
          if (!user.containsKey('error')) {
            emit(Authenticated(user));
          }
        }
      }
    } catch (e) {
      _logger.error('Lỗi xử lý làm mới token trong bloc: $e');
      // Đăng xuất khi không thể làm mới token
      await _authRepository.logout();
      emit(const Unauthenticated());
    }
  }
  
  /// Xử lý đổi mật khẩu
  Future<void> _onChangePasswordRequested(
    ChangePasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Chỉ emit AuthLoading nếu hiện tại không phải là Authenticated
    // để tránh gây gián đoạn UI với trạng thái người dùng
    final currentState = state;
    if (currentState is! Authenticated) {
      emit(const AuthLoading());
    }
    
    try {
      // Validate input
      if (event.oldPassword.isEmpty) {
        emit(const AuthFailure('Vui lòng nhập mật khẩu hiện tại'));
        return;
      }
      
      if (event.newPassword.isEmpty) {
        emit(const AuthFailure('Vui lòng nhập mật khẩu mới'));
        return;
      }
      
      if (event.newPassword != event.confirmPassword) {
        emit(const AuthFailure('Mật khẩu xác nhận không khớp'));
        return;
      }
      
      // Gọi API đổi mật khẩu
      final response = await _authRepository.changePassword(
        event.oldPassword, 
        event.newPassword
      );
      
      if (response.containsKey('error')) {
        emit(AuthFailure(response['error'].toString()));
      } else {
        emit(const PasswordChangeSuccess('Đổi mật khẩu thành công!'));
        
        // Khôi phục trạng thái authenticated nếu cần
        if (currentState is Authenticated) {
          emit(currentState);
        }
      }
    } catch (e) {
      _logger.error('Lỗi xử lý đổi mật khẩu trong bloc: $e');
      emit(AuthFailure('Đổi mật khẩu thất bại: ${e.toString()}'));
      
      // Khôi phục trạng thái authenticated nếu cần
      if (currentState is Authenticated) {
        emit(currentState);
      }
    }
  }
    /// Xử lý quên mật khẩu
  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    
    try {
      // Validate email
      if (event.email.isEmpty) {
        emit(const AuthFailure('Vui lòng nhập email'));
        return;
      }
      
      // Validate email format with simple regex
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(event.email)) {
        emit(const AuthFailure('Vui lòng nhập đúng định dạng email'));
        return;
      }
      
      // Gọi API quên mật khẩu
      final response = await _authRepository.forgotPassword(event.email);
      
      if (response.containsKey('error')) {
        emit(AuthFailure(response['error']));
      } else {
        emit(ForgotPasswordSuccess(
          response['message'] ?? 'Link đặt lại mật khẩu đã được gửi tới email của bạn. '
          'Vui lòng kiểm tra hộp thư đến.'
        ));
      }
    } catch (e) {
      _logger.error('Lỗi xử lý quên mật khẩu trong bloc: $e');
      emit(AuthFailure('Không thể gửi email đặt lại mật khẩu: ${e.toString()}'));
    }
  }
    /// Xử lý đặt lại mật khẩu
  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    
    try {
      // Validate input
      if (event.token.isEmpty) {
        emit(const AuthFailure('Token không hợp lệ'));
        return;
      }
      
      if (event.newPassword.isEmpty) {
        emit(const AuthFailure('Vui lòng nhập mật khẩu mới'));
        return;
      }
      
      if (event.newPassword != event.confirmPassword) {
        emit(const AuthFailure('Mật khẩu xác nhận không khớp'));
        return;
      }
      
      // Gọi API đặt lại mật khẩu
      final response = await _authRepository.resetPassword(
        event.token,
        event.newPassword
      );
      
      if (response.containsKey('error')) {
        emit(AuthFailure(response['error']));
      } else {
        emit(ResetPasswordSuccess(
          response['message'] ?? 'Đặt lại mật khẩu thành công! Vui lòng đăng nhập với mật khẩu mới.'
        ));
      }
    } catch (e) {
      _logger.error('Lỗi xử lý đặt lại mật khẩu trong bloc: $e');
      emit(AuthFailure('Không thể đặt lại mật khẩu: ${e.toString()}'));
    }
  }

  /// Xử lý mock login
  Future<void> _onMockLoginRequested(
    MockLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final result = await _authRepository.mockLoginWithUserType(event.userType);
      
      if (result.containsKey('error')) {
        emit(AuthFailure(result['error']));
      } else if (result.containsKey('user')) {
        final userData = result['user'] as Map<String, dynamic>;
        
        // Khởi tạo quyền nếu có permission service
        if (_permissionService != null && userData.containsKey('id')) {
          try {
            await _permissionService.initPermissions(userData['id'].toString());
            _logger.info('Khởi tạo quyền thành công cho mock user: ${userData['id']}');
          } catch (e) {
            _logger.error('Lỗi khi khởi tạo quyền cho mock user: $e');
          }
        }
        
        emit(Authenticated(userData));
      } else {
        emit(const AuthFailure('Mock login thất bại'));
      }
    } catch (e) {
      _logger.error('Lỗi mock login: $e');
      emit(AuthFailure('Mock login thất bại: ${e.toString()}'));
    }
  }
}
