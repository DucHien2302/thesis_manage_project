import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/screens/auth/blocs/auth_bloc.dart';
import 'package:thesis_manage_project/utils/validators.dart';
import 'package:thesis_manage_project/widgets/custom_button.dart';
import 'package:thesis_manage_project/widgets/custom_text_field.dart';
import 'package:thesis_manage_project/config/constants.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  
  void _submitForgotPassword() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        ForgotPasswordRequested(email: _emailController.text.trim()),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quên mật khẩu'),
        elevation: 0,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccess) {            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.primary,
              ),
            );
            Navigator.of(context).pop(); // Return to login page
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  
                  // Logo or image
                  Image.asset(
                    'assets/images/logo.png',
                    height: 120,
                    width: 120,
                    errorBuilder: (context, error, stackTrace) {                      return Icon(
                        Icons.lock_reset,
                        size: 80,
                        color: Theme.of(context).primaryColor,
                      );
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  const Text(
                    'Quên mật khẩu?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  const Text(
                    'Vui lòng nhập địa chỉ email đã đăng ký. '
                    'Chúng tôi sẽ gửi cho bạn một liên kết để đặt lại mật khẩu.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Email field
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Submit button
                  CustomButton(
                    text: state is AuthLoading ? 'Đang gửi...' : 'Gửi yêu cầu',
                    onPressed: state is AuthLoading ? null : _submitForgotPassword,
                    isLoading: state is AuthLoading,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Back to login
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Quay lại đăng nhập'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
