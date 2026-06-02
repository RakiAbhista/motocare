import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';

class EmergencyButton3D extends StatefulWidget {
  final VoidCallback? onPressed;
  const EmergencyButton3D({super.key, this.onPressed});

  @override
  State<EmergencyButton3D> createState() => _EmergencyButton3DState();
}

class _EmergencyButton3DState extends State<EmergencyButton3D>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnim;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.93, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _glowAnim = Tween<double>(begin: 0.25, end: 0.6).animate(
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
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnim.value,
          child: GestureDetector(
            onTap: widget.onPressed,
            child: Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.danger.withValues(alpha: _glowAnim.value * 0.5),
                    blurRadius: 22,
                    spreadRadius: 5,
                  ),
                  BoxShadow(
                    color: AppColors.dangerDark.withValues(alpha: 0.45),
                    blurRadius: 8,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: CustomPaint(
                painter: _DotRingPainter(),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFEF4444), Color(0xFFB91C1C)],
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        center: Alignment.topLeft,
                        radius: 0.8,
                        colors: [
                          Colors.white.withValues(alpha: 0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Transform.rotate(
                        angle: -0.1,
                        child: const Text(
                          'SOS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.5,
                            shadows: [
                              Shadow(
                                color: Colors.black45,
                                blurRadius: 6,
                                offset: Offset(1, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DotRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    for (int i = 0; i < 20; i++) {
      final angle = (2 * math.pi / 20) * i;
      final x = center.dx + radius * 0.88 * math.cos(angle);
      final y = center.dy + radius * 0.88 * math.sin(angle);
      canvas.drawCircle(Offset(x, y), 1.8, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
