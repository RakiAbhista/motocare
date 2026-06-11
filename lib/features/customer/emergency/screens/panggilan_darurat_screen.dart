import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/core/theme/app_theme.dart';
import 'package:motocare/core/theme/app_background.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:motocare/widgets/main_wrapper.dart';
import 'package:motocare/widgets/custom_text_field.dart';
import 'package:motocare/widgets/custom_card.dart';
import 'package:motocare/core/services/emergency_service.dart';
import 'package:motocare/features/customer/booking/models/booking_models.dart';
import 'package:motocare/features/customer/booking/widgets/pilih_kendaraan_bottom_sheet.dart';

class PanggilanDaruratScreen extends StatefulWidget {
  const PanggilanDaruratScreen({super.key});

  @override
  State<PanggilanDaruratScreen> createState() => _PanggilanDaruratScreenState();
}

class _PanggilanDaruratScreenState extends State<PanggilanDaruratScreen> {
  bool isUploaded = false;
  File? _damagePhoto;
  final TextEditingController _keluhanController = TextEditingController();
  final TextEditingController _merkController = TextEditingController();
  final TextEditingController _tipeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _platController = TextEditingController();
  final _service = EmergencyService();
  bool _isSubmitting = false;
  Vehicle? _selectedVehicle;
  Map<String, dynamic>? _nearestWorkshop;
  bool _loadingNearest = true;
  Position? _currentPosition;

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
              // Vehicle selector: choose existing vehicle or fill manually
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final vehicle = await PilihKendaraanBottomSheet.show(context);
                        if (vehicle != null && mounted) {
                          setState(() => _selectedVehicle = vehicle);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.motorcycle, color: AppColors.primary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _selectedVehicle != null
                                    ? '${_selectedVehicle!.brand} ${_selectedVehicle!.model} • ${_selectedVehicle!.plateNumber}'
                                    : 'Pilih kendaraan yang terdaftar',
                                style: AppTheme.bodyMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_drop_up),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_selectedVehicle != null)
                    IconButton(
                      onPressed: () => setState(() => _selectedVehicle = null),
                      icon: const Icon(Icons.close, color: Colors.red),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // If no vehicle selected, show manual input fields
              if (_selectedVehicle == null) ...[
                CustomTextField(
                  label: 'Merk Kendaraan',
                  hint: 'Masukkan merk kendaraan',
                  controller: _merkController,
                  isRequired: true,
                ),
                CustomTextField(
                  label: 'Tipe Kendaraan',
                  hint: 'Masukkan tipe kendaraan',
                  controller: _tipeController,
                  isRequired: true,
                ),
                CustomTextField(
                  label: 'Tahun / Model',
                  hint: 'Masukkan tahun atau model kendaraan',
                  controller: _modelController,
                  isRequired: false,
                ),
                CustomTextField(
                  label: 'Nomor Plat',
                  hint: 'Masukkan nomor plat',
                  controller: _platController,
                  isRequired: true,
                ),
              ],
              CustomTextField(
                label: 'Keluhan / Complaint',
                hint: 'Jelaskan keluhan atau kerusakan',
                controller: _keluhanController,
                isRequired: true,
                maxLines: 3,
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
                  onPressed: _isSubmitting ? null : () => _submitEmergency('mechanic'),
                  icon: _isSubmitting ? const SizedBox(width:18,height:18,child:CircularProgressIndicator(strokeWidth:2, color:Colors.white)) : const Icon(Icons.build_rounded, size: 18),
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
                  onPressed: _isSubmitting ? null : () => _submitEmergency('towing'),
                  icon: _isSubmitting ? const SizedBox(width:18,height:18,child:CircularProgressIndicator(strokeWidth:2)) : const Icon(Icons.local_shipping, color: AppColors.dangerDark),
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

  @override
  void initState() {
    super.initState();
    _initNearestWorkshop();
  }

  Future<void> _initNearestWorkshop() async {
    setState(() { _loadingNearest = true; });
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() { _loadingNearest = false; });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() { _loadingNearest = false; });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() { _loadingNearest = false; });
        return;
      }

      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final nearest = await _service.getNearestWorkshop(latitude: pos.latitude, longitude: pos.longitude);
      if (mounted) setState(() {
        _currentPosition = pos;
        _nearestWorkshop = nearest;
        _loadingNearest = false;
      });
    } catch (e) {
      if (mounted) setState(() { _loadingNearest = false; });
      print('Init nearest error: $e');
    }
  }

  @override
  void dispose() {
    _keluhanController.dispose();
    _merkController.dispose();
    _tipeController.dispose();
    _modelController.dispose();
    _platController.dispose();
    super.dispose();
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
          Expanded(
            child: Text(
              _currentPosition != null
                  ? 'Lokasi: ${_currentPosition!.latitude.toStringAsFixed(6)}, ${_currentPosition!.longitude.toStringAsFixed(6)}'
                  : 'Menunggu lokasi perangkat...',
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
        child: _loadingNearest
            ? Row(
                children: [
                  const SizedBox(width: 12),
                  const Expanded(child: Center(child: CircularProgressIndicator())),
                ],
              )
            : (_nearestWorkshop != null)
                ? Row(
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_nearestWorkshop!['name'] ?? '-', style: AppTheme.titleMedium),
                            const SizedBox(height: 4),
                            Text('${(_nearestWorkshop!['distance_meters'] ?? 0).toString()} m', style: AppTheme.bodySmall),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('${(_nearestWorkshop!['distance_meters'] ?? 0).toString()} m',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.white,
                            )),
                      ),
                    ],
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text('Tidak ada bengkel yang tersedia saat ini.', style: AppTheme.bodySmall),
                    ),
                  ),
      ),
    );
  }

  Widget _buildPhotoUpload() {
    return Row(
      children: [
        if (_damagePhoto != null)
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  child: Image.file(_damagePhoto!, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: -8,
                right: 4,
                child: GestureDetector(
                  onTap: () => setState(() { _damagePhoto = null; isUploaded = false; }),
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
          onTap: _pickImage,
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 2048, maxHeight: 2048, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _damagePhoto = File(picked.path);
        isUploaded = true;
      });
    }
  }

  Future<void> _submitEmergency(String type) async {
    setState(() => _isSubmitting = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location services are disabled')));
        setState(() => _isSubmitting = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permission denied')));
          setState(() => _isSubmitting = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permission permanently denied')));
        setState(() => _isSubmitting = false);
        return;
      }

      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      final resp = await _service.createEmergency(
        latitude: pos.latitude,
        longitude: pos.longitude,
        vehicleId: _selectedVehicle?.id,
        vehicleBrand: _selectedVehicle == null ? (_merkController.text.trim().isEmpty ? null : _merkController.text.trim()) : null,
        vehicleType: _selectedVehicle == null ? (_tipeController.text.trim().isEmpty ? null : _tipeController.text.trim()) : null,
        vehicleModel: _selectedVehicle == null ? (_modelController.text.trim().isEmpty ? null : _modelController.text.trim()) : null,
        plateNumber: _selectedVehicle == null ? (_platController.text.trim().isEmpty ? null : _platController.text.trim()) : null,
        complaint: _keluhanController.text.trim().isEmpty ? null : _keluhanController.text.trim(),
        damagePhoto: _damagePhoto,
        emergencyType: type,
      );

      if (resp['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resp['message'] ?? 'Permintaan emergency berhasil')));
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainWrapper(daruratType: type == 'towing' ? 'towing' : 'mekanik')),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resp['message'] ?? 'Gagal membuat permintaan')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
