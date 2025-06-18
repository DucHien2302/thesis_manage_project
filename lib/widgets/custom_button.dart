import 'package:flutter/material.dart';

/// Custom button component with loading state support
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final bool isLoading;
  final bool fullWidth;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.isLoading = false,
    this.fullWidth = true,
    this.height = 48.0,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? theme.primaryColor,
          foregroundColor: textColor ?? Colors.white,
          disabledBackgroundColor: backgroundColor?.withOpacity(0.7) ?? theme.primaryColor.withOpacity(0.7),
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: borderColor != null
                ? BorderSide(color: borderColor!)
                : BorderSide.none,
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24.0,
                width: 24.0,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? Colors.white,
                ),
              ),
      ),
    );
  }
}
