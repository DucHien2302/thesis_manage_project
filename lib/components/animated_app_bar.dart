import 'package:flutter/material.dart';
import 'package:thesis_manage_project/config/constants.dart';

class AnimatedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final Widget? leading;
  final double elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const AnimatedAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.centerTitle = true,
    this.leading,
    this.elevation = 2.0,
    this.backgroundColor,
    this.foregroundColor,
    this.showBackButton = false,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.appBarTheme.backgroundColor ?? AppColors.primary;
    final fgColor = foregroundColor ?? theme.appBarTheme.foregroundColor ?? AppColors.textLight;

    return AppBar(
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      elevation: elevation,
      centerTitle: centerTitle,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : leading,
      title: _buildAnimatedTitle(title, theme),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              bgColor,
              Color.lerp(bgColor, Colors.black, 0.2) ?? bgColor,
            ],
          ),
        ),
      ),
      actions: actions != null
          ? actions!.map((action) => _wrapWithRippleEffect(action)).toList()
          : null,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
    );
  }

  Widget _buildAnimatedTitle(String title, ThemeData theme) {
    return DefaultTextStyle(
      style: theme.textTheme.titleLarge?.copyWith(
            color: foregroundColor ?? AppColors.textLight,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ) ??
          const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textLight,
          ),
      child: Text(title),
    );
  }

  Widget _wrapWithRippleEffect(Widget child) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        splashColor: Colors.white.withOpacity(0.1),
        highlightColor: Colors.white.withOpacity(0.05),
        child: child,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
