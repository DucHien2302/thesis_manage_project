import 'package:flutter/material.dart';
import 'package:thesis_manage_project/config/constants.dart';

class AnimatedCard extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final Color? color;
  final Color? shadowColor;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool showBorder;
  final Color borderColor;
  final double borderWidth;

  const AnimatedCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.elevation = 2.0,
    this.padding = const EdgeInsets.all(AppDimens.marginMedium),
    this.borderRadius,
    this.color,
    this.shadowColor,
    this.gradient,
    this.onTap,
    this.isLoading = false,
    this.showBorder = false,
    this.borderColor = AppColors.primary,
    this.borderWidth = 1.0,
  }) : super(key: key);

  @override
  _AnimatedCardState createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      setState(() {
        _isPressed = true;
      });
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      setState(() {
        _isPressed = false;
      });
      _controller.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.onTap != null) {
      setState(() {
        _isPressed = false;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = widget.color ?? theme.cardColor;
    final cardShadowColor = widget.shadowColor ?? Colors.black;
    final finalBorderRadius = widget.borderRadius ?? BorderRadius.circular(AppDimens.radiusMedium);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.onTap != null ? _scaleAnimation.value : 1.0,
          child: GestureDetector(
            onTapDown: widget.onTap != null && !widget.isLoading ? _onTapDown : null,
            onTapUp: widget.onTap != null && !widget.isLoading ? _onTapUp : null,
            onTapCancel: widget.onTap != null && !widget.isLoading ? _onTapCancel : null,
            onTap: widget.isLoading ? null : widget.onTap,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.gradient != null ? null : cardColor,
                gradient: widget.gradient,
                borderRadius: finalBorderRadius,
                border: widget.showBorder
                    ? Border.all(
                        color: widget.borderColor,
                        width: widget.borderWidth,
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: cardShadowColor.withOpacity(_isPressed ? 0.1 : 0.15),
                    blurRadius: widget.elevation * 2,
                    spreadRadius: widget.elevation * 0.5,
                    offset: Offset(0, widget.elevation * 0.5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: finalBorderRadius,
                child: Stack(
                  children: [
                    Padding(
                      padding: widget.padding,
                      child: widget.child,
                    ),
                    if (widget.isLoading)
                      Positioned.fill(
                        child: Container(
                          color: cardColor.withOpacity(0.7),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    if (widget.onTap != null)
                      Positioned.fill(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: widget.borderColor.withOpacity(0.1),
                            highlightColor: Colors.transparent,
                            borderRadius: finalBorderRadius,
                            onTap: widget.isLoading ? null : widget.onTap,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
