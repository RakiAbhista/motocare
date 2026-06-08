import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/core/theme/app_theme.dart';
import 'package:motocare/core/theme/app_background.dart';
import 'package:motocare/widgets/main_wrapper.dart';
import 'package:motocare/widgets/custom_text_field.dart';
import 'package:motocare/widgets/custom_card.dart';

class PanggilanDaruratScreen extends StatefulWidget {
  const PanggilanDaruratScreen({super.key});

  @override
  State<PanggilanDaruratScreen> createState() => _PanggilanDaruratScreenState();
}

class _PanggilanDaruratScreenState extends State<PanggilanDaruratScreen> {
  bool isUploaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panggilan Darurat'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BengkelBackground(
        child: SingleChildScrollView(
          padding: AppTheme.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.danger.withValues(alpha: 0.08),
                      AppColors.danger.withValues(alpha: 0.02),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  border: Border.all(color: AppColors.danger.withValues(alpha: 0.15)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.danger.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      ),
                      child: const Icon(Icons.warning_amber_rounded, color: AppColors.danger, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Isi data dengan benar agar kami dapat membantu Anda',
                        style: TextStyle(color: AppColors.danger, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildLocationSection(),
              const SizedBox(height: 24),
              _buildNearbyWorkshop(),
              const SizedBox(height: 28),
              const Row(
                children: [
                  Icon(Icons.motorcycle, color: AppColors.danger, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Detail Kendaraan',
                    style: TextStyle(
                      color: AppColors.danger,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Merk Kendaraan',
                hint: 'Masukkan merk kendaraan',
                isRequired: true,
              ),
              CustomTextField(
                label: 'Tipe Kendaraan',
                hint: 'Masukkan tipe kendaraan',
                isRequired: true,
              ),
              CustomTextField(
                label: 'Nomor Plat',
                hint: 'Masukkan nomor plat',
                isRequired: true,
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Icon(Icons.camera_alt_outlined, color: AppColors.textBody, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Foto Kerusakan Fisik',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Pastikan gambar terlihat jelas.',
                style: AppTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              _buildPhotoUpload(),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const MainWrapper(daruratType: 'mekanik')),
                    (route) => false,
                  ),
                  icon: const Icon(Icons.build_rounded, size: 18),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dangerDark,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                  ),
                  label: const Text('Panggil Mekanik'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const MainWrapper(daruratType: 'towing')),
                    (route) => false,
                  ),
                  icon: const Icon(Icons.local_shipping, color: AppColors.dangerDark),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.dangerDark),
                    foregroundColor: AppColors.dangerDark,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  label: const Text(
                    'Panggil Towing',
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return CustomCard(
      accentColor: AppColors.danger,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: const Icon(Icons.location_on, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Jl. Banjarsari No. 212, Tembalang, Semarang',
              style: AppTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyWorkshop() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.15)),
        color: AppColors.secondary.withValues(alpha: 0.04),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: const Icon(Icons.build_rounded, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('BENGKEL 123', style: AppTheme.titleMedium),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.star, size: 14, color: Color(0xFFF59E0B)),
                      SizedBox(width: 4),
                      Text('4.8 (120 Penilaian)', style: AppTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('50m',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoUpload() {
    return Row(
      children: [
        if (isUploaded)
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(Icons.image, color: Colors.grey, size: 40),
              ),
              Positioned(
                top: -8,
                right: 4,
                child: GestureDetector(
                  onTap: () => setState(() => isUploaded = false),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.cancel, color: AppColors.danger, size: 22),
                  ),
                ),
              ),
            ],
          ),
        GestureDetector(
          onTap: () => setState(() => isUploaded = true),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              border: Border.all(color: AppColors.border, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_upload_outlined, color: Colors.grey.shade400, size: 32),
                const SizedBox(height: 4),
                const Text('Tambah', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
