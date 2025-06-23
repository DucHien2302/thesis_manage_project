import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thesis_manage_project/config/constants.dart';

class UserUtils {  /// Get current user ID from SharedPreferences
  static Future<String?> getCurrentUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userInfoJson = prefs.getString(AppConfig.userInfoKey);
      
      if (userInfoJson != null) {
        final userInfo = json.decode(userInfoJson) as Map<String, dynamic>;
        // User data uses 'id' key, not 'user_id'
        return userInfo['id'] as String?;
      }
      
      return null;
    } catch (e) {
      print('Error getting user ID: $e');
      return null;
    }
  }

  /// Get current user name from SharedPreferences
  static Future<String?> getCurrentUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userInfoJson = prefs.getString(AppConfig.userInfoKey);
      
      if (userInfoJson != null) {
        final userInfo = json.decode(userInfoJson) as Map<String, dynamic>;
        return userInfo['user_name'] as String?;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get current user type from SharedPreferences
  static Future<String?> getCurrentUserType() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userInfoJson = prefs.getString(AppConfig.userInfoKey);
      
      if (userInfoJson != null) {
        final userInfo = json.decode(userInfoJson) as Map<String, dynamic>;
        return userInfo['user_type'] as String?;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get full user info from SharedPreferences
  static Future<Map<String, dynamic>?> getCurrentUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userInfoJson = prefs.getString(AppConfig.userInfoKey);
      
      if (userInfoJson != null) {
        return json.decode(userInfoJson) as Map<String, dynamic>;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }
}
