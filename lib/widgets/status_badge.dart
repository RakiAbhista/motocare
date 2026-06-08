import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? textColor;

  const StatusBadge({
    super.key,
    required this.label,
    this.color,
    this.textColor,
  });

  factory StatusBadge.success(String label) {
    return StatusBadge(
      label: label,
      color: AppColors.success.withValues(alpha: 0.1),
      textColor: AppColors.success,
    );
  }

  factory StatusBadge.warning(String label) {
    return StatusBadge(
      label: label,
      color: AppColors.warning.withValues(alpha: 0.1),
      textColor: AppColors.warning,
    );
  }

  factory StatusBadge.danger(String label) {
    return StatusBadge(
      label: label,
      color: AppColors.danger.withValues(alpha: 0.1),
      textColor: AppColors.danger,
    );
  }

  factory StatusBadge.primary(String label) {
    return StatusBadge(
      label: label,
      color: AppColors.primaryLight,
      textColor: AppColors.primary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color ?? AppColors.primaryLight,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor ?? AppColors.primary,
        ),
      ),
    );
  }
}
