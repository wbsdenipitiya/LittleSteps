import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

class FloatingCard extends StatefulWidget {
  final Widget child;
  final Color? color;
  final VoidCallback? onTap;
  final double? borderRadius;
  final bool animate;

  const FloatingCard({
    super.key,
    required this.child,
    this.color,
    this.onTap,
    this.borderRadius,
    this.animate = true,
  });

  @override
  State<FloatingCard> createState() => _FloatingCardState();
}

class _FloatingCardState extends State<FloatingCard> with SingleTickerProviderStateMixin {
  late AnimationController _bobController;
  late Animation<double> _bobAnimation;
  
  Offset _tiltOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _bobController = AnimationController(
        duration: const Duration(seconds: 4), vsync: this);
    
    if (widget.animate) {
      _bobAnimation = Tween<double>(begin: 0.0, end: 8.0.h).animate(
        CurvedAnimation(parent: _bobController, curve: Curves.easeInOut),
      );
      _bobController.repeat(reverse: true);
    } else {
      _bobAnimation = const AlwaysStoppedAnimation(0.0);
    }
  }

  @override
  void dispose() {
    _bobController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    setState(() {
      _tiltOffset = Offset(
        (details.localPosition.dx / constraints.maxWidth) - 0.5,
        (details.localPosition.dy / constraints.maxHeight) - 0.5,
      );
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() => _tiltOffset = Offset.zero);
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? 24.r;
    final cardColor = widget.color ?? AppColors.secondaryBackground;

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: widget.onTap,
          onPanUpdate: (details) => _onPanUpdate(details, constraints),
          onPanEnd: _onPanEnd,
          onPanCancel: () => setState(() => _tiltOffset = Offset.zero),
          child: AnimatedBuilder(
            animation: _bobAnimation,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // Perspective
                  ..rotateX(-_tiltOffset.dy * 0.2)
                  ..rotateY(_tiltOffset.dx * 0.2)
                  ..translate(0.0, _bobAnimation.value),
                alignment: FractionalOffset.center,
                child: child,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(radius),
                boxShadow: [
                  // Dynamic Glow
                  BoxShadow(
                    color: (widget.color ?? AppColors.seafoam).withValues(alpha: 0.3),
                    blurRadius: 25.r,
                    offset: Offset(_tiltOffset.dx * 10, 10.h + (_tiltOffset.dy * 10)),
                  ),
                  // Inner Definition
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.4),
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: widget.child,
              ),
            ),
          ),
        );
      },
    );
  }
}
