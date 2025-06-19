import 'package:flutter/material.dart';
import 'package:thesis_manage_project/config/constants.dart';

class AppSnackBar {
  static SnackBar success(String message, {SnackBarAction? action}) {
    return SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: AppDimens.marginRegular),
          Expanded(
            child: Text(message),
          ),
        ],
      ),
      backgroundColor: AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusRegular),
      ),
      action: action,
      duration: const Duration(seconds: 3),
    );
  }

  static SnackBar error(String message, {SnackBarAction? action}) {
    return SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: AppDimens.marginRegular),
          Expanded(
            child: Text(message),
          ),
        ],
      ),
      backgroundColor: AppColors.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusRegular),
      ),
      action: action ?? SnackBarAction(
        label: 'Đóng',
        textColor: Colors.white,
        onPressed: () {},
      ),
      duration: const Duration(seconds: 4),
    );
  }

  static SnackBar info(String message, {SnackBarAction? action}) {
    return SnackBar(
      content: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.white),
          const SizedBox(width: AppDimens.marginRegular),
          Expanded(
            child: Text(message),
          ),
        ],
      ),
      backgroundColor: AppColors.info,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusRegular),
      ),
      action: action,
      duration: const Duration(seconds: 3),
    );
  }

  static SnackBar warning(String message, {SnackBarAction? action}) {
    return SnackBar(
      content: Row(
        children: [
          const Icon(Icons.warning_amber_outlined, color: Colors.white),
          const SizedBox(width: AppDimens.marginRegular),
          Expanded(
            child: Text(message),
          ),
        ],
      ),
      backgroundColor: AppColors.warning,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusRegular),
      ),
      action: action,
      duration: const Duration(seconds: 4),
    );
  }
}

class AppDialog {
  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Xác nhận',
    String cancelText = 'Hủy',
    Color confirmColor = AppColors.primary,
    bool isDanger = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelText),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDanger ? AppColors.error : confirmColor,
              ),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showInfoDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(buttonText),
            ),
          ],
        );
      },
    );
  }
}

class AppTransition {
  static PageRouteBuilder<T> slideRight<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  static PageRouteBuilder<T> fadeIn<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static PageRouteBuilder<T> scale<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var curve = Curves.easeInOut;
        var curveTween = CurveTween(curve: curve);
        
        return ScaleTransition(
          scale: animation.drive(Tween(begin: 0.8, end: 1.0).chain(curveTween)),
          child: FadeTransition(
            opacity: animation.drive(Tween(begin: 0.5, end: 1.0).chain(curveTween)),
            child: child,
          ),
        );
      },
    );
  }
}
