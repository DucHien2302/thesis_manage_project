import 'package:flutter/material.dart';
import 'package:thesis_manage_project/config/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = false,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            backgroundColor ?? AppColors.primary,
            (backgroundColor ?? AppColors.primary).withOpacity(0.8),
          ],
        ),
        boxShadow: elevation != null && elevation! > 0 ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: elevation! * 2,
            offset: Offset(0, elevation!),
          ),
        ] : null,
      ),
      child: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: foregroundColor ?? Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: foregroundColor ?? Colors.white,
        elevation: 0,
        leading: showBackButton 
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              )
            : leading,
        actions: actions,
        centerTitle: true,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final List<Color> gradientColors;
  final double? elevation;

  const GradientAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    required this.gradientColors,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        boxShadow: elevation != null && elevation! > 0 ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: elevation! * 2,
            offset: Offset(0, elevation!),
          ),
        ] : null,
      ),
      child: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: leading,
        actions: actions,
        centerTitle: true,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
