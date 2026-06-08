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
            _buildDateLabel('Hari Ini'),
            const SizedBox(height: 12),
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
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: const Text('Abaikan', style: TextStyle(fontSize: 12)),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BookingServisScreen()),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Jadwalkan', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildNotificationCard(
              icon: Icons.local_offer_rounded,
              iconBg: Colors.green.shade50,
              iconColor: Colors.green,
              title: 'Penawaran Terbaik',
              time: '5 Jam yang lalu',
              description:
                  'Get 20% off on your next oil change with our partner workshops.',
            ),
            const SizedBox(height: 24),
            _buildDateLabel('Kemarin'),
            const SizedBox(height: 12),
            _buildNotificationCard(
              icon: Icons.check_circle_outline,
              iconBg: Colors.grey.shade100,
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

  Widget _buildDateLabel(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 13,
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
        border: Border.all(color: Colors.grey.shade100),
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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(time, style: AppTheme.labelSmall),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
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
