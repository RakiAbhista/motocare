import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/core/theme/app_theme.dart';
import 'package:motocare/widgets/custom_text_field.dart';

class TambahKendaraanScreen extends StatefulWidget {
  const TambahKendaraanScreen({super.key});

  @override
  State<TambahKendaraanScreen> createState() => _TambahKendaraanScreenState();
}

class _TambahKendaraanScreenState extends State<TambahKendaraanScreen> {
  bool isMotorSelected = true;

  final merkController = TextEditingController();
  final tipeController = TextEditingController();
  final platController = TextEditingController();
  final tahunController = TextEditingController();

  @override
  void dispose() {
    merkController.dispose();
    tipeController.dispose();
    platController.dispose();
    tahunController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Kendaraan'),
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
            const Text(
              'Isi Data Kendaraan',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Jenis Kendaraan *',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            _VehicleTypeSelector(
              isMotorSelected: isMotorSelected,
              onMotorTap: () => setState(() => isMotorSelected = true),
              onMobilTap: () => setState(() => isMotorSelected = false),
            ),
            const SizedBox(height: 28),
            CustomTextField(
              label: 'Merk Kendaraan',
              hint: 'Contoh : Yamaha',
              controller: merkController,
              isRequired: true,
            ),
            CustomTextField(
              label: 'Tipe Kendaraan',
              hint: 'Contoh : Aerox',
              controller: tipeController,
              isRequired: true,
            ),
            CustomTextField(
              label: 'Nomor Plat',
              hint: 'Contoh : X-1234-XXX',
              controller: platController,
              isRequired: true,
            ),
            CustomTextField(
              label: 'Tahun Keluaran',
              hint: 'Contoh : 2020',
              controller: tahunController,
              keyboardType: TextInputType.number,
              isRequired: true,
            ),
            const SizedBox(height: 8),
            _buildUploadSection(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement submit
                },
                child: const Text('Tambahkan Kendaraan'),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            text: 'Upload Foto STNK',
            style: TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          '(PDF, Maks. 1MB)',
          style: AppTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            // TODO: Implement file picker
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cloud_upload_outlined, color: AppColors.textSecondary, size: 20),
                SizedBox(width: 8),
                Text('Tambahkan File', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _VehicleTypeSelector extends StatelessWidget {
  final bool isMotorSelected;
  final VoidCallback onMotorTap;
  final VoidCallback onMobilTap;

  const _VehicleTypeSelector({
    required this.isMotorSelected,
    required this.onMotorTap,
    required this.onMobilTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onMotorTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isMotorSelected ? AppColors.primaryLight : Colors.transparent,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(
                color: isMotorSelected ? AppColors.primary : AppColors.border,
                width: isMotorSelected ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.motorcycle,
                  size: 40,
                  color: isMotorSelected ? AppColors.primary : Colors.grey,
                ),
                const SizedBox(height: 4),
                Text(
                  'Motor',
                  style: TextStyle(
                    color: isMotorSelected ? AppColors.primary : Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 32),
        GestureDetector(
          onTap: onMobilTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: !isMotorSelected ? AppColors.primaryLight : Colors.transparent,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(
                color: !isMotorSelected ? AppColors.primary : AppColors.border,
                width: !isMotorSelected ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.directions_car,
                  size: 40,
                  color: !isMotorSelected ? AppColors.primary : Colors.grey,
                ),
                const SizedBox(height: 4),
                Text(
                  'Mobil',
                  style: TextStyle(
                    color: !isMotorSelected ? AppColors.primary : Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
