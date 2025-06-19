import 'package:flutter/foundation.dart';

/// Utility class for logging messages with different severity levels
/// 
/// This logger will only print to console in debug mode
class Logger {
  final String _tag;

  Logger(this._tag);

  void debug(String message) {
    if (kDebugMode) {
      print('DEBUG [$_tag] $message');
    }
  }

  void info(String message) {
    if (kDebugMode) {
      print('INFO [$_tag] $message');
    }
  }

  void warn(String message) {
    if (kDebugMode) {
      print('WARN [$_tag] $message');
    }
  }

  void error(String message) {
    if (kDebugMode) {
      print('ERROR [$_tag] $message');
    }
  }
}
