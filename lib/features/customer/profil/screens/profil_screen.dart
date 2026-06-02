import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/core/theme/app_theme.dart';
import 'package:motocare/core/theme/app_background.dart';
import 'package:motocare/features/customer/home/screens/notifikasi_screen.dart';
import 'package:motocare/features/customer/kendaraan/screens/tambah_kendaraan_screen.dart';
import 'package:motocare/features/customer/kendaraan/widgets/detail_motor_bottom_sheet.dart';
import 'package:motocare/widgets/custom_card.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BengkelBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const _ProfileHeader(),
                const SizedBox(height: 28),
                Padding(
                  padding: AppTheme.pagePaddingH,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _PointsCard(),
                      const SizedBox(height: 28),
                      const _VehicleSection(),
                      const SizedBox(height: 24),
                      const _HelpAndSupport(),
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

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
          const SizedBox(height: 8),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.person, size: 60, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          const Text(
            'John Doe',
            style: AppTheme.headlineLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'john.doe@email.com',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _PointsCard extends StatelessWidget {
  const _PointsCard();

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      accentColor: AppColors.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPointItem(Icons.stars_rounded, '36 Poin'),
          Container(height: 30, width: 1, color: AppColors.divider),
          _buildPointItem(Icons.local_activity_rounded, '2 Voucher'),
        ],
      ),
    );
  }

  Widget _buildPointItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 28),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class _VehicleSection extends StatelessWidget {
  const _VehicleSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Kendaraan Anda', style: AppTheme.titleLarge),
        const SizedBox(height: 16),
        _VehicleListItem(
          name: 'Honad Betarix',
          plate: 'H1945 AGS',
          onTap: () => DetailMotorBottomSheet.show(context),
        ),
        const SizedBox(height: 12),
        _VehicleListItem(
          name: 'Honad Betarix',
          plate: 'H1945 AGS',
          onTap: () => DetailMotorBottomSheet.show(context),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Punya kendaraan lain?', style: AppTheme.titleMedium),
            OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TambahKendaraanScreen()),
              ),
              child: const Text('Tambah'),
            ),
          ],
        ),
      ],
    );
  }
}

class _VehicleListItem extends StatelessWidget {
  final String name;
  final String plate;
  final VoidCallback? onTap;

  const _VehicleListItem({
    required this.name,
    required this.plate,
    this.onTap,
  });

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
                Text(name, style: AppTheme.titleLarge),
                const SizedBox(height: 2),
                Text(plate, style: AppTheme.bodySmall),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: onTap,
            child: const Text('Detail'),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

class _HelpAndSupport extends StatelessWidget {
  const _HelpAndSupport();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: const TextSpan(
          text: 'Butuh Bantuan? ',
          style: AppTheme.bodySmall,
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
    );
  }
}
