import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/screens/auth/blocs/auth_bloc.dart';
import 'package:thesis_manage_project/screens/auth/views/forgot_password_view.dart';
import 'package:thesis_manage_project/screens/auth/views/register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _rememberMe = true;

  @override
  void initState() {
    super.initState();
    // Có thể thêm logic lấy thông tin đăng nhập được lưu trước đó
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Gửi event đăng nhập
      context.read<AuthBloc>().add(
            LoginRequested(
              username: _userNameController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
    }
  }

  Widget _buildQuickLoginButton(String label, int userType, Color color) {
    return ElevatedButton(
      onPressed: _isLoading ? null : () => _quickLogin(userType),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10),
      ),
    );
  }

  void _quickLogin(int userType) {
    context.read<AuthBloc>().add(
      MockLoginRequested(userType: userType),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() => _isLoading = true);
          } else {
            setState(() => _isLoading = false);
          }

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
        child: SafeArea(
          child: Stack(
            children: [              // Background gradient with pattern
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      isDarkMode ? Colors.grey[900]! : Colors.blue[100]!,
                      isDarkMode ? Colors.grey[850]! : Colors.white,
                    ],
                  ),
                ),
              ),
              // Background pattern
              Positioned.fill(
                child: Opacity(
                  opacity: isDarkMode ? 0.05 : 0.1,
                  child: CustomPaint(
                    painter: GridPatternPainter(),
                  ),
                ),
              ),
              
              // Login content
              SingleChildScrollView(
                child: Container(
                  height: size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.marginLarge,
                    vertical: AppDimens.marginMedium,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo & App title
                      Hero(
                        tag: 'app_logo',
                        child: Container(
                          padding: const EdgeInsets.all(AppDimens.marginMedium),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.school,
                            size: 80,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimens.marginMedium),
                      Text(
                        AppConfig.appName,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimens.marginExtraLarge),                      // Login card with animation
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOutCubic,
                        padding: const EdgeInsets.all(AppDimens.marginLarge),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 5,
                              offset: const Offset(0, 10),
                            ),
                          ],
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Đăng Nhập',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: AppDimens.marginLarge),

                              // Username field
                              TextFormField(
                                controller: _userNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Tên đăng nhập',
                                  hintText: 'Nhập tên người dùng',
                                  prefixIcon: Icon(Icons.person_outline),
                                ),
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng nhập tên đăng nhập';
                                  }
                                  return null;
                                },
                                enabled: !_isLoading,
                              ),
                              const SizedBox(height: AppDimens.marginMedium),

                              // Password field
                              TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: 'Mật khẩu',
                                  hintText: 'Nhập mật khẩu',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible = !_isPasswordVisible;
                                      });
                                    },
                                    tooltip: _isPasswordVisible ? 'Ẩn mật khẩu' : 'Hiện mật khẩu',
                                  ),
                                ),
                                obscureText: !_isPasswordVisible,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng nhập mật khẩu';
                                  }
                                  return null;
                                },
                                enabled: !_isLoading,
                                onFieldSubmitted: (_) => _submitForm(),
                              ),

                              // Remember me checkbox
                              Row(
                                children: [
                                  Switch.adaptive(
                                    value: _rememberMe,
                                    activeColor: AppColors.primary,
                                    onChanged: _isLoading 
                                      ? null 
                                      : (value) {
                                          setState(() {
                                            _rememberMe = value;
                                          });
                                        },
                                  ),
                                  const Text('Nhớ đăng nhập'),
                                  const Spacer(),                                  TextButton(
                                    onPressed: _isLoading ? null : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const ForgotPasswordView(),
                                        ),
                                      );
                                    },
                                    child: const Text('Quên mật khẩu?'),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: AppDimens.marginMedium),                              // Login button
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: _isLoading
                                    ? LinearGradient(
                                        colors: [
                                          Colors.grey[400]!,
                                          Colors.grey[500]!,
                                        ],
                                      )
                                    : const LinearGradient(
                                        colors: [
                                          AppColors.primary,
                                          AppColors.primaryDark,
                                        ],
                                      ),
                                  borderRadius: BorderRadius.circular(AppDimens.radiusRegular),
                                  boxShadow: _isLoading
                                    ? [] 
                                    : [
                                        BoxShadow(
                                          color: AppColors.primary.withOpacity(0.3),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: _isLoading ? null : _submitForm,
                                    borderRadius: BorderRadius.circular(AppDimens.radiusRegular),
                                    child: Center(
                                      child: _isLoading
                                        ? const SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: AppColors.textLight,
                                            ),
                                          )
                                        : const Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.login,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: AppDimens.marginMedium),
                                              Text(
                                                'ĐĂNG NHẬP',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),                      ),
                      
                      const SizedBox(height: AppDimens.marginLarge),
                        // Register text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Chưa có tài khoản?',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          TextButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const RegisterView(),
                                      ),
                                    );
                                  },
                            child: const Text('Đăng ký ngay'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),    );
  }
}

class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw horizontal lines
    for (var i = 0; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i.toDouble()), Offset(size.width, i.toDouble()), paint);
    }

    // Draw vertical lines
    for (var i = 0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i.toDouble(), 0), Offset(i.toDouble(), size.height), paint);
    }

    // Draw some random circles for a more dynamic look
    final Random random = Random(42); // Fixed seed for consistency
    final circlePaint = Paint()
      ..color = Colors.blue.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    for (var i = 0; i < 10; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 50 + 20;
      canvas.drawCircle(Offset(x, y), radius, circlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
