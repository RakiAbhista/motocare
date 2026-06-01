import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/features/cs/widgets/stat_box.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("SERVICE OPERATIONS",
              style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 8),
          const Text(
            "Hello, Specialist",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              StatBox(title: "Active Queue", value: "14 Units"),
              const SizedBox(width: 10),
              StatBox(title: "Avg. Wait", value: "24 Mins"),
            ],
          )
        ],
      ),
    );
  }
}