import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';

class StatsGrid extends StatelessWidget {
  const StatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildStatCard('QUEUE', '12', 'Vehicles waiting')),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'COMPLETED',
            '08',
            "Today's goal: 10",
            isCompleted: true,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    String sub, {
    bool isCompleted = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isCompleted ? AppColors.primary : AppColors.primary,
            ),
          ),
          Text(
            sub,
            style: const TextStyle(fontSize: 10, color: Color(0xFF1E293B)),
          ),
        ],
      ),
    );
  }
}
