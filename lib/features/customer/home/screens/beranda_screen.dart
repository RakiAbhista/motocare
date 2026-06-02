import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/core/theme/app_theme.dart';
import 'package:motocare/core/theme/app_background.dart';
import 'package:motocare/widgets/custom_top_bar.dart';
import 'package:motocare/widgets/custom_card.dart';
import 'package:motocare/widgets/section_header.dart';
import 'package:motocare/widgets/status_badge.dart';
import 'package:motocare/widgets/dashed_divider.dart';
import '../widgets/promo_banner_carousel.dart';
import '../widgets/emergency_button_3d.dart';
import '../../emergency/screens/panggilan_darurat_screen.dart';
import 'notifikasi_screen.dart';
import '../../kendaraan/widgets/detail_motor_bottom_sheet.dart';
import '../../booking/screens/booking_servis_screen.dart';

class BerandaScreen extends StatelessWidget {
  final bool hasActiveBooking;
  final String? daruratType;
  const BerandaScreen({super.key, this.hasActiveBooking = false, this.daruratType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: EmergencyButton3D(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PanggilanDaruratScreen()),
        ),
      ),
      body: BengkelBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 20),
                Padding(
                  padding: AppTheme.pagePaddingH,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PromoBannerCarousel(),
                      const SizedBox(height: 20),
                      const DashedDivider(),
                      const SizedBox(height: 20),
                      _buildPointsVoucherCard(context),
                      const SizedBox(height: 20),
                      if (daruratType != null) ...[
                        _buildStatusDarurat(),
                        const SizedBox(height: 20),
                        const DashedDivider(),
                        const SizedBox(height: 20),
                      ],
                      _buildKendaraanCard(context),
                      const SizedBox(height: 20),
                      const DashedDivider(),
                      const SizedBox(height: 20),
                      _buildServiceSection(context),
                      const SizedBox(height: 20),
                      const DashedDivider(),
                      const SizedBox(height: 20),
                      _buildRecentServiceHistory(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return CustomTopBar(
      onNotificationTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NotifikasiScreen()),
      ),
    );
  }

  Widget _buildPointsVoucherCard(BuildContext context) {
    return CustomCard(
      accentColor: AppColors.primary,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  child: const Icon(Icons.stars_rounded, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Poin Saya', style: AppTheme.bodySmall),
                    SizedBox(height: 2),
                    Text('36 Poin', style: TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            width: 1,
            color: Colors.grey.shade200,
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur Voucher akan segera hadir!')),
              );
            },
            icon: const Icon(Icons.local_activity, size: 18),
            label: const Text('Voucher'),
          ),
        ],
      ),
    );
  }

  Widget _buildKendaraanCard(BuildContext context) {
    return CustomCard(
      accentColor: AppColors.primary,
      cutCorner: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kendaraan Anda',
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 100,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: const Icon(Icons.motorcycle, size: 50, color: AppColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Honda Beatrix', style: AppTheme.titleLarge),
                    const SizedBox(height: 4),
                    const Text('H 1945 AGS', style: AppTheme.bodySmall),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () => DetailMotorBottomSheet.show(context),
                      child: const Text('Detail'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDarurat() {
    final isMekanik = daruratType == 'mekanik';
    final title = isMekanik ? 'Bengkel 123' : 'Towing H 1234 HE';
    final step2Label = isMekanik ? 'Mekanik Menuju Lokasi' : 'Towing Menuju Lokasi';

    return CustomCard(
      accentColor: AppColors.danger,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.danger, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Status Panggilan Darurat',
                style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: AppTheme.titleMedium),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTrackerNode(true, 'Peninjauan\nPanggilan'),
              _buildTrackerLine(false),
              _buildTrackerNode(false, step2Label),
              _buildTrackerLine(false),
              _buildTrackerNode(false, 'Servis\nBerlangsung'),
              _buildTrackerLine(false),
              _buildTrackerNode(false, 'Menunggu\nPembayaran'),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: StatusBadge.danger('Menunggu konfirmasi mekanik...'),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceSection(BuildContext context) {
    return CustomCard(
      accentColor: AppColors.primary,
      cutCorner: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.build_rounded, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Status Servis',
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (!hasActiveBooking) ...[
            const Text('HONDA BEATRIX', style: AppTheme.titleMedium),
            const SizedBox(height: 2),
            const Text('H 1945 AGS', style: AppTheme.bodySmall),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BookingServisScreen()),
                ),
                icon: const Icon(Icons.build_rounded, size: 18),
                label: const Text('Booking Servis'),
              ),
            ),
          ] else ...[
            const Text('HONDA BEATRIX', style: AppTheme.titleMedium),
            const SizedBox(height: 2),
            const Text('H 1945 AGS', style: AppTheme.bodySmall),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTrackerNode(true, 'Sedang\nDitinjau'),
                _buildTrackerLine(false),
                _buildTrackerNode(false, 'Servis\nDimulai'),
                _buildTrackerLine(false),
                _buildTrackerNode(false, 'Menunggu\nPembayaran'),
                _buildTrackerLine(false),
                _buildTrackerNode(false, 'Servis\nSelesai'),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: StatusBadge.primary('Wait for review'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrackerNode(bool isActive, String label) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.primary : Colors.transparent,
            border: Border.all(
              color: isActive ? AppColors.primary : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: isActive
              ? const Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.check, color: Colors.white, size: 14),
                  ],
                )
              : null,
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 64,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Widget _buildTrackerLine(bool isActive) {
    return Container(
      width: 32,
      height: 2,
      decoration: BoxDecoration(
        gradient: isActive
            ? const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
              )
            : null,
        color: isActive ? null : Colors.grey.shade300,
      ),
      margin: const EdgeInsets.only(top: 11),
    );
  }

  Widget _buildRecentServiceHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Riwayat Servis',
          actionLabel: 'Lihat Semua',
        ),
        const SizedBox(height: 12),
        CustomCard(
          accentColor: AppColors.success,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: const Icon(Icons.check_circle, color: AppColors.success, size: 24),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ganti Oli & Tune Up', style: AppTheme.titleMedium),
                    SizedBox(height: 2),
                    Text('28 Apr 2026 • Bengkel MotoCare', style: AppTheme.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }
}
