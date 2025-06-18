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
  static const String appVersion = "0.1.0";
  
  // User Types
  static const int userTypeAdmin = 1;
  static const int userTypeLecturer = 2;
  static const int userTypeStudent = 3;
  
  // Thesis Types
  static const int thesisTypeCapstone = 1;
  static const int thesisTypeThesis = 2;
  
  // Cache Keys
  static const String tokenKey = "auth_token";
  static const String refreshTokenKey = "refresh_token";
  static const String userInfoKey = "user_info";
}

class UserRole {
  static const String admin = "ADMIN";
  static const String lecturer = "LECTURER";
  static const String student = "STUDENT";
}
