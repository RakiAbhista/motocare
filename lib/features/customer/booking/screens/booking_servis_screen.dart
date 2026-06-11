import 'dart:io';
import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/core/theme/app_theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motocare/features/customer/booking/models/booking_models.dart';
import '../widgets/pilih_kendaraan_bottom_sheet.dart';
import '../widgets/pilih_layanan_bottom_sheet.dart';
import 'pilih_bengkel_screen.dart';

class BookingServisScreen extends StatefulWidget {
  const BookingServisScreen({super.key});

  @override
  State<BookingServisScreen> createState() => _BookingServisScreenState();
}

class _BookingServisScreenState extends State<BookingServisScreen> {
  Vehicle? _selectedVehicle;
  List<ServiceModel> _selectedServices = [];
  File? _damagePhoto;
  final _complaintController = TextEditingController();

  @override
  void dispose() {
    _complaintController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null && mounted) {
      setState(() => _damagePhoto = File(pickedFile.path));
    }
  }

  String _formatPrice(double price) {
    final formatted = price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return 'Rp $formatted';
  }

  double get _totalServicePrice => _selectedServices.fold(
      0, (sum, s) => sum + (double.tryParse(s.basePrice) ?? 0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Servis'),
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
            _buildStepper(),
            const SizedBox(height: 32),
            _buildVehicleSection(context),
            if (_selectedVehicle != null)
              Column(
                children: [
                  const SizedBox(height: 24),
                  _buildServiceDropdown(context),
                  const SizedBox(height: 24),
                  _buildComplaintField(),
                  const SizedBox(height: 28),
                  _buildDetailKendaraan(),
                  const SizedBox(height: 28),
                  _buildPhotoSection(),
                  const SizedBox(height: 32),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_selectedVehicle == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Silakan pilih kendaraan terlebih dahulu')),
                          );
                          return;
                        }
                        if (_selectedServices.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Silakan pilih minimal satu layanan servis')),
                          );
                          return;
                        }
                        if (_complaintController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Silakan tuliskan keluhan kendaraan Anda')),
                          );
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PilihBengkelScreen(
                              selectedVehicle: _selectedVehicle!,
                              selectedServices: _selectedServices,
                              complaint: _complaintController.text,
                              damagePhoto: _damagePhoto,
                            ),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('Berikutnya'),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStep(Icons.motorcycle, 'Pilih\nKendaraan', true),
          _buildConnector(false),
          _buildStep(Icons.location_on, 'Pilih\nBengkel', false),
          _buildConnector(false),
          _buildStep(Icons.receipt_long, 'Ringkasan &\nKonfirmasi', false),
        ],
      ),
    );
  }

  Widget _buildStep(IconData icon, String label, bool isActive) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.primary : Colors.transparent,
            border: Border.all(
              color: isActive ? AppColors.primary : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Icon(icon,
              color: isActive ? Colors.white : Colors.grey, size: 20),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 72,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: isActive ? AppColors.textBody : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConnector(bool isActive) {
    return Container(
      width: 36,
      height: 2,
      color: isActive ? AppColors.primary : Colors.grey.shade200,
      margin: const EdgeInsets.only(bottom: 24),
    );
  }

  Widget _buildVehicleSection(BuildContext context) {
    final hasVehicle = _selectedVehicle != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.motorcycle, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text('Pilih Kendaraan', style: AppTheme.titleMedium),
          ],
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => PilihKendaraanBottomSheet.show(context).then((value) {
            if (value != null) {
              setState(() => _selectedVehicle = value);
            }
          }),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(
                color: hasVehicle ? AppColors.primary.withValues(alpha: 0.4) : AppColors.border,
              ),
              boxShadow: hasVehicle
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: hasVehicle ? AppColors.primaryLight : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: Icon(
                    hasVehicle ? Icons.motorcycle : Icons.add_circle_outline,
                    color: hasVehicle ? AppColors.primary : Colors.grey,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    hasVehicle
                        ? '${_selectedVehicle!.brand} ${_selectedVehicle!.model} (${_selectedVehicle!.plateNumber})'
                        : 'Pilih Kendaraan',
                    style: TextStyle(
                      color: hasVehicle ? AppColors.textBody : Colors.grey,
                      fontSize: 14,
                      fontWeight: hasVehicle ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 22),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.build_rounded, color: AppColors.primary, size: 18),
            SizedBox(width: 8),
            Text('Pilih Layanan Servis *',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final result = await PilihLayananBottomSheet.show(
              context,
              initialSelected: _selectedServices,
            );
            if (result != null) {
              setState(() => _selectedServices = result);
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _selectedServices.isEmpty
                        ? 'Pilih Layanan'
                        : _selectedServices.map((s) => s.serviceName).join(', '),
                    style: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComplaintField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.edit_note_rounded, color: AppColors.primary, size: 18),
            SizedBox(width: 8),
            Text('Catatan Keluhan *',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _complaintController,
          maxLines: 3,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Tuliskan keluhan kendaraan Anda',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailKendaraan() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primary, size: 18),
              SizedBox(width: 8),
              Text('Detail Kendaraan', style: AppTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 12),
          _buildRow('Merk Kendaraan', _selectedVehicle?.brand ?? '-'),
          _buildRow('Tipe Kendaraan', _selectedVehicle?.vehicleType ?? '-'),
          _buildRow('Nomor Plat', _selectedVehicle?.plateNumber ?? '-'),
          _buildRow('Tahun Keluaran', _selectedVehicle?.manufacturingYear.toString() ?? '-'),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text('$label : ', style: AppTheme.bodySmall),
          Text(value, style: AppTheme.titleMedium),
        ],
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.camera_alt_outlined, color: AppColors.textBody, size: 18),
            SizedBox(width: 8),
            Text('Foto Kerusakan Fisik',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 4),
        const Text('Pastikan gambar terlihat jelas.', style: AppTheme.bodySmall),
        const SizedBox(height: 12),
        if (_damagePhoto == null)
          InkWell(
            onTap: _pickPhoto,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(color: AppColors.border, width: 2),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload_outlined, color: Colors.grey, size: 36),
                  SizedBox(height: 8),
                  Text('Tambahkan File',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          )
        else
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  child: Image.file(_damagePhoto!, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: -8,
                right: -8,
                child: InkWell(
                  onTap: () => setState(() => _damagePhoto = null),
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
      ],
    );
  }
}
