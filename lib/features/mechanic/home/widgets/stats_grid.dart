import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';

class StatsGrid extends StatelessWidget {
  final Map<String, dynamic>? stats;

  const StatsGrid({
    super.key,
    this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final pending = (stats?['total_pending'] ?? 0).toString();
    final completed = (stats?['total_completed'] ?? 0).toString();

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'QUEUE',
            pending.padLeft(2, '0'),
            'Vehicles waiting',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'COMPLETED',
            completed.padLeft(2, '0'),
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
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64748B),
              fontFamily: 'Mulish',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontFamily: 'Mulish',
            ),
          ),
          Text(
            sub,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF64748B),
              fontFamily: 'Mulish',
            ),
          ),
        ],
      ),
    );
  }
}
