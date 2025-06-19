import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFF42A5F5);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color accent = Color(0xFFFFA000);
  
  // Common Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFB00020);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color textLight = Color(0xFFFFFFFF);
}

class AppDimens {
  // Margins and Paddings
  static const double marginSmall = 4.0;
  static const double marginRegular = 8.0;
  static const double marginMedium = 16.0;
  static const double marginLarge = 24.0;
  static const double marginExtraLarge = 32.0;
  
  // Border Radius
  static const double radiusSmall = 4.0;
  static const double radiusRegular = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusExtraLarge = 24.0;
}

class AppConfig {
  // App Information
  static const String appName = "Quản lý Đề tài Khóa luận";
  static const String appVersion = "0.1.0";  // User Types
  static const int userTypeAdmin = 1;
  static const int userTypeStudent = 2;
  static const int userTypeLecturer = 3;
  
  // Thesis Types
  static const int thesisTypeCapstone = 1;
  static const int thesisTypeThesis = 2;
    // Cache Keys
  static const String tokenKey = "auth_token";
  static const String refreshTokenKey = "refresh_token";
  static const String userInfoKey = "user_info";
  static const String userTypeKey = "user_type";
}

class UserRole {
  static const String admin = "ADMIN";
  static const String lecturer = "LECTURER";
  static const String student = "STUDENT";
}

class Constants {
  // Authentication
  static const String accessToken = "access_token";
  static const String refreshToken = "refresh_token";
  static const String isLoggedIn = "is_logged_in";
  
  // User Information
  static const String userId = "user_id";
  static const String userName = "user_name";
  static const String userType = "user_type";
  static const String userInfo = "user_info";
  
  // Permissions
  static const String userPermissions = "user_permissions";
  static const String userRoles = "user_roles";
  
  // Features
  static const String featureGroup = "group";
  static const String featureThesis = "thesis";
  static const String featureProfile = "profile";
  static const String featureAdmin = "admin";
}

class FunctionPaths {
  // Admin paths
  static const String adminDashboard = "/admin/dashboard";
  static const String adminUsers = "/admin/users";
  static const String adminRoles = "/admin/roles";
  
  // Lecturer paths
  static const String lecturerTheses = "/lecturer/theses";
  static const String lecturerDashboard = "/lecturer/dashboard";
  static const String lecturerStudents = "/lecturer/students";
  static const String lecturerCommittee = "/lecturer/committee";
    // Student paths
  static const String studentDashboard = "/student/dashboard";
  static const String studentGroupManagement = "/student/group";
  static const String studentThesisRegistration = "/student/thesis";
  static const String studentTaskManagement = "/student/tasks";
  static const String studentProgressTracking = "/student/progress";
  
  // Common paths
  static const String profile = "/profile";
  static const String settings = "/settings";

  // Additional function paths for drawer menu
  static const String thesisManagementPath = "/thesis/management";
  static const String groupManagementPath = "/group/management";
  static const String userManagementPath = "/user/management";
  static const String reportPath = "/report";
  static const String debugPath = "/debug";
}
