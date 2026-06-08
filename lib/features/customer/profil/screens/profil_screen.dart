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
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotifikasiScreen()),
                  ),
                  child: const Icon(Icons.notifications, color: Colors.white, size: 22),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.person, size: 60, color: Colors.grey),
          ),
          const SizedBox(height: 14),
          const Text(
            'John Doe',
            style: AppTheme.headlineLarge,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'john.doe@email.com',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 13,
              ),
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.08),
            AppColors.primary.withValues(alpha: 0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildPointItem(Icons.stars_rounded, '36', 'Poin'),
            Container(height: 40, width: 1, color: AppColors.primary.withValues(alpha: 0.15)),
            _buildPointItem(Icons.local_activity_rounded, '2', 'Voucher'),
          ],
        ),
      ),
    );
  }

  Widget _buildPointItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 28),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.primary.withValues(alpha: 0.7),
            fontSize: 12,
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
        const Row(
          children: [
            Icon(Icons.motorcycle, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text('Kendaraan Anda', style: AppTheme.titleLarge),
          ],
        ),
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
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TambahKendaraanScreen()),
              ),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Tambah'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
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
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(plate, style: AppTheme.bodySmall.copyWith(color: AppColors.primary)),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.primary.withValues(alpha: 0.4)),
            ),
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
        ),
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
      ),
    );
  }
}
