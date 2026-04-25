import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

class CompanionGuide extends StatefulWidget {
  final String mood; // 'happy', 'sleepy', 'excited'

  const CompanionGuide({super.key, this.mood = 'happy'});

  @override
  State<CompanionGuide> createState() => _CompanionGuideState();
}

class _CompanionGuideState extends State<CompanionGuide> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 15.h).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: Container(
        width: 100.w,
        height: 100.h,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.azure.withValues(alpha: 0.4),
              blurRadius: 30.r,
              spreadRadius: 10.r,
            )
          ],
        ),
        child: CustomPaint(
          painter: _LisaPainter(mood: widget.mood),
        ),
      ),
    );
  }
}

class _LisaPainter extends CustomPainter {
  final String mood;
  _LisaPainter({required this.mood});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = AppColors.proGradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Draw the Blob Body
    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.1, size.width * 0.8, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.9, size.height * 0.9, size.width * 0.5, size.height * 0.9)
      ..quadraticBezierTo(size.width * 0.1, size.height * 0.9, size.width * 0.2, size.height * 0.5)
      ..close();

    canvas.drawPath(path, paint);

    // Eyes
    final eyePaint = Paint()..color = AppColors.textMain.withValues(alpha: 0.8);
    if (mood == 'sleepy') {
      canvas.drawLine(Offset(size.width * 0.35, size.height * 0.5), Offset(size.width * 0.45, size.height * 0.5), eyePaint..strokeWidth = 3);
      canvas.drawLine(Offset(size.width * 0.55, size.height * 0.5), Offset(size.width * 0.65, size.height * 0.5), eyePaint..strokeWidth = 3);
    } else {
      canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.5), 4.r, eyePaint);
      canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.5), 4.r, eyePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
