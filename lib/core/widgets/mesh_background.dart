import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MeshBackground extends StatelessWidget {
  final Widget child;

  const MeshBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _MeshPainter(),
          ),
        ),
        // Glass Overlay
        Positioned.fill(
          child: Container(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}

class _MeshPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50);
    final random = Random(42); // Seed for consistency

    // Draw diverse organic blobs
    for (int i = 0; i < 5; i++) {
      final center = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );
      final radius = random.nextDouble() * size.width * 0.8;
      final color = AppColors.meshColors[i % AppColors.meshColors.length];

      paint.color = color;
      canvas.drawCircle(center, radius as double, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
