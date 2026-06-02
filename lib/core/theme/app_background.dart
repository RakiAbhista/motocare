import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'app_colors.dart';

class BengkelBackground extends StatelessWidget {
  final Widget child;
  const BengkelBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          painter: _BengkelPainter(),
          child: const SizedBox.expand(),
        ),
        child,
      ],
    );
  }
}

class _BengkelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final speedPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.025)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 14; i++) {
      final y = (size.height / 14) * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width * 0.6, y + 40),
        speedPaint,
      );
    }

    for (int i = 0; i < 10; i++) {
      final x = (size.width / 10) * i;
      canvas.drawLine(
        Offset(x, size.height * 0.7),
        Offset(x + 60, size.height),
        speedPaint,
      );
    }

    final gridPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.015)
      ..strokeWidth = 0.5;

    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final gearPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.018)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final center = Offset(size.width - 70, size.height - 70);
    const r = 50.0;
    const teeth = 8;

    canvas.drawCircle(center, r, gearPaint);
    canvas.drawCircle(center, r * 0.55, gearPaint);

    final linePaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.018)
      ..strokeWidth = 2.5;

    for (int i = 0; i < teeth; i++) {
      final angle = (2 * math.pi / teeth) * i - math.pi / teeth;
      final a = Offset(
        center.dx + r * 0.82 * math.cos(angle),
        center.dy + r * 0.82 * math.sin(angle),
      );
      final b = Offset(
        center.dx + r * 1.18 * math.cos(angle),
        center.dy + r * 1.18 * math.sin(angle),
      );
      canvas.drawLine(a, b, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
