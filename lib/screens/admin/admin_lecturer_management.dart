import 'package:flutter/material.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/repositories/auth_repository.dart';
import 'package:thesis_manage_project/utils/api_service.dart';
import 'package:thesis_manage_project/utils/validators.dart';
import 'package:thesis_manage_project/widgets/custom_button.dart';
import 'package:thesis_manage_project/widgets/custom_text_field.dart';

class AdminLecturerManagement extends StatefulWidget {
  const AdminLecturerManagement({Key? key}) : super(key: key);

  @override
  State<AdminLecturerManagement> createState() => _AdminLecturerManagementState();
}

class _AdminLecturerManagementState extends State<AdminLecturerManagement> {
  final _apiService = ApiService();
  late final AuthRepository _authRepository;
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _lecturerCodeController = TextEditingController();
  final _titleController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  int _selectedDepartment = 1; // Default department
  
  List<Map<String, dynamic>> _departments = []; // Department list
  List<Map<String, dynamic>> _lecturers = []; // List of lecturers
  bool _isLoadingUsers = true;

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepository(apiService: _apiService);
    _loadDepartments();
    _loadLecturers();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _lecturerCodeController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  // Simple validation function for required fields
  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Trường này không được để trống';
    }
    return null;
  }

  Future<void> _loadDepartments() async {
    try {
      final response = await _apiService.get('/theses/getall/department/g');
      if (response != null) {
        setState(() {
          _departments = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể tải danh sách khoa: $e')),
        );
      }
    }
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể tải danh sách giảng viên: $e')),
        );
      }
    }
  }

  Future<void> _registerLecturer() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
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
            SnackBar(
              content: Text('Đăng ký tài khoản giảng viên thành công!'),
              backgroundColor: ColorScheme.of(context).primary,
            ),
          );
          
          // Reset form
          _formKey.currentState?.reset();
          _usernameController.clear();
          _passwordController.clear();
          _confirmPasswordController.clear();
          _firstNameController.clear();
          _lastNameController.clear();
          _emailController.clear();
          _lecturerCodeController.clear();
          _titleController.clear();
          
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý giảng viên'),
      ),
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
      itemCount: _lecturers.length,
      itemBuilder: (context, index) {
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
              '${lecturer['first_name']} ${lecturer['last_name']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mã GV: ${lecturer['lecturer_code']}'),
                Text('Email: ${lecturer['email']}'),
                Text('Khoa: $departmentName'),
              ],
            ),
            leading: CircleAvatar(
              child: Text(
                lecturer['first_name'].isNotEmpty && lecturer['last_name'].isNotEmpty ? 
                lecturer['first_name'][0] + lecturer['last_name'][0] : 'GV'
              ),
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
