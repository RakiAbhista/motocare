import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/core/theme/app_theme.dart';
import '../../booking/screens/booking_servis_screen.dart';

class NotifikasiScreen extends StatelessWidget {
  const NotifikasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pusat Notifikasi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppTheme.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNotificationCard(
              icon: Icons.build_rounded,
              iconBg: AppColors.primaryLight,
              iconColor: AppColors.primary,
              title: 'Pengingat Servis',
              time: '2 Jam yang lalu',
              description:
                  'Halo John! Sepertinya sudah 2 bulan sejak servis terakhir. Yuk, Servis Honda Beatrix Anda agar tetap nyaman dikendarai.',
              actions: [
                OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notifikasi diabaikan')),
                    );
                  },
                  child: const Text('Abaikan'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BookingServisScreen()),
                  ),
                  child: const Text('Jadwalkan'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildNotificationCard(
              icon: Icons.local_offer_rounded,
              iconBg: Colors.green.shade100,
              iconColor: Colors.green,
              title: 'Penawaran Terbaik',
              time: '5 Jam yang lalu',
              description:
                  'Get 20% off on your next oil change with our partner workshops.',
            ),
            const SizedBox(height: 28),
            const Text('Kemarin',
                style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
            const SizedBox(height: 16),
            _buildNotificationCard(
              icon: Icons.check_circle_outline,
              iconBg: Colors.grey.shade200,
              iconColor: Colors.grey,
              title: 'Servis Selesai',
              time: 'Kemarin',
              description:
                  'Servis #id_servis telah berhasil diselesaikan. Sepeda Motor Anda siap untuk diambil.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String time,
    required String description,
    List<Widget>? actions,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title, style: AppTheme.titleMedium),
                        Text(time, style: AppTheme.labelSmall),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(description, style: AppTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          if (actions != null) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions,
            ),
          ],
        ],
      ),
    );
  }
}
