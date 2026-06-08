import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.height,
  });

  factory CustomButton.primary({
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    double? width,
    IconData? icon,
  }) {
    return CustomButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      width: width,
      icon: icon,
      backgroundColor: AppColors.primary,
      textColor: Colors.white,
    );
  }

  factory CustomButton.danger({
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    double? width,
    IconData? icon,
  }) {
    return CustomButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      width: width,
      icon: icon,
      backgroundColor: AppColors.dangerDark,
      textColor: Colors.white,
    );
  }

  factory CustomButton.outline({
    required String label,
    VoidCallback? onPressed,
    double? width,
    IconData? icon,
  }) {
    return CustomButton(
      label: label,
      onPressed: onPressed,
      width: width,
      icon: icon,
      backgroundColor: Colors.transparent,
      textColor: AppColors.primary,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed =
        (isDisabled || isLoading) ? null : onPressed;

    if (backgroundColor == Colors.transparent) {
      return SizedBox(
        width: width ?? double.infinity,
        height: height ?? 48,
        child: OutlinedButton(
          onPressed: effectiveOnPressed,
          child: _buildChild(),
        ),
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 48,
      child: ElevatedButton(
        onPressed: effectiveOnPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: textColor ?? Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
          disabledForegroundColor: Colors.grey.shade500,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _buildChild(),
      ),
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label),
        ],
      );
    }

    return Text(label);
  }
}
