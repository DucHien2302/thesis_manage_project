import 'dart:math';
import 'package:flutter/material.dart';
import 'package:thesis_manage_project/config/constants.dart';

class AnimatedLoadingIndicator extends StatefulWidget {
  final Color color;
  final double size;
  final double strokeWidth;
  final Duration duration;
  final Widget? child;
  final String? message;

  const AnimatedLoadingIndicator({
    Key? key,
    this.color = AppColors.primary,
    this.size = 40.0,
    this.strokeWidth = 4.0,
    this.duration = const Duration(seconds: 1),
    this.child,
    this.message,
  }) : super(key: key);

  @override
  _AnimatedLoadingIndicatorState createState() => _AnimatedLoadingIndicatorState();
}

class _AnimatedLoadingIndicatorState extends State<AnimatedLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _LoadingPainter(
                  animation: _controller,
                  color: widget.color,
                  strokeWidth: widget.strokeWidth,
                ),
                child: SizedBox(
                  width: widget.size,
                  height: widget.size,
                  child: Center(
                    child: widget.child,
                  ),
                ),
              );
            },
          ),
          if (widget.message != null) ...[
            const SizedBox(height: AppDimens.marginMedium),
            Text(
              widget.message!,
              style: TextStyle(
                fontSize: 14,
                color: widget.color,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LoadingPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;
  final double strokeWidth;

  _LoadingPainter({
    required this.animation,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = min(centerX, centerY) - strokeWidth / 2;

    final Paint arcPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw background circle
    arcPaint.color = color.withOpacity(0.2);
    canvas.drawCircle(Offset(centerX, centerY), radius, arcPaint);

    // Draw animated arc
    arcPaint.color = color;
    final double sweepAngle = 2 * pi * (0.5 + animation.value / 2);
    final double startAngle = 2 * pi * (animation.value * 1.5);
    
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(centerX, centerY),
        radius: radius,
      ),
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );

    // Draw small circle at the end of the arc
    final double endX = centerX + radius * cos(startAngle + sweepAngle);
    final double endY = centerY + radius * sin(startAngle + sweepAngle);
    
    arcPaint.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(endX, endY), strokeWidth / 2, arcPaint);
  }

  @override
  bool shouldRepaint(_LoadingPainter oldDelegate) {
    return oldDelegate.animation.value != animation.value ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

// Fullscreen loading overlay
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;
  final Color overlayColor;
  
  const LoadingOverlay({
    Key? key,
    required this.isLoading,
    required this.child,
    this.message,
    this.overlayColor = Colors.black54,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: overlayColor,
              child: AnimatedLoadingIndicator(
                size: 60,
                message: message,
                color: Colors.white,
                child: const Icon(
                  Icons.school,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
