import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/core/theme/app_theme.dart';
import 'package:motocare/core/theme/app_background.dart';
import 'package:motocare/widgets/custom_card.dart';
import 'package:motocare/widgets/status_badge.dart';
import 'package:motocare/widgets/dashed_divider.dart';
import '../widgets/service_detail_bottom_sheet.dart';
import '../../home/screens/notifikasi_screen.dart';
import '../../kendaraan/widgets/detail_motor_bottom_sheet.dart';

class RiwayatScreen extends StatelessWidget {
  const RiwayatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BengkelBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _RiwayatHeader(),
                const SizedBox(height: 24),
                Padding(
                  padding: AppTheme.pagePaddingH,
                  child: Column(
                    children: [
                      const _KendaraanInfoItem(),
                      const SizedBox(height: 16),
                      const DashedDivider(),
                      const SizedBox(height: 16),
                      const _StatusServiceItem(),
                      const SizedBox(height: 24),
                      const DashedDivider(),
                      const SizedBox(height: 24),
                      const _RiwayatListSection(),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RiwayatHeader extends StatelessWidget {
  const _RiwayatHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Riwayat Servis',
            style: AppTheme.headlineLarge,
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotifikasiScreen()),
            ),
            child: const Icon(
              Icons.notifications,
              color: Colors.white,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}

class _KendaraanInfoItem extends StatelessWidget {
  const _KendaraanInfoItem();

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      accentColor: AppColors.primary,
      cutCorner: true,
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: const Icon(Icons.motorcycle, size: 45, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Honda Beatrix', style: AppTheme.titleLarge),
                const SizedBox(height: 2),
                Text('H 1945 AGS',
                    style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () => DetailMotorBottomSheet.show(context),
                  child: Text('Detail', style: AppTheme.linkText),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}

class _StatusServiceItem extends StatelessWidget {
  const _StatusServiceItem();

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      accentColor: AppColors.warning,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: const Icon(Icons.history_rounded, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status Servis', style: AppTheme.bodySmall),
                SizedBox(height: 2),
                Text('Terakhir Servis', style: AppTheme.titleMedium),
                SizedBox(height: 2),
                Text('2 Bulan yang lalu',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
          StatusBadge.warning('Perlu Servis'),
        ],
      ),
    );
  }
}

class _RiwayatListSection extends StatelessWidget {
  const _RiwayatListSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Riwayat Servis', style: AppTheme.titleLarge),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur Filter akan segera hadir!')),
                );
              },
              child: const Text('Filter', style: AppTheme.linkText),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _RiwayatListCard(
          icon: Icons.build_rounded,
          title: 'Service Rutin',
          date: '12 Feb 2024',
          location: 'Ahas Cabang Semarang Barat',
          status: 'Selesai',
          onTap: () => ServiceDetailBottomSheet.show(context),
        ),
        const SizedBox(height: 12),
        _RiwayatListCard(
          icon: Icons.battery_charging_full_rounded,
          title: 'Ganti Aki',
          date: '12 Feb 2024',
          location: 'Ahas Cabang Semarang Barat',
          status: 'Selesai',
          onTap: () => ServiceDetailBottomSheet.show(context),
        ),
        const SizedBox(height: 12),
        _RiwayatListCard(
          icon: Icons.oil_barrel_rounded,
          title: 'Ganti Oli',
          date: '12 Feb 2024',
          location: 'Ahas Cabang Semarang Barat',
          status: 'Selesai',
          onTap: () => ServiceDetailBottomSheet.show(context),
        ),
      ],
    );
  }
}

class _RiwayatListCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String date;
  final String location;
  final String status;
  final VoidCallback? onTap;

  const _RiwayatListCard({
    required this.icon,
    required this.title,
    required this.date,
    required this.location,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: AppTheme.titleMedium),
                      Text(date, style: AppTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(location, style: AppTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(width: 8),
            StatusBadge.success(status),
          ],
        ),
      ),
    );
  }
}
