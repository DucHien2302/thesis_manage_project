import 'package:flutter/material.dart';
import 'package:thesis_manage_project/config/constants.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const FloatingActionButtonWidget({
    Key? key,
    required this.onPressed,
    this.icon = Icons.add,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (backgroundColor ?? AppColors.primary).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        tooltip: tooltip,
        child: Icon(
          icon,
          color: foregroundColor ?? Colors.white,
          size: 28,
        ),
      ),
    );
  }
}

class MultiFloatingActionButton extends StatefulWidget {
  final List<FloatingActionItem> items;
  final IconData mainIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const MultiFloatingActionButton({
    Key? key,
    required this.items,
    this.mainIcon = Icons.add,
    this.backgroundColor,
    this.foregroundColor,
  }) : super(key: key);

  @override
  State<MultiFloatingActionButton> createState() => _MultiFloatingActionButtonState();
}

class _MultiFloatingActionButtonState extends State<MultiFloatingActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
    });
    if (_isOpen) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...widget.items.asMap().entries.map((entry) {
          int index = entry.key;
          FloatingActionItem item = entry.value;
          return AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  0,
                  -_animation.value * (index + 1) * 60,
                ),
                child: Opacity(
                  opacity: _animation.value,
                  child: ScaleTransition(
                    scale: _animation,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: FloatingActionButtonWidget(
                        onPressed: () {
                          _toggle();
                          item.onPressed();
                        },
                        icon: item.icon,
                        tooltip: item.tooltip,
                        backgroundColor: item.backgroundColor ?? widget.backgroundColor,
                        foregroundColor: item.foregroundColor ?? widget.foregroundColor,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
        FloatingActionButtonWidget(
          onPressed: _toggle,
          icon: _isOpen ? Icons.close : widget.mainIcon,
          backgroundColor: widget.backgroundColor,
          foregroundColor: widget.foregroundColor,
        ),
      ],
    );
  }
}

class FloatingActionItem {
  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;

  FloatingActionItem({
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
  });
}
