import 'package:flutter/material.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/repositories/auth_repository.dart';
import 'package:thesis_manage_project/utils/api_service.dart';
import 'package:thesis_manage_project/utils/validators.dart';
import 'package:thesis_manage_project/widgets/custom_button.dart';
import 'package:thesis_manage_project/widgets/custom_text_field.dart';

class AdminUserManagement extends StatefulWidget {
  const AdminUserManagement({Key? key}) : super(key: key);

  @override
  State<AdminUserManagement> createState() => _AdminUserManagementState();
}

class _AdminUserManagementState extends State<AdminUserManagement> {
  final _apiService = ApiService();
  late final AuthRepository _authRepository;
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
    bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  List<Map<String, dynamic>> _lecturers = []; // List of lecturers
  bool _isLoadingUsers = true;
  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepository(apiService: _apiService);
    _loadLecturers();
  }
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  Future<void> _loadLecturers() async {
    try {
      setState(() {
        _isLoadingUsers = true;
      });
      
      final response = await _apiService.get('/users/lecturers');
      if (response != null) {
        setState(() {
          _lecturers = List<Map<String, dynamic>>.from(response);
          _isLoadingUsers = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingUsers = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải danh sách giảng viên: $e')),
      );
    }
  }

  Future<void> _registerLecturer() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Include lecturer additional info in API call
      // For now, only username and password are sent to the API
      final result = await _authRepository.adminRegisterLecturer(
        _usernameController.text,
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (result.containsKey('error')) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi: ${result['error']}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đăng ký tài khoản giảng viên thành công!'),
              backgroundColor: Colors.green,
            ),
          );
            // Reset form
          _formKey.currentState?.reset();
          _usernameController.clear();
          _passwordController.clear();
          _confirmPasswordController.clear();
          
          // Refresh lecturers list
          _loadLecturers();
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }  // Helper method to safely get lecturer code
  String _getLecturerCode(Map<String, dynamic> lecturer) {
    // Dựa vào dữ liệu thực tế, sử dụng user_name làm mã giảng viên
    if (lecturer.containsKey('user_name') && lecturer['user_name'] != null) {
      String value = lecturer['user_name'].toString().trim();
      if (value.isNotEmpty) {
        return value;
      }
    }
    
    // Fallback: sử dụng ID nếu không có user_name
    if (lecturer.containsKey('id') && lecturer['id'] != null) {
      String id = lecturer['id'].toString();
      // Lấy 8 ký tự đầu của UUID làm mã
      if (id.length >= 8) {
        return id.substring(0, 8).toUpperCase();
      }
    }
    
    return 'Chưa có';
  }

  // Helper method to safely get user initials
  String _getInitials(Map<String, dynamic> lecturer) {
    String firstName = lecturer['first_name']?.toString() ?? '';
    String lastName = lecturer['last_name']?.toString() ?? '';
    
    String firstInitial = firstName.isNotEmpty ? firstName[0].toUpperCase() : 'N';
    String lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : 'A';
    
    return firstInitial + lastInitial;  }

  // Helper method to safely get full name
  String _getFullName(Map<String, dynamic> lecturer) {
    String firstName = lecturer['first_name']?.toString() ?? '';
    String lastName = lecturer['last_name']?.toString() ?? '';
    
    if (firstName.isEmpty && lastName.isEmpty) {
      return 'Chưa có tên';
    }
    
    return '$firstName $lastName'.trim();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              labelColor: AppColors.primary,
              tabs: [
                Tab(text: 'Thêm giảng viên mới'),
                Tab(text: 'Danh sách giảng viên'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildRegisterForm(),
                  _buildLecturerList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Đăng ký tài khoản giảng viên mới',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            // Username field
            CustomTextField(
              controller: _usernameController,
              labelText: 'Tên đăng nhập',
              prefixIcon: const Icon(Icons.person),
              validator: Validators.validateUsername,
            ),
            
            const SizedBox(height: 16),
            
            // Password field
            CustomTextField(
              controller: _passwordController,
              labelText: 'Mật khẩu',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              obscureText: _obscurePassword,
              validator: Validators.validatePassword,
            ),
            
            const SizedBox(height: 16),
            
            // Confirm password field
            CustomTextField(
              controller: _confirmPasswordController,
              labelText: 'Xác nhận mật khẩu',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              obscureText: _obscureConfirmPassword,
              validator: (value) => Validators.validateConfirmPassword(value, _passwordController.text),
            ),            
            const SizedBox(height: 32),
            
            // Register button
            CustomButton(
              text: 'Đăng ký giảng viên',
              onPressed: _registerLecturer,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLecturerList() {
    if (_isLoadingUsers) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_lecturers.isEmpty) {
      return const Center(child: Text('Chưa có giảng viên nào!'));
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: _lecturers.length,      itemBuilder: (context, index) {
        final lecturer = _lecturers[index];
        
        String departmentName = 'Chưa xác định';
        if (lecturer.containsKey('department_name') && 
            lecturer['department_name'] != null) {
          departmentName = lecturer['department_name'];
        }
        
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(            
            title: Text(
              _getFullName(lecturer),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tên đăng nhập: ${_getLecturerCode(lecturer)}'),
                Text('Email: ${lecturer['email'] ?? 'Chưa có'}'),
                Text('Khoa: $departmentName'),
              ],
            ),leading: CircleAvatar(
              child: Text(_getInitials(lecturer)),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.primary),
                  onPressed: () {
                    // TODO: Add edit lecturer functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Chức năng đang phát triển')),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    lecturer['is_active'] ? Icons.block : Icons.check_circle,
                    color: lecturer['is_active'] ? Colors.red : Colors.green,
                  ),
                  onPressed: () {
                    // TODO: Add block/unblock functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Chức năng đang phát triển')),
                    );
                  },
                ),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}
