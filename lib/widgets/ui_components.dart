import 'package:flutter/material.dart';
import 'package:thesis_manage_project/config/constants.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isExtended;
  final String? label;

  const FloatingActionButtonWidget({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.isExtended = false,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isExtended && label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: foregroundColor ?? Colors.white,
        ),
        label: Text(
          label!,
          style: TextStyle(
            color: foregroundColor ?? Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: backgroundColor ?? AppColors.primary,
        tooltip: tooltip,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor ?? Colors.white,
      tooltip: tooltip,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon),
    );
  }
}

class CustomChip extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isSelected;

  const CustomChip({
    Key? key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.onPressed,
    this.icon,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? (backgroundColor ?? AppColors.primary)
              : (backgroundColor ?? AppColors.primary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: backgroundColor ?? AppColors.primary,
            width: isSelected ? 0 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected 
                    ? (textColor ?? Colors.white)
                    : (backgroundColor ?? AppColors.primary),
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected 
                    ? (textColor ?? Colors.white)
                    : (backgroundColor ?? AppColors.primary),
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressIndicatorWidget extends StatelessWidget {
  final double progress;
  final String? label;
  final Color? color;
  final double height;
  final bool showPercentage;

  const ProgressIndicatorWidget({
    Key? key,
    required this.progress,
    this.label,
    this.color,
    this.height = 8,
    this.showPercentage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label!,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              if (showPercentage)
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: color ?? AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: color ?? AppColors.primary,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;
  final bool isOutlined;

  const StatusBadge({
    Key? key,
    required this.text,
    required this.color,
    this.icon,
    this.isOutlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isOutlined ? Colors.transparent : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: isOutlined ? Border.all(color: color, width: 1) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 14,
              color: color,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;

  const QuickActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: (color ?? AppColors.primary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: (color ?? AppColors.primary).withOpacity(0.2),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color ?? AppColors.primary,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color ?? AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Common widget components for consistent UI across the app
class UIComponents {
  /// Creates a modern section header with icon and title
  static Widget sectionHeader({
    required String title,
    required IconData icon,
    Color? color,
    String? subtitle,
    Widget? action,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (color ?? AppColors.primary).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color ?? AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          if (action != null) action,
        ],
      ),
    );
  }

  /// Creates a modern info card with consistent styling
  static Widget infoCard({
    required String title,
    required String value,
    required IconData icon,
    Color? color,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (color ?? AppColors.primary).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color ?? AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: color ?? AppColors.primary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (onTap != null)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Creates a modern action button with consistent styling
  static Widget actionButton({
    required String title,
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
    bool isLoading = false,
    bool isOutlined = false,
  }) {
    final buttonColor = color ?? AppColors.primary;
    
    return Container(
      width: double.infinity,
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: isOutlined 
        ? OutlinedButton.icon(
            onPressed: isLoading ? null : onPressed,
            icon: isLoading 
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
                  ),
                )
              : Icon(icon),
            label: Text(title),
            style: OutlinedButton.styleFrom(
              foregroundColor: buttonColor,
              side: BorderSide(color: buttonColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          )
        : ElevatedButton.icon(
            onPressed: isLoading ? null : onPressed,
            icon: isLoading 
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Icon(icon),
            label: Text(title),
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
    );
  }

  /// Creates a modern status chip
  static Widget statusChip({
    required String label,
    Color? color,
    Color? backgroundColor,
    IconData? icon,
  }) {
    final chipColor = color ?? AppColors.primary;
    final chipBgColor = backgroundColor ?? chipColor.withOpacity(0.1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipBgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: chipColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: chipColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Creates an empty state widget
  static Widget emptyState({
    required String title,
    required String message,
    required IconData icon,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.add),
              label: Text(actionLabel),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Creates a modern loading indicator
  static Widget loadingIndicator({String? message}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Creates a modern error widget
  static Widget errorWidget({
    required String title,
    required String message,
    String? actionLabel,
    VoidCallback? onRetry,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          if (actionLabel != null && onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(actionLabel),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
