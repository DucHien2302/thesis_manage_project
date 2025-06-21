import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/config/api_config.dart';
import 'package:thesis_manage_project/config/constants.dart';
import 'package:thesis_manage_project/repositories/profile_repository.dart';
import 'package:thesis_manage_project/screens/auth/blocs/auth_bloc.dart';
import 'package:thesis_manage_project/screens/profile/views/profile_information_card.dart';
import 'package:thesis_manage_project/screens/profile/views/profile_student_card.dart';
import 'package:thesis_manage_project/screens/profile/views/profile_lecturer_card.dart';
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
  bool _isSaving = false;
  int _userType = 0;

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
        final authState = context.read<AuthBloc>().state;        if (authState is Authenticated) {          setState(() {
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
  }  // Parse student profile
  void _parseStudentProfile(Map<String, dynamic> profile) {
    _logger.debug('=== PARSING STUDENT PROFILE ===');
    _logger.debug('Raw profile data: $profile');
    
    if (profile['information'] != null) {
      final information = profile['information'];
      _logger.debug('Information section: $information');
      
      _firstNameController.text = information['first_name'] ?? '';
      _lastNameController.text = information['last_name'] ?? '';
      _addressController.text = information['address'] ?? '';
      _phoneController.text = information['tel_phone'] ?? '';
      _selectedGender = information['gender'] ?? 0;

      try {
        _selectedDate = DateTime.parse(information['date_of_birth']);
      } catch (e) {
        _logger.error('Error parsing date_of_birth: $e');
        _selectedDate = DateTime(1970, 1, 1);
      }
      
      _logger.debug('Parsed information - First: "${_firstNameController.text}", Last: "${_lastNameController.text}"');
    } else {
      _logger.debug('No information section found in profile');
    }
    
    if (profile['student_info'] != null) {
      final studentInfo = profile['student_info'];
      _logger.debug('Student info section: $studentInfo');
      
      _studentCodeController.text = studentInfo['student_code'] ?? '';
      _classNameController.text = studentInfo['class_name'] ?? '';
      // Make sure we're handling UUID as string
      final majorId = (studentInfo['major_id'] ?? '').toString();
      
      // Validate major_id exists in available majors before setting
      if (majorId.isNotEmpty && _majors.any((m) => m['id'].toString() == majorId)) {
        _selectedMajorId = majorId;
        _logger.debug('Parsed and validated major_id from profile: $_selectedMajorId');
      } else {
        _logger.debug('Major ID $majorId not found in available majors, keeping current selection: $_selectedMajorId');
      }
      
      _logger.debug('Parsed student info - Code: "${_studentCodeController.text}", Class: "${_classNameController.text}", Major: "$_selectedMajorId"');
    } else {
      _logger.debug('No student_info section found in profile');
    }
    
    _logger.debug('=== END PARSING STUDENT PROFILE ===');
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
  }  // Set default values for new profiles
  void _setDefaultValues() {
    _logger.debug('Setting default values for user type: $_userType');
    
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
        _logger.debug('Set default major ID: $_selectedMajorId');
      } else {
        _selectedMajorId = '';
        _logger.debug('No majors available, major ID set to empty');
      }
    } else if (_userType == AppConfig.userTypeLecturer) {
      // Lecturer (3)
      _lecturerCodeController.text = '';
      _emailController.text = '';
      _titleController.text = '';
      if (_departments.isNotEmpty) {
        _selectedDepartment = _departments[0]['id'];
        _logger.debug('Set default department ID: $_selectedDepartment');
      } else {
        _selectedDepartment = 1;
        _logger.debug('No departments available, department ID set to 1');
      }
    }
  }  // Save profile data
  Future<void> _saveProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    // Prevent rapid successive calls
    if (_isSaving) {
      _logger.debug('Save already in progress, ignoring duplicate call');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Validate and trim input data to prevent truncation issues
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      final address = _addressController.text.trim();
      final phone = _phoneController.text.trim();

      // Additional validation
      if (firstName.isEmpty || lastName.isEmpty || address.isEmpty || phone.isEmpty) {
        _showErrorSnackBar('Vui lòng điền đầy đủ thông tin bắt buộc');
        return;
      }

      // Prepare common information data with trimmed values
      final informationData = {
        'first_name': firstName,
        'last_name': lastName,
        'date_of_birth': _selectedDate.toIso8601String(),
        'gender': _selectedGender,
        'address': address,
        'tel_phone': phone,
      };      // Prepare request data based on user type
      Map<String, dynamic> requestData = {};        if (_userType == AppConfig.userTypeStudent) {
        // Student (2)
        final studentCode = _studentCodeController.text.trim();
        final className = _classNameController.text.trim();
        
        if (studentCode.isEmpty) {
          _showErrorSnackBar('Vui lòng nhập mã số sinh viên');
          return;
        }
        
        // Prepare student-specific data
        final studentInfoData = {
          'student_code': studentCode,
          'class_name': className,
          'major_id': _selectedMajorId,
        };

        // Student API expects only information and student_info (no user_id/user_name)
        requestData = {
          'information': informationData,
          'student_info': studentInfoData,
        };
      } else if (_userType == AppConfig.userTypeLecturer) {
        // Lecturer (3)
        final lecturerCode = _lecturerCodeController.text.trim();
        final email = _emailController.text.trim();
        final title = _titleController.text.trim();
        
        if (lecturerCode.isEmpty || email.isEmpty || title.isEmpty) {
          _showErrorSnackBar('Vui lòng điền đầy đủ thông tin giảng viên');
          return;
        }
          // Prepare lecturer-specific data
        final lecturerInfoData = {
          'lecturer_code': lecturerCode,
          'department': _selectedDepartment,
          'title': title,
          'email': email,
        };        
        
        // Lecturer API expects only information and lecturer_info (no user_id)
        requestData = {
          'information': informationData,
          'lecturer_info': lecturerInfoData,
        };      }      // Debug log for request data
      _logger.debug('Preparing request data for user type: $_userType');
      _logger.debug('Request data structure: $requestData');// Send data to server
      final result = await _profileRepository.createOrUpdateProfile(
        _userType,
        requestData,
      );

      _logger.debug('Profile save result: $result');      // Check if the operation was successful
      // Success indicators: no error key, or explicit success=true, or successful status code
      bool isSuccess = false;
      
      if (!result.containsKey('error')) {
        // No error key means success
        isSuccess = true;
        _logger.debug('No error key found - operation successful');
      } else if (result.containsKey('success') && result['success'] == true) {
        // Explicit success flag
        isSuccess = true;
        _logger.debug('Explicit success flag found - operation successful');
        
        // Check for warnings
        if (result.containsKey('warning')) {
          _logger.debug('Operation successful but with warning: ${result['warning']}');
        }
      } else if (result.containsKey('status')) {
        // Check status code for success (2xx range)
        final status = result['status'];
        if (status is int && status >= 200 && status < 300) {
          isSuccess = true;
          _logger.debug('Success status code $status found - operation successful');
        }
      }

      if (!isSuccess) {
        _logger.error('Profile save failed with error: ${result['error']}');
        
        // Parse error message for better user experience
        String errorMessage = result['error'].toString();
        if (errorMessage.contains('Connection closed') || 
            errorMessage.contains('connection timeout') ||
            errorMessage.contains('network error')) {
          errorMessage = 'Lỗi kết nối mạng. Vui lòng kiểm tra internet và thử lại.';
        } else if (errorMessage.contains('SERVER_VALIDATION_ERROR')) {
          errorMessage = 'Lỗi xử lý từ máy chủ. Đây là lỗi hệ thống cần được sửa bởi admin.';
        } else if (errorMessage.contains('SERVER_ERROR')) {
          errorMessage = 'Lỗi máy chủ nội bộ. Vui lòng thử lại sau hoặc liên hệ admin.';
        } else if (errorMessage.contains('PROFILE_NOT_EXISTS')) {
          errorMessage = 'Profile không tồn tại. Hệ thống sẽ tự động thử tạo mới.';
        } else if (errorMessage.contains('500')) {
          if (errorMessage.contains('user_name') && errorMessage.contains('field required')) {
            errorMessage = 'Lỗi máy chủ: Server thiếu thông tin user_name trong response. Đây là lỗi hệ thống.';
          } else if (errorMessage.contains('ValidationError')) {
            errorMessage = 'Lỗi xác thực dữ liệu từ máy chủ. Đây là lỗi hệ thống.';
          } else {
            errorMessage = 'Lỗi máy chủ. Vui lòng thử lại sau ít phút.';
          }
        }
        
        _showErrorSnackBar('Lỗi khi lưu thông tin: $errorMessage');      } else {
        _logger.debug('Profile save successful');
        
        // Check if there are any warnings to show
        String successMessage = 'Cập nhật thông tin thành công';
        if (result.containsKey('warning')) {
          successMessage += ' (Có một số vấn đề nhỏ về định dạng phản hồi từ server)';
          _logger.debug('Success with warning: ${result['warning']}');
        }
        
        _showSuccessSnackBar(successMessage);

        // Log the successful save result
        _logger.debug('Save result contains:');
        _logger.debug('- Information: ${result.containsKey('information')}');
        _logger.debug('- Student info: ${result.containsKey('student_info')}');
        _logger.debug('- Lecturer info: ${result.containsKey('lecturer_info')}');
        
        // Instead of reloading, update the form with the returned data
        // This ensures we keep the data that was actually saved
        if (result.containsKey('information') && result['information'] != null) {
          final savedInfo = result['information'];
          _logger.debug('Updating form with saved information: $savedInfo');
          
          // Update controllers with the saved data
          _firstNameController.text = savedInfo['first_name'] ?? _firstNameController.text;
          _lastNameController.text = savedInfo['last_name'] ?? _lastNameController.text;
          _addressController.text = savedInfo['address'] ?? _addressController.text;
          _phoneController.text = savedInfo['tel_phone'] ?? _phoneController.text;
          _selectedGender = savedInfo['gender'] ?? _selectedGender;
          
          // Parse and update date
          try {
            if (savedInfo['date_of_birth'] != null) {
              _selectedDate = DateTime.parse(savedInfo['date_of_birth']);
            }
          } catch (e) {
            _logger.error('Error parsing saved date_of_birth: $e');
          }
        }
        
        // Update student-specific data if available
        if (_userType == AppConfig.userTypeStudent && 
            result.containsKey('student_info') && 
            result['student_info'] != null) {
          final savedStudentInfo = result['student_info'];
          _logger.debug('Updating form with saved student info: $savedStudentInfo');
          
          _studentCodeController.text = savedStudentInfo['student_code'] ?? _studentCodeController.text;
          _classNameController.text = savedStudentInfo['class_name'] ?? _classNameController.text;
          
          // Update major_id if provided
          if (savedStudentInfo['major_id'] != null) {
            final savedMajorId = savedStudentInfo['major_id'].toString();
            if (_majors.any((m) => m['id'].toString() == savedMajorId)) {
              _selectedMajorId = savedMajorId;
              _logger.debug('Updated major ID from save result: $_selectedMajorId');
            }
          }
        }
        
        // Update lecturer-specific data if available
        if (_userType == AppConfig.userTypeLecturer && 
            result.containsKey('lecturer_info') && 
            result['lecturer_info'] != null) {
          final savedLecturerInfo = result['lecturer_info'];
          _logger.debug('Updating form with saved lecturer info: $savedLecturerInfo');
          
          _lecturerCodeController.text = savedLecturerInfo['lecturer_code'] ?? _lecturerCodeController.text;
          _emailController.text = savedLecturerInfo['email'] ?? _emailController.text;
          _titleController.text = savedLecturerInfo['title'] ?? _titleController.text;
          _selectedDepartment = savedLecturerInfo['department'] ?? _selectedDepartment;
        }
        
        // Force a UI update to reflect the changes
        setState(() {});
        
        _logger.debug('Form updated with saved data - no reload needed');
        _logger.debug('Final form values:');
        _logger.debug('First name: ${_firstNameController.text}');
        _logger.debug('Last name: ${_lastNameController.text}');
        if (_userType == AppConfig.userTypeStudent) {
          _logger.debug('Major ID: $_selectedMajorId');
        }
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

  // Form change handler to prevent runtime errors
  void _onFormChanged() {
    // This method is called when form fields change
    // Currently no specific action needed, but prevents runtime errors
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _isLoading
              ? const Center(child: LoadingIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),                child: Form(
                  key: _formKey,
                  onChanged: _onFormChanged,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,                    children: [
                      // Basic information card
                      ProfileInformationCard(
                        firstNameController: _firstNameController,
                        lastNameController: _lastNameController,
                        addressController: _addressController,
                        phoneController: _phoneController,
                        selectedDate: _selectedDate,
                        selectedGender: _selectedGender,
                        onDateTap: () => _selectDate(context),
                        onGenderChanged: (value) {
                          setState(() {
                            _selectedGender = value ?? 0;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      // User type specific card
                      _userType == AppConfig.userTypeStudent
                          ? ProfileStudentCard(
                              studentCodeController: _studentCodeController,
                              classNameController: _classNameController,
                              selectedMajorId: _selectedMajorId,
                              majors: _majors,
                              onMajorChanged: (value) {
                                setState(() {
                                  _selectedMajorId = value ?? '';
                                });
                              },
                            ) // Student (type 2)
                          : ProfileLecturerCard(
                              lecturerCodeController: _lecturerCodeController,
                              emailController: _emailController,
                              titleController: _titleController,
                              selectedDepartment: _selectedDepartment,
                              departments: _departments,
                              onDepartmentChanged: (value) {
                                setState(() {
                                  _selectedDepartment = value ?? 1;
                                });
                              },
                            ), // Lecturer (type 3)
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
  }}
