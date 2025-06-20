import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:thesis_manage_project/config/api_config.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/repositories/profile_repository.dart';
import 'package:thesis_manage_project/screens/auth/blocs/auth_bloc.dart';
import 'package:thesis_manage_project/utils/api_service.dart';
import 'package:thesis_manage_project/utils/logger.dart';
import 'package:thesis_manage_project/widgets/custom_button.dart';
import 'package:thesis_manage_project/widgets/loading_indicator.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late ProfileRepository _profileRepository;
  final ApiService _apiService = ApiService();
  final Logger _logger = Logger('ProfileScreen');

  bool _isLoading = true;
  bool _isSaving = false;  int _userType = 0;
  String _userId = '';
  String _userName = '';

  // Information fields
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime _selectedDate = DateTime(1970, 1, 1);
  int _selectedGender = 0; // 0: Nam, 1: Nữ, 2: Khác

  // Student specific fields
  final _studentCodeController = TextEditingController();
  final _classNameController = TextEditingController();
  String _selectedMajorId = '';
  List<Map<String, dynamic>> _majors = [];

  // Lecturer specific fields
  final _lecturerCodeController = TextEditingController();
  final _emailController = TextEditingController();
  final _titleController = TextEditingController();
  int _selectedDepartment = 1;  List<Map<String, dynamic>> _departments = [];

  @override
  void initState() {
    super.initState();
    _profileRepository = ProfileRepository(apiService: _apiService);

    // Use Future.microtask to ensure we run this after build
    Future.microtask(() {
      if (mounted) {
        // Get current user information from AuthBloc
        final authState = context.read<AuthBloc>().state;
        if (authState is Authenticated) {          setState(() {
            _userId = authState.user['id'] ?? '';
            _userName = authState.user['user_name'] ?? '';
            _userType = authState.user['user_type'] ?? 0;
            _logger.debug('User type set to: $_userType');
          });
          _loadUserProfile();
          _loadDependencies();
        }
      }
    });
  }

  @override
  void dispose() {
    // Dispose all controllers
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _studentCodeController.dispose();
    _classNameController.dispose();
    _lecturerCodeController.dispose();
    _emailController.dispose();
    _titleController.dispose();
    super.dispose();
  } // Load majors for student, departments for lecturer

  Future<void> _loadDependencies() async {
    try {
      _logger.debug('Loading dependencies for user type: $_userType');
      if (_userType == AppConfig.userTypeStudent) {
        // Student (2)
        // Load majors
        final response = await _apiService.get(ApiConfig.majors);
        _logger.debug('Loaded majors: $response');
        if (response != null) {
          List<Map<String, dynamic>> majorsList = [];
          if (response is List) {
            majorsList = List<Map<String, dynamic>>.from(response);
          } else if (response is Map && response.containsKey('data')) {
            majorsList = List<Map<String, dynamic>>.from(response['data']);
          }

          setState(() {
            _majors = majorsList;
            _logger.debug('Majors parsed: $_majors');
            if (_majors.isNotEmpty) {
              _selectedMajorId = _majors[0]['id'].toString();
              _logger.debug('Selected major ID: $_selectedMajorId');
            }
          });
          _logDataTypes();
        }
      } else if (_userType == AppConfig.userTypeLecturer) {
        // Lecturer (3)
        // Load departments
        final response = await _apiService.get(ApiConfig.departments);
        _logger.debug('Loaded departments: $response');
        if (response != null) {
          List<Map<String, dynamic>> departmentsList = [];
          if (response is List) {
            departmentsList = List<Map<String, dynamic>>.from(response);
          } else if (response is Map && response.containsKey('data')) {
            departmentsList = List<Map<String, dynamic>>.from(response['data']);
          }

          setState(() {
            _departments = departmentsList;
            _logger.debug('Departments parsed: $_departments');
            if (_departments.isNotEmpty) {
              _selectedDepartment = _departments[0]['id'];
              _logger.debug('Selected department ID: $_selectedDepartment');
            }
          });
          _logDataTypes();
        }
      }
    } catch (e) {
      _logger.error('Error loading dependencies: $e');
      _showErrorSnackBar('Không thể tải dữ liệu: $e');
    }
  } // Load user profile based on user type

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _logger.debug('Loading user profile for user type: $_userType');
      final profile = await _profileRepository.getUserProfile(_userType);
      _logger.debug(
        'Profile retrieved: ${profile.containsKey('error') ? 'Error: ${profile["error"]}' : 'Success'}',
      );

      if (profile.containsKey('error')) {
        // No profile exists yet - set default values
        _setDefaultValues();
      } else {
        // Parse profile data
        if (_userType == AppConfig.userTypeStudent) {
          // Student (2)
          _parseStudentProfile(profile);
        } else if (_userType == AppConfig.userTypeLecturer) {
          // Lecturer (3)
          _parseLecturerProfile(profile);
        }
      }
    } catch (e) {
      _logger.error('Error loading user profile: $e');
      _showErrorSnackBar('Không thể tải thông tin người dùng: $e');
      _setDefaultValues();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  // Parse student profile
  void _parseStudentProfile(Map<String, dynamic> profile) {
    if (profile['information'] != null) {
      final information = profile['information'];
      _firstNameController.text = information['first_name'] ?? '';
      _lastNameController.text = information['last_name'] ?? '';
      _addressController.text = information['address'] ?? '';
      _phoneController.text = information['tel_phone'] ?? '';
      _selectedGender = information['gender'] ?? 0;

      try {
        _selectedDate = DateTime.parse(information['date_of_birth']);
      } catch (e) {
        _selectedDate = DateTime(1970, 1, 1);
      }
    }
    if (profile['student_info'] != null) {
      final studentInfo = profile['student_info'];
      _studentCodeController.text = studentInfo['student_code'] ?? '';
      _classNameController.text = studentInfo['class_name'] ?? '';
      // Make sure we're handling UUID as string
      _selectedMajorId = (studentInfo['major_id'] ?? '').toString();
      _logger.debug('Parsed major_id from profile: $_selectedMajorId');
    }
  }
  // Parse lecturer profile
  void _parseLecturerProfile(Map<String, dynamic> profile) {
    if (profile['information'] != null) {
      final information = profile['information'];
      _firstNameController.text = information['first_name'] ?? '';
      _lastNameController.text = information['last_name'] ?? '';
      _addressController.text = information['address'] ?? '';
      _phoneController.text = information['tel_phone'] ?? '';
      _selectedGender = information['gender'] ?? 0;

      try {
        _selectedDate = DateTime.parse(information['date_of_birth']);
      } catch (e) {
        _selectedDate = DateTime(1970, 1, 1);
      }
    }

    if (profile['lecturer_info'] != null) {
      final lecturerInfo = profile['lecturer_info'];
      _lecturerCodeController.text = lecturerInfo['lecturer_code'] ?? '';
      _emailController.text = lecturerInfo['email'] ?? '';
      _titleController.text = lecturerInfo['title'] ?? '';
      _selectedDepartment = lecturerInfo['department'] ?? 1;
    }
  }// Set default values for new profiles

  void _setDefaultValues() {
    _firstNameController.text = '';
    _lastNameController.text = '';
    _addressController.text = '';
    _phoneController.text = '';
    _selectedGender = 0;
    _selectedDate = DateTime(1970, 1, 1);
    if (_userType == AppConfig.userTypeStudent) {
      // Student (2)
      _studentCodeController.text = '';
      _classNameController.text = '';
      if (_majors.isNotEmpty) {
        _selectedMajorId = _majors[0]['id'].toString();
      }
    } else if (_userType == AppConfig.userTypeLecturer) {
      // Lecturer (3)
      _lecturerCodeController.text = '';
      _emailController.text = '';
      _titleController.text = '';
      _selectedDepartment = 1;
    }
  }

  // Save profile data
  Future<void> _saveProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Prepare common information data
      final informationData = {
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'date_of_birth': _selectedDate.toIso8601String(),
        'gender': _selectedGender,
        'address': _addressController.text,
        'tel_phone': _phoneController.text,
      }; // Prepare request data based on user type
      Map<String, dynamic> requestData = {};      
      if (_userType == AppConfig.userTypeStudent) {
        // Student (2)
        // Prepare student-specific data
        final studentInfoData = {
          'student_code': _studentCodeController.text,
          'class_name': _classNameController.text,
          'major_id': _selectedMajorId,
        };          requestData = {
          'user_id': _userId,
          'user_name': _userName,
          'information': informationData,
          'student_info': studentInfoData,
        };
      } else if (_userType == AppConfig.userTypeLecturer) {
        // Lecturer (3)
        // Prepare lecturer-specific data
        final lecturerInfoData = {
          'lecturer_code': _lecturerCodeController.text,
          'department': _selectedDepartment,
          'title': _titleController.text,
          'email': _emailController.text,
        };        
        requestData = {
          'user_id': _userId,
          'information': informationData,
          'lecturer_info': lecturerInfoData,
        };      }

      // Debug log for request data
      _logger.debug('Preparing request data for user type: $_userType');
      _logger.debug('User ID: $_userId, User Name: $_userName');
      _logger.debug('Request data: $requestData');      // Send data to server
      final result = await _profileRepository.createOrUpdateProfile(
        _userType,
        requestData,
      );

      _logger.debug('Profile save result: $result');      if (result.containsKey('error')) {
        _logger.error('Profile save failed with error: ${result['error']}');
        
        // Parse error message for better user experience
        String errorMessage = result['error'].toString();
        if (errorMessage.contains('Connection closed') || 
            errorMessage.contains('connection timeout') ||
            errorMessage.contains('network error')) {
          errorMessage = 'Lỗi kết nối mạng. Vui lòng kiểm tra internet và thử lại.';
        } else if (errorMessage.contains('500')) {
          errorMessage = 'Lỗi máy chủ. Vui lòng thử lại sau ít phút.';
        }
        
        _showErrorSnackBar('Lỗi khi lưu thông tin: $errorMessage');
      } else {
        _logger.debug('Profile save successful');
        _showSuccessSnackBar('Cập nhật thông tin thành công');

        // Add a small delay before reloading to avoid API conflicts
        await Future.delayed(const Duration(milliseconds: 1000));
        
        // Reload profile to get updated IDs
        await _loadUserProfile();
      }
    } catch (e) {
      _showErrorSnackBar('Lỗi khi xử lý thông tin: $e');
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  // Show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  // Show error message
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message), 
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(
          bottom: 20,
          left: 20,
          right: 20,
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }  // Show success message
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message), 
        backgroundColor: ColorScheme.of(context).primary,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(
          bottom: 20,
          left: 20,
          right: 20,
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Debug method to log data handling
  void _logDataTypes() {
    _logger.debug('--- DROPDOWN DATA TYPES ---');
    if (_majors.isNotEmpty) {
      _logger.debug(
        'Major ID type: ${_majors[0]['id'].runtimeType} - Value: ${_majors[0]['id']}',
      );
      _logger.debug(
        'Selected major ID type: ${_selectedMajorId.runtimeType} - Value: $_selectedMajorId',
      );
    }

    if (_departments.isNotEmpty) {
      _logger.debug(
        'Department ID type: ${_departments[0]['id'].runtimeType} - Value: ${_departments[0]['id']}',
      );
      _logger.debug(
        'Selected department ID type: ${_selectedDepartment.runtimeType} - Value: $_selectedDepartment',
      );
    }
    _logger.debug('-------------------------');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _isLoading
              ? const Center(child: LoadingIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic information card
                      _buildInformationCard(),
                      const SizedBox(height: 20), // User type specific card
                      _userType == AppConfig.userTypeStudent
                          ? _buildStudentCard() // Student (type 2)
                          : _buildLecturerCard(), // Lecturer (type 3)
                      const SizedBox(height: 30),
                      // Save button
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: CustomButton(
                            onPressed: _isSaving ? null : _saveProfile,
                            isLoading: _isSaving,
                            text: 'Lưu thông tin',
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
    );
  }

  // Basic information card
  Widget _buildInformationCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin cá nhân',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 16),
            // First name
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'Tên',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tên';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Last name
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Họ',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập họ';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Gender selection
            DropdownButtonFormField<int>(
              value: _selectedGender,
              decoration: const InputDecoration(
                labelText: 'Giới tính',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 0, child: Text('Nam')),
                DropdownMenuItem(value: 1, child: Text('Nữ')),
                DropdownMenuItem(value: 2, child: Text('Khác')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedGender = value ?? 0;
                });
              },
            ),
            const SizedBox(height: 16),
            // Date of birth
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Ngày sinh',
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Address
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Địa chỉ',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập địa chỉ';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Phone
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Số điện thoại',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập số điện thoại';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  // Student specific information card
  Widget _buildStudentCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin sinh viên',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 16),
            // Student code
            TextFormField(
              controller: _studentCodeController,
              decoration: const InputDecoration(
                labelText: 'Mã số sinh viên',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập mã số sinh viên';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Class name
            TextFormField(
              controller: _classNameController,
              decoration: const InputDecoration(
                labelText: 'Lớp',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16), // Major selection
            DropdownButtonFormField<String>(
              value:
                  _selectedMajorId.isNotEmpty &&
                          _majors.isNotEmpty &&
                          _majors.any(
                            (m) => m['id'].toString() == _selectedMajorId,
                          )
                      ? _selectedMajorId
                      : (_majors.isNotEmpty ? _majors[0]['id'].toString() : ''),
              decoration: const InputDecoration(
                labelText: 'Chuyên ngành',
                border: OutlineInputBorder(),
              ),
              items:
                  _majors.isEmpty
                      ? [
                        const DropdownMenuItem<String>(
                          value: '',
                          child: Text('Đang tải...'),
                        ),
                      ]
                      : _majors.map((major) {
                        String id = major['id'].toString();
                        String name = major['name'].toString();
                        _logger.debug('Major item: $id: $name');
                        return DropdownMenuItem<String>(
                          value: id,
                          child: Text(name),
                        );
                      }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMajorId = value ?? '';
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng chọn chuyên ngành';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  // Lecturer specific information card
  Widget _buildLecturerCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin giảng viên',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 16),
            // Lecturer code
            TextFormField(
              controller: _lecturerCodeController,
              decoration: const InputDecoration(
                labelText: 'Mã số giảng viên',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập mã số giảng viên';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Email
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập email';
                }
                if (!value.contains('@')) {
                  return 'Email không hợp lệ';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Chức danh',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập chức danh';
                }
                return null;
              },
            ),
            const SizedBox(height: 16), // Department selection
            DropdownButtonFormField<int>(
              value:
                  _departments.isNotEmpty && _selectedDepartment != 0
                      ? _selectedDepartment
                      : (_departments.isNotEmpty ? _departments[0]['id'] : 1),
              decoration: const InputDecoration(
                labelText: 'Khoa',
                border: OutlineInputBorder(),
              ),
              items:
                  _departments.isEmpty
                      ? [
                        const DropdownMenuItem<int>(
                          value: 1,
                          child: Text('Đang tải...'),
                        ),
                      ]
                      : _departments.map((department) {
                        int id =
                            department['id'] is int
                                ? department['id']
                                : int.tryParse(department['id'].toString()) ??
                                    1;
                        String name = department['name'].toString();
                        _logger.debug('Department item: $id: $name');
                        return DropdownMenuItem<int>(
                          value: id,
                          child: Text(name),
                        );
                      }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDepartment = value ?? 1;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Vui lòng chọn khoa';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
