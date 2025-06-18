import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_manage_project/services/permission_service.dart';

/// A widget that shows or hides its child based on user permissions
/// 
/// If the user has the required permission, the child is shown
/// Otherwise, it's either hidden or replaced with a placeholder
class PermissionAwareWidget extends StatelessWidget {
  /// The function path to check permission for
  final String functionPath;
  
  /// The widget to show if permission is granted
  final Widget child;
  
  /// Whether to show a placeholder when permission is denied
  /// If false, the widget will collapse and not take any space
  final bool showPlaceholder;
  
  /// Optional placeholder widget to show when permission is denied
  /// If null and [showPlaceholder] is true, a default placeholder is shown
  final Widget? placeholder;

  const PermissionAwareWidget({
    Key? key,
    required this.functionPath,
    required this.child,
    this.showPlaceholder = false,
    this.placeholder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final permissionService = context.read<PermissionService>();
    
    // Check if user has permission for this function
    if (permissionService.hasPermission(functionPath)) {
      return child;
    }
    
    // Handle case when permission is denied
    if (showPlaceholder) {
      return placeholder ?? const SizedBox(
        height: 48,
        child: Center(
          child: Text('Bạn không có quyền truy cập chức năng này',
            style: TextStyle(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }
    
    // Return empty widget if no placeholder needed
    return const SizedBox.shrink();
  }
}

/// Extension for easy permission checking
extension PermissionCheckExtension on BuildContext {
  bool hasPermission(String functionPath) {
    return read<PermissionService>().hasPermission(functionPath);
  }
  
  Future<bool> isAdmin() {
    return read<PermissionService>().isAdmin();
  }
  
  Future<bool> isLecturer() {
    return read<PermissionService>().isLecturer();
  }
  
  Future<bool> isStudent() {
    return read<PermissionService>().isStudent();
  }
}
