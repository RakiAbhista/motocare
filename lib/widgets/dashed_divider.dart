import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';

class DashedDivider extends StatelessWidget {
  final Color? color;
  final double height;
  const DashedDivider({super.key, this.color, this.height = 1});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashWidth = 6.0;
        final gapWidth = 4.0;
        final totalWidth = constraints.constrainWidth();
        final dashCount = (totalWidth / (dashWidth + gapWidth)).floor();

        return Row(
          children: List.generate(dashCount, (i) {
            return Container(
              width: dashWidth,
              height: height,
              color: color ?? AppColors.border.withValues(alpha: 0.5),
            );
          }).followedBy([
            if (dashCount * (dashWidth + gapWidth) < totalWidth)
              Container(
                width: totalWidth - dashCount * (dashWidth + gapWidth),
                height: height,
                color: color ?? AppColors.border.withValues(alpha: 0.5),
              ),
          ]).toList(),
        );
      },
    );
  }
}
