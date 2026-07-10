import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/core/theme/app_theme.dart';
import 'package:motocare/core/services/riwayat_service.dart';
import 'package:motocare/widgets/custom_text_field.dart';

class TambahKendaraanScreen extends StatefulWidget {
  const TambahKendaraanScreen({super.key});

  @override
  State<TambahKendaraanScreen> createState() => _TambahKendaraanScreenState();
}

class _TambahKendaraanScreenState extends State<TambahKendaraanScreen> {
  bool isMotorSelected = true;
  File? _selectedFile;
  bool _isSubmitting = false;

  final merkController = TextEditingController();
  final tipeController = TextEditingController();
  final platController = TextEditingController();
  final tahunController = TextEditingController();

  final RiwayatService _riwayatService = RiwayatService();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    merkController.dispose();
    tipeController.dispose();
    platController.dispose();
    tahunController.dispose();
    super.dispose();
  }

  void _showPickOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pilih Sumber Foto',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                title: const Text('Ambil dari Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.primary),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final fileSize = await file.length();

        // Validasi ukuran file (maks 1MB)
        if (fileSize > 1 * 1024 * 1024) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ukuran file terlalu besar. Maksimal 1MB.'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        setState(() {
          _selectedFile = file;
        });
      }
    } catch (e) {
      print('❌ [TambahKendaraan] Error picking file: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memilih file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _submitVehicle() async {
    // Validasi form
    if (merkController.text.trim().isEmpty ||
        tipeController.text.trim().isEmpty ||
        platController.text.trim().isEmpty ||
        tahunController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field wajib diisi.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan upload foto STNK terlebih dahulu.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final result = await _riwayatService.addVehicle(
        vehicleType: isMotorSelected ? 'motor' : 'mobil',
        brand: merkController.text.trim(),
        model: tipeController.text.trim(),
        plateNumber: platController.text.trim(),
        manufacturingYear: tahunController.text.trim(),
        registrationDoc: _selectedFile!,
      );

      if (mounted) {
        if (result['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Kendaraan berhasil ditambahkan!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); // Return true to indicate success
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Gagal menambahkan kendaraan.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.12),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                  SizedBox(width: 10),
                  Text(
                    'Isi Data Kendaraan',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
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
                onPressed: _isSubmitting ? null : _submitVehicle,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Tambahkan Kendaraan'),
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
        const Text('(Jpg/Png, Maks. 1MB)', style: AppTheme.bodySmall),
        const SizedBox(height: 8),
        InkWell(
          onTap: _showPickOptions,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              color: AppColors.primary.withValues(alpha: 0.04),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Tambahkan File',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_upward, color: AppColors.primary, size: 16),
              ],
            ),
          ),
        ),
        if (_selectedFile != null) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedFile!.path.split('/').last.split('\\').last,
                    style: const TextStyle(fontSize: 13, color: Colors.green),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _selectedFile = null),
                  child: const Icon(Icons.close, color: Colors.red, size: 18),
                ),
              ],
            ),
          ),
        ],
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
              color: isMotorSelected
                  ? AppColors.primaryLight
                  : Colors.transparent,
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
              color: !isMotorSelected
                  ? AppColors.primaryLight
                  : Colors.transparent,
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
