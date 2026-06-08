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
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFF5F5F0),
                const Color(0xFFF0EFEA),
                AppColors.primary.withValues(alpha: 0.04),
                AppColors.primary.withValues(alpha: 0.07),
              ],
            ),
          ),
        ),
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
    _drawFloorGradient(canvas, size);
    _drawGrid(canvas, size);
    _drawSpeedLines(canvas, size);
    _drawGears(canvas, size);
    _drawTireTracks(canvas, size);
    _drawTools(canvas, size);
    _drawOilStains(canvas, size);
    _drawBlueprintCircles(canvas, size);
  }

  void _drawFloorGradient(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, size.height * 0.72, size.width, size.height * 0.28);
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Colors.black.withValues(alpha: 0.04),
          Colors.black.withValues(alpha: 0.06),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.035)
      ..strokeWidth = 0.5;

    for (double x = 0; x < size.width; x += 36) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 36) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final boldPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.025)
      ..strokeWidth = 1.0;

    for (double x = 0; x < size.width; x += 144) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), boldPaint);
    }
    for (double y = 0; y < size.height; y += 144) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), boldPaint);
    }
  }

  void _drawSpeedLines(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.secondary.withValues(alpha: 0.04)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 12; i++) {
      final y = (size.height / 12) * i + 10;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width * 0.4, y + 20),
        paint,
      );
    }

    final paint2 = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.035)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 8; i++) {
      final x = (size.width / 8) * i + 20;
      canvas.drawLine(
        Offset(x, size.height * 0.7),
        Offset(x + 35, size.height),
        paint2,
      );
    }
  }

  void _drawGears(Canvas canvas, Size size) {
    _drawSingleGear(
      canvas,
      Offset(size.width - 90, size.height - 90),
      60, 8,
      AppColors.primary.withValues(alpha: 0.06),
    );
    _drawSingleGear(
      canvas,
      Offset(50, size.height * 0.28),
      40, 6,
      AppColors.secondary.withValues(alpha: 0.05),
    );
    _drawSingleGear(
      canvas,
      Offset(size.width * 0.45, 25),
      28, 5,
      AppColors.primary.withValues(alpha: 0.04),
    );
    _drawSingleGear(
      canvas,
      Offset(size.width * 0.78, size.height * 0.5),
      22, 5,
      AppColors.secondary.withValues(alpha: 0.04),
    );
    _drawSingleGear(
      canvas,
      Offset(size.width * 0.88, size.height * 0.3),
      16, 4,
      AppColors.primary.withValues(alpha: 0.05),
    );
  }

  void _drawSingleGear(
    Canvas canvas, Offset center, double r, int teeth, Color color) {
    final gearPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawCircle(center, r, gearPaint);
    canvas.drawCircle(center, r * 0.45, gearPaint);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5;

    for (int i = 0; i < teeth; i++) {
      final angle = (2 * math.pi / teeth) * i - math.pi / teeth;
      final a = Offset(
        center.dx + r * 0.78 * math.cos(angle),
        center.dy + r * 0.78 * math.sin(angle),
      );
      final b = Offset(
        center.dx + r * 1.22 * math.cos(angle),
        center.dy + r * 1.22 * math.sin(angle),
      );
      canvas.drawLine(a, b, linePaint);
    }

    final spokePaint = Paint()
      ..color = color
      ..strokeWidth = 1.2;

    for (int i = 0; i < teeth; i++) {
      final angle = (2 * math.pi / teeth) * i;
      final inner = Offset(
        center.dx + r * 0.45 * math.cos(angle),
        center.dy + r * 0.45 * math.sin(angle),
      );
      final outer = Offset(
        center.dx + r * 0.82 * math.cos(angle),
        center.dy + r * 0.82 * math.sin(angle),
      );
      canvas.drawLine(inner, outer, spokePaint);
    }

    final dotPaint = Paint()..color = color;
    canvas.drawCircle(center, 3, dotPaint);
  }

  void _drawTireTracks(Canvas canvas, Size size) {
    final trackPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.035)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final cx = size.width * 0.2;
    final cy = size.height * 0.65;
    final baseR = 35.0;

    for (int ring = 0; ring < 3; ring++) {
      final rr = baseR + ring * 14;
      canvas.drawCircle(Offset(cx, cy), rr, trackPaint);

      final count = 8 + ring * 2;
      for (int i = 0; i < count; i++) {
        final angle = (2 * math.pi / count) * i;
        final x1 = cx + rr * 0.82 * math.cos(angle);
        final y1 = cy + rr * 0.82 * math.sin(angle);
        final x2 = cx + rr * 1.0 * math.cos(angle);
        final y2 = cy + rr * 1.0 * math.sin(angle);
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), trackPaint);
      }
    }

    final trackPaint2 = Paint()
      ..color = AppColors.secondary.withValues(alpha: 0.025)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final cx2 = size.width * 0.32;
    final cy2 = size.height * 0.62;
    final baseR2 = 25.0;

    for (int ring = 0; ring < 2; ring++) {
      final rr = baseR2 + ring * 12;
      canvas.drawCircle(Offset(cx2, cy2), rr, trackPaint2);

      final count = 6 + ring * 2;
      for (int i = 0; i < count; i++) {
        final angle = (2 * math.pi / count) * i;
        final x1 = cx2 + rr * 0.8 * math.cos(angle);
        final y1 = cy2 + rr * 0.8 * math.sin(angle);
        final x2 = cx2 + rr * 1.0 * math.cos(angle);
        final y2 = cy2 + rr * 1.0 * math.sin(angle);
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), trackPaint2);
      }
    }
  }

  void _drawTools(Canvas canvas, Size size) {
    final toolPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.035)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final wc = Offset(size.width * 0.88, size.height * 0.18);
    final wr = 24.0;

    canvas.drawCircle(wc, wr, toolPaint);
    canvas.drawCircle(wc, wr * 0.35, toolPaint);

    for (int i = 0; i < 6; i++) {
      final angle = (2 * math.pi / 6) * i;
      final x1 = wc.dx + wr * 0.45 * math.cos(angle);
      final y1 = wc.dy + wr * 0.45 * math.sin(angle);
      final x2 = wc.dx + wr * 0.88 * math.cos(angle);
      final y2 = wc.dy + wr * 0.88 * math.sin(angle);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), toolPaint);
    }

    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: Offset(size.width * 0.1, size.height * 0.12),
          width: 36,
          height: 10),
      const Radius.circular(4),
    );
    canvas.drawRRect(rect, toolPaint);

    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.12 - 5),
      Offset(size.width * 0.1, size.height * 0.12 - 18),
      toolPaint,
    );

    final wrenchPaint = Paint()
      ..color = AppColors.secondary.withValues(alpha: 0.03)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final handlePath = Path()
      ..moveTo(size.width * 0.7, size.height * 0.75)
      ..lineTo(size.width * 0.76, size.height * 0.82);
    canvas.drawPath(handlePath, wrenchPaint);

    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.75),
      8,
      wrenchPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.76, size.height * 0.82),
      6,
      wrenchPaint,
    );

    final screwPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.03)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final screwCenter = Offset(size.width * 0.04, size.height * 0.08);
    canvas.drawLine(
      Offset(screwCenter.dx - 14, screwCenter.dy),
      Offset(screwCenter.dx + 14, screwCenter.dy),
      screwPaint,
    );
    canvas.drawLine(
      Offset(screwCenter.dx, screwCenter.dy - 14),
      Offset(screwCenter.dx, screwCenter.dy + 14),
      screwPaint,
    );
    canvas.drawCircle(screwCenter, 4, screwPaint..style = PaintingStyle.fill);
    screwPaint.style = PaintingStyle.stroke;

    final hammerPaint = Paint()
      ..color = AppColors.secondary.withValues(alpha: 0.025)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final hammerX = size.width * 0.92;
    final hammerY = size.height * 0.92;

    canvas.drawLine(
      Offset(hammerX, hammerY),
      Offset(hammerX - 32, hammerY - 40),
      hammerPaint..strokeWidth = 3.0,
    );
    hammerPaint.strokeWidth = 2.0;

    canvas.drawRect(
      Rect.fromCenter(center: Offset(hammerX, hammerY), width: 20, height: 14),
      hammerPaint,
    );
  }

  void _drawOilStains(Canvas canvas, Size size) {
    final oilPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.015)
      ..style = PaintingStyle.fill;

    final stains = [
      Offset(size.width * 0.35, size.height * 0.92),
      Offset(size.width * 0.65, size.height * 0.88),
      Offset(size.width * 0.15, size.height * 0.94),
      Offset(size.width * 0.82, size.height * 0.9),
    ];

    for (final center in stains) {
      final path = Path();
      final points = 8;
      final baseR = 12.0 + (center.dx % 8);
      for (int i = 0; i < points; i++) {
        final angle = (2 * math.pi / points) * i;
        final r = baseR * (0.7 + 0.3 * math.sin(angle * 2.3 + center.dx));
        final x = center.dx + r * math.cos(angle);
        final y = center.dy + r * math.sin(angle);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, oilPaint);
    }

    final dripPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.01)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 4; i++) {
      final x = size.width * (0.1 + 0.25 * i);
      final y = size.height * (0.78 + 0.02 * i);
      final dripPath = Path()
        ..moveTo(x, y)
        ..quadraticBezierTo(x + 4, y + 6, x + 2, y + 12)
        ..quadraticBezierTo(x, y + 10, x - 2, y + 12)
        ..quadraticBezierTo(x - 4, y + 6, x, y);
      canvas.drawPath(dripPath, dripPaint);
    }
  }

  void _drawBlueprintCircles(Canvas canvas, Size size) {
    final bluePaint = Paint()
      ..color = AppColors.secondary.withValues(alpha: 0.025)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final center1 = Offset(size.width * 0.55, size.height * 0.78);
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(center1, 20 + i * 12, bluePaint);
    }

    final crossPaint = Paint()
      ..color = AppColors.secondary.withValues(alpha: 0.02)
      ..strokeWidth = 0.8;
    canvas.drawLine(
      Offset(center1.dx - 50, center1.dy),
      Offset(center1.dx + 50, center1.dy),
      crossPaint,
    );
    canvas.drawLine(
      Offset(center1.dx, center1.dy - 50),
      Offset(center1.dx, center1.dy + 50),
      crossPaint,
    );

    final center2 = Offset(size.width * 0.08, size.height * 0.56);
    for (int i = 0; i < 2; i++) {
      canvas.drawCircle(center2, 14 + i * 10, bluePaint);
    }
    canvas.drawLine(
      Offset(center2.dx - 30, center2.dy),
      Offset(center2.dx + 30, center2.dy),
      crossPaint,
    );
    canvas.drawLine(
      Offset(center2.dx, center2.dy - 30),
      Offset(center2.dx, center2.dy + 30),
      crossPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
