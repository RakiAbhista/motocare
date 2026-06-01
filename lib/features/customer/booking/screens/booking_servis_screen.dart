import 'dart:io';
import 'package:flutter/material.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.lightBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Booking Servis',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepper(),
            const SizedBox(height: 40),
            _buildVehicleSection(context),
            if (_selectedVehicle != null) ...[
              const SizedBox(height: 24),
              _buildServiceSection(context),
              const SizedBox(height: 24),
              _buildComplaintField(),
              const SizedBox(height: 32),
              _buildDetailKendaraan(),
              const SizedBox(height: 32),
              _buildPhotoSection(),
              const SizedBox(height: 40),
              if (_selectedServices.isNotEmpty) _buildNextButton(context),
              const SizedBox(height: 40),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStep(Icons.motorcycle, 'Pilih\nKendaraan', true),
        Container(width: 40, height: 2, color: Colors.grey.shade300),
        _buildStep(Icons.location_on, 'Pilih\nBengkel', false),
        Container(width: 40, height: 2, color: Colors.grey.shade300),
        _buildStep(Icons.receipt_long, 'Ringkasan &\nKonfirmasi', false),
      ],
    );
  }

  Widget _buildStep(IconData icon, String label, bool isActive) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? Colors.blue : Colors.grey,
              width: 2,
            ),
          ),
          child: Icon(icon, color: isActive ? Colors.blue : Colors.grey),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: isActive ? Colors.black : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Isi Data Kendaraan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () async {
            final vehicle = await PilihKendaraanBottomSheet.show(context);
            if (vehicle != null) {
              setState(() => _selectedVehicle = vehicle);
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: _selectedVehicle == null
                  ? Border.all(color: Colors.grey.shade300)
                  : null,
              boxShadow: _selectedVehicle != null
                  ? [
                      BoxShadow(
                        color: Colors.lightBlue.withValues(alpha: 0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : null,
            ),
            child: _selectedVehicle == null
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.motorcycle, color: Colors.grey, size: 28),
                          SizedBox(width: 12),
                          Text(
                            'Pilih Kendaraan',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                      Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  )
                : Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.motorcycle,
                            size: 36, color: Colors.lightBlue),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_selectedVehicle!.brand} ${_selectedVehicle!.model}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              _selectedVehicle!.plateNumber,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilih Layanan Servis',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _selectedServices.isEmpty
                      ? const Text(
                          'Pilih layanan servis...',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedServices
                                  .map((s) => s.serviceName)
                                  .join(', '),
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatPrice(_totalServicePrice),
                              style: const TextStyle(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
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
        RichText(
          text: const TextSpan(
            text: 'Catatan Keluhan',
            style: TextStyle(color: Colors.black87, fontSize: 12),
            children: [
              TextSpan(text: '*', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _complaintController,
          style: const TextStyle(fontSize: 12),
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Deskripsikan keluhan kendaraan Anda...',
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.lightBlue),
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailKendaraan() {
    final v = _selectedVehicle!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            text: 'Detail Kendaraan',
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 14),
            children: [
              TextSpan(text: '*', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildRow('Merk Kendaraan', v.brand),
        _buildRow('Model', v.model),
        _buildRow('Nomor Plat', v.plateNumber),
        _buildRow('Tahun Keluaran', v.manufacturingYear.toString()),
        _buildRow('Tipe', v.vehicleType),
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text('$label : ',
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Foto Kerusakan Fisik',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const Text('Pastikan gambar terlihat jelas.',
            style: TextStyle(color: Colors.grey, fontSize: 10)),
        const SizedBox(height: 12),
        _damagePhoto == null
            ? InkWell(
                onTap: _pickPhoto,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.grey.shade300, width: 2),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload_outlined,
                          color: Colors.grey, size: 36),
                      SizedBox(height: 8),
                      Text('Tambahkan File',
                          style:
                              TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              )
            : Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _damagePhoto!,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: -8,
                    right: -8,
                    child: InkWell(
                      onTap: () => setState(() => _damagePhoto = null),
                      child: const CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.cancel,
                            color: Colors.red, size: 22),
                      ),
                    ),
                  ),
                ],
              ),
      ],
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          if (_complaintController.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Mohon isi catatan keluhan terlebih dahulu.'),
              ),
            );
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PilihBengkelScreen(
                selectedVehicle: _selectedVehicle!,
                selectedServices: _selectedServices,
                complaint: _complaintController.text.trim(),
                damagePhoto: _damagePhoto,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text('Berikutnya',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
