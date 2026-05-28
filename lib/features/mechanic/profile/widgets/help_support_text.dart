import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';

class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Center(
        child: RichText(
          text: const TextSpan(
            text: 'Butuh Bantuan? ',
            style: TextStyle(color: Colors.grey, fontSize: 12),
            children: [
              TextSpan(
                text: 'Klik Disini!',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
