import 'package:flutter/material.dart';
import '../widgets/pilih_kendaraan_bottom_sheet.dart';
import '../widgets/pilih_layanan_bottom_sheet.dart';
import 'pilih_bengkel_screen.dart';

class BookingServisScreen extends StatefulWidget {
  const BookingServisScreen({super.key});

  @override
  State<BookingServisScreen> createState() => _BookingServisScreenState();
}

class _BookingServisScreenState extends State<BookingServisScreen> {
  bool isPhotoUploaded = false;
  bool isVehicleSelected = false;

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
            if (isVehicleSelected)
              Column(
                children: [
                  const SizedBox(height: 24),
                  _buildServiceDropdown(context),
                  const SizedBox(height: 24),
                  _buildComplaintField(),
                  const SizedBox(height: 32),
                  _buildDetailKendaraan(),
                  const SizedBox(height: 32),
                  _buildPhotoSection(),
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PilihBengkelScreen(),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Berikutnya',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  // --- STEPPER ---

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

  // --- VEHICLE CARD ---

  Widget _buildVehicleSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Isi Data Kendaraan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 16),
        if (!isVehicleSelected)
          InkWell(
            onTap: () => PilihKendaraanBottomSheet.show(context).then((value) {
              setState(() => isVehicleSelected = true);
            }),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.motorcycle, color: Colors.grey, size: 28),
                      SizedBox(width: 12),
                      Text(
                        'Pilih Kendaraan',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          )
        else
          InkWell(
            onTap: () => PilihKendaraanBottomSheet.show(context).then((value) {
              setState(() => isVehicleSelected = true);
            }),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.motorcycle,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text(
                          'Honda Beatrix',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'H 1945 AGS',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
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

  // --- SERVICE DROPDOWN ---

  Widget _buildServiceDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilih Layanan Servis',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => PilihLayananBottomSheet.show(context),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Paket Ganti Oli (Oli mesin + Gardan)',
                  style: TextStyle(color: Colors.black87, fontSize: 14),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- COMPLAINT FIELD ---

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
          initialValue: 'Ganti oli, Motor tidak bisa menyala',
          style: const TextStyle(fontSize: 12),
          decoration: InputDecoration(
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

  // --- DETAIL KENDARAAN ---

  Widget _buildDetailKendaraan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            text: 'Detail Kendaraan',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            children: [
              TextSpan(text: '*', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildAutoFillRow('Merk Kendaraan', 'Autofill'),
        _buildAutoFillRow('Tipe Kendaraan', 'Autofill'),
        _buildAutoFillRow('Nomor Plat', 'Autofill'),
        _buildAutoFillRow('Tahun Keluaran', 'Autofill'),
      ],
    );
  }

  Widget _buildAutoFillRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label : ',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // --- PHOTO SECTION ---

  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Foto Kerusakan Fisik',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Pastikan gambar terlihat jelas.',
          style: TextStyle(color: Colors.grey, fontSize: 10),
        ),
        const SizedBox(height: 12),
        if (!isPhotoUploaded)
          InkWell(
            onTap: () => setState(() => isPhotoUploaded = true),
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload_outlined, color: Colors.grey, size: 36),
                  SizedBox(height: 8),
                  Text(
                    'Tambahkan File',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
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
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Icon(Icons.image, color: Colors.grey, size: 50),
              ),
              Positioned(
                top: -8,
                right: -8,
                child: InkWell(
                  onTap: () => setState(() => isPhotoUploaded = false),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cancel,
                      color: Colors.red,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
