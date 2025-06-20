import 'package:thesis_manage_project/utils/api_service.dart';
import 'package:thesis_manage_project/utils/logger.dart';
import 'package:thesis_manage_project/config/api_config.dart';
import 'package:thesis_manage_project/config/constants.dart';

/// Repository for managing user profile information
class ProfileRepository {
  final ApiService _apiService;
  final Logger _logger = Logger('ProfileRepository');

  ProfileRepository({required ApiService apiService}) : _apiService = apiService;

  /// Get current user's information
  Future<Map<String, dynamic>> getInformation(String userId) async {
    try {
      final response = await _apiService.get('${ApiConfig.information}$userId');
      return response ?? {};
    } catch (e) {
      _logger.error('Error getting user information: $e');
      return {'error': e.toString()};
    }
  }

  /// Create information for the current user
  /// 
  /// [data]: Map containing information data
  Future<Map<String, dynamic>> createInformation(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(
        ApiConfig.information,
        body: data,
      );
      return response ?? {};
    } catch (e) {
      _logger.error('Error creating information: $e');
      return {'error': e.toString()};
    }
  }

  /// Update information for the current user
  /// 
  /// [infoId]: The ID of the information record to update
  /// [data]: Map containing updated information data
  Future<Map<String, dynamic>> updateInformation(String infoId, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.put(
        '${ApiConfig.information}$infoId',
        body: data,
      );
      return response ?? {};
    } catch (e) {
      _logger.error('Error updating information: $e');
      return {'error': e.toString()};
    }
  }

  /// Get student profile information
  Future<Map<String, dynamic>> getStudentProfile() async {
    try {
      final response = await _apiService.get(ApiConfig.studentProfile);
      return response ?? {};
    } catch (e) {
      _logger.error('Error getting student profile: $e');
      return {'error': e.toString()};
    }
  }  /// Create student profile information
  /// 
  /// [data]: Map containing student profile data with information and student_info
  Future<Map<String, dynamic>> createStudentProfile(Map<String, dynamic> data) async {
    int maxRetries = 3;
    int currentRetry = 0;
    
    while (currentRetry < maxRetries) {
      try {
        _logger.debug('Creating student profile with data (attempt ${currentRetry + 1}/$maxRetries): $data');
        final response = await _apiService.post(
          ApiConfig.studentProfile,
          body: data,
        );
        _logger.debug('Student profile create response: $response');
        
        // Even if response is null or empty, consider it successful
        if (response == null) {
          return {'success': true, 'message': 'Profile created successfully'};
        }
        
        if (response is Map<String, dynamic>) {
          return response;
        }
        
        return {'success': true, 'data': response, 'message': 'Profile created successfully'};
      } catch (e) {
        _logger.error('Error creating student profile (attempt ${currentRetry + 1}/$maxRetries): $e');
        currentRetry++;
        
        // Check if this is a connection error that might be worth retrying
        final errorMessage = e.toString().toLowerCase();
        bool isRetryableError = errorMessage.contains('connection closed') ||
                               errorMessage.contains('connection timeout') ||
                               errorMessage.contains('socket exception') ||
                               errorMessage.contains('network error');
        
        if (currentRetry < maxRetries && isRetryableError) {
          _logger.debug('Retryable error detected, waiting before retry...');
          await Future.delayed(Duration(milliseconds: 1000 * currentRetry)); // Progressive delay
          continue;
        } else {
          // Not retryable or max retries reached
          return {'error': e.toString()};
        }
      }
    }
    
    return {'error': 'Max retries exceeded'};
  }  /// Update student profile information
  /// 
  /// [data]: Map containing updated student profile data with information and student_info
  Future<Map<String, dynamic>> updateStudentProfile(Map<String, dynamic> data) async {
    int maxRetries = 2;
    int currentRetry = 0;
    
    while (currentRetry < maxRetries) {
      try {
        _logger.debug('Updating student profile with data (attempt ${currentRetry + 1}/$maxRetries): $data');
        final response = await _apiService.put(
          ApiConfig.studentProfile,
          body: data,
        );
        _logger.debug('Student profile update response: $response');
        
        // Even if response is null or empty, consider it successful
        // as long as no exception was thrown
        if (response == null) {
          _logger.debug('Response is null but no exception - considering successful');
          return {'success': true, 'message': 'Profile updated successfully'};
        }
        
        // If response is a Map, return it directly
        if (response is Map<String, dynamic>) {
          return response;
        }
        
        // For other response types, wrap in success response
        return {'success': true, 'data': response, 'message': 'Profile updated successfully'};
      } catch (e) {
        _logger.error('Error updating student profile (attempt ${currentRetry + 1}/$maxRetries): $e');
        currentRetry++;
        
        // Check if this is a server error (500) that might indicate profile doesn't exist
        final errorMessage = e.toString();
        if (errorMessage.contains('Mã lỗi: 500') || errorMessage.contains('500')) {
          _logger.debug('Received 500 error - profile might not exist, will need to create');
          // Return a special error that indicates we should try creating instead
          return {'error': 'PROFILE_NOT_EXISTS', 'original_error': errorMessage};
        }
        
        // Check if this is a connection error that might be worth retrying
        final errorLower = errorMessage.toLowerCase();
        bool isRetryableError = errorLower.contains('connection closed') ||
                               errorLower.contains('connection timeout') ||
                               errorLower.contains('socket exception') ||
                               errorLower.contains('network error');
        
        if (currentRetry < maxRetries && isRetryableError) {
          _logger.debug('Retryable connection error detected, waiting before retry...');
          await Future.delayed(Duration(milliseconds: 1000 * currentRetry)); // Progressive delay
          continue;
        } else {
          // Not retryable or max retries reached
          return {'error': 'Lỗi kết nối mạng: $e'};
        }
      }
    }
    
    return {'error': 'Max retries exceeded'};
  }

  /// Get lecturer profile information
  Future<Map<String, dynamic>> getLecturerProfile() async {
    try {
      final response = await _apiService.get(ApiConfig.lecturerProfile);
      return response ?? {};
    } catch (e) {
      _logger.error('Error getting lecturer profile: $e');
      return {'error': e.toString()};
    }
  }
  /// Create lecturer profile information
  /// 
  /// [data]: Map containing lecturer profile data with information and lecturer_info
  Future<Map<String, dynamic>> createLecturerProfile(Map<String, dynamic> data) async {
    try {
      _logger.debug('Creating lecturer profile with data: $data');
      final response = await _apiService.post(
        ApiConfig.lecturerProfile,
        body: data,
      );
      _logger.debug('Lecturer profile create response: $response');
      
      // Even if response is null or empty, consider it successful
      if (response == null) {
        return {'success': true, 'message': 'Profile created successfully'};
      }
      
      if (response is Map<String, dynamic>) {
        return response;
      }
      
      return {'success': true, 'data': response, 'message': 'Profile created successfully'};
    } catch (e) {
      _logger.error('Error creating lecturer profile: $e');
      return {'error': e.toString()};
    }
  }  /// Update lecturer profile information
  /// 
  /// [data]: Map containing updated lecturer profile data with information and lecturer_info
  Future<Map<String, dynamic>> updateLecturerProfile(Map<String, dynamic> data) async {
    try {
      _logger.debug('Updating lecturer profile with data: $data');
      final response = await _apiService.put(
        ApiConfig.lecturerProfile,
        body: data,
      );
      _logger.debug('Lecturer profile update response: $response');
      
      // Even if response is null or empty, consider it successful
      // as long as no exception was thrown
      if (response == null) {
        _logger.debug('Response is null but no exception - considering successful');
        return {'success': true, 'message': 'Profile updated successfully'};
      }
      
      // If response is a Map, return it directly
      if (response is Map<String, dynamic>) {
        return response;
      }
      
      // For other response types, wrap in success response
      return {'success': true, 'data': response, 'message': 'Profile updated successfully'};
    } catch (e) {
      _logger.error('Error updating lecturer profile: $e');
      
      // Check if this is a server error (500) that might indicate profile doesn't exist
      final errorMessage = e.toString();
      if (errorMessage.contains('Mã lỗi: 500') || errorMessage.contains('500')) {
        _logger.debug('Received 500 error - profile might not exist, will need to create');
        // Return a special error that indicates we should try creating instead
        return {'error': 'PROFILE_NOT_EXISTS', 'original_error': errorMessage};
      }
      
      return {'error': 'Lỗi kết nối mạng: $e'};
    }
  }/// Get complete user profile based on user type
  Future<Map<String, dynamic>> getUserProfile(int userType) async {
    try {
      switch (userType) {
        case AppConfig.userTypeLecturer: // Lecturer (3)
          return await getLecturerProfile();
        case AppConfig.userTypeStudent: // Student (2)
          return await getStudentProfile();
        default:
          return {'error': 'Unsupported user type'};
      }
    } catch (e) {
      _logger.error('Error getting user profile: $e');
      return {'error': e.toString()};
    }
  }  /// Create or update complete user profile based on user type
  /// 
  /// [userType]: Type of user (student=2, lecturer=3)
  /// [data]: Profile data to save
  /// [forceUpdate]: If true, will attempt update first, then create if update fails
  Future<Map<String, dynamic>> createOrUpdateProfile(
    int userType, 
    Map<String, dynamic> data, {
    bool forceUpdate = true,
  }) async {
    try {
      switch (userType) {
        case AppConfig.userTypeLecturer: // Lecturer (3)
          if (forceUpdate) {
            // Try to update first, if it fails then create
            _logger.debug('Attempting to update lecturer profile first');
            final updateResult = await updateLecturerProfile(data);
            
            // Check if update failed because profile doesn't exist
            if (updateResult.containsKey('error')) {
              if (updateResult['error'] == 'PROFILE_NOT_EXISTS') {
                _logger.debug('Profile doesn\'t exist, creating new profile');
                return await createLecturerProfile(data);
              } else {
                // Other errors, return as-is
                return updateResult;
              }
            } else {
              // Update successful
              return updateResult;
            }
          } else {
            // Check if profile exists first (old behavior)
            final lecturerProfile = await getLecturerProfile();
            if (lecturerProfile.containsKey('error') || 
                !lecturerProfile.containsKey('lecturer_info')) {
              return await createLecturerProfile(data);
            } else {
              return await updateLecturerProfile(data);
            }
          }
        case AppConfig.userTypeStudent: // Student (2)
          if (forceUpdate) {
            // Try to update first, if it fails then create
            _logger.debug('Attempting to update student profile first');
            final updateResult = await updateStudentProfile(data);
            
            // Check if update failed because profile doesn't exist
            if (updateResult.containsKey('error')) {
              if (updateResult['error'] == 'PROFILE_NOT_EXISTS') {
                _logger.debug('Profile doesn\'t exist, creating new profile');
                return await createStudentProfile(data);
              } else {
                // Other errors, return as-is
                return updateResult;
              }
            } else {
              // Update successful
              return updateResult;
            }
          } else {
            // Check if profile exists first (old behavior)
            final studentProfile = await getStudentProfile();
            if (studentProfile.containsKey('error') || 
                !studentProfile.containsKey('student_info')) {
              return await createStudentProfile(data);
            } else {
              return await updateStudentProfile(data);
            }
          }
        default:
          return {'error': 'Unsupported user type'};
      }
    } catch (e) {
      _logger.error('Error creating or updating user profile: $e');
      return {'error': e.toString()};
    }
  }
}
