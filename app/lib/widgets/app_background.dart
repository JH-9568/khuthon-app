import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFCF4), Color(0xFFF5FAEE), Color(0xFFEFF8E9)],
          stops: [0, .48, 1],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: -86,
            right: -72,
            child: _LightBlob(
              size: 230,
              color: AppColors.wiseGreen.withValues(alpha: .18),
            ),
          ),
          Positioned(
            top: 210,
            left: -98,
            child: _LightBlob(
              size: 210,
              color: const Color(0xFFFFD66B).withValues(alpha: .14),
            ),
          ),
          Positioned(
            bottom: -86,
            right: -56,
            child: _LightBlob(
              size: 220,
              color: const Color(0xFFFFB48A).withValues(alpha: .12),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _SoftGridPainter()),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _LightBlob extends StatelessWidget {
  const _LightBlob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    );
  }
}

class _SoftGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.nearBlack.withValues(alpha: .025)
      ..strokeWidth = 1;

    for (var y = 38.0; y < size.height; y += 76) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
