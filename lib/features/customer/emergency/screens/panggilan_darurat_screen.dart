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
              _buildLocationSection(),
              const SizedBox(height: 24),
              _buildNearbyWorkshop(),
              const SizedBox(height: 28),
              const Text(
                'Detail Kendaraan',
                style: TextStyle(
                  color: AppColors.danger,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
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
              const Text(
                'Foto Kerusakan Fisik',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Pastikan gambar terlihat jelas.',
                style: AppTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              _buildPhotoUpload(),
              const SizedBox(height: 40),
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
                  ),
                  label: const Text('Panggil Mekanik'),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton.icon(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const MainWrapper(daruratType: 'towing')),
                    (route) => false,
                  ),
                  icon: const Icon(Icons.local_shipping, color: AppColors.dangerDark),
                  label: const Text(
                    'Panggil Towing',
                    style: TextStyle(color: AppColors.dangerDark),
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
    return CustomCard(
      accentColor: AppColors.secondary,
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
                Text('4.8 (120 Penilaian)', style: AppTheme.bodySmall),
              ],
            ),
          ),
          const Text('50m',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.primary,
              )),
        ],
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
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              border: Border.all(color: AppColors.border, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.cloud_upload_outlined, color: Colors.grey, size: 32),
                SizedBox(height: 4),
                Text('Tambah', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
