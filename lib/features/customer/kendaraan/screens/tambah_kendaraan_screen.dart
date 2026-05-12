import 'package:flutter/material.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.lightBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tambah Kendaraan',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Isi Data Kendaraan',
              style: TextStyle(
                color: Colors.lightBlue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),

            // 1. JENIS KENDARAAN
            const RequiredLabel(text: 'Jenis Kendaraan'),
            const SizedBox(height: 16),
            VehicleTypeSelector(
              isMotorSelected: isMotorSelected,
              onMotorTap: () => setState(() => isMotorSelected = true),
              onMobilTap: () => setState(() => isMotorSelected = false),
            ),
            const SizedBox(height: 32),

            // 2. TEXT FIELD INPUT
            CustomVehicleTextField(
              label: 'Merk Kendaraan',
              hint: 'Contoh : Yamaha',
              controller: merkController,
            ),
            CustomVehicleTextField(
              label: 'Tipe Kendaraan',
              hint: 'Contoh : Aerox',
              controller: tipeController,
            ),
            CustomVehicleTextField(
              label: 'Nomer Plat',
              hint: 'Contoh : X-1234-XXX',
              controller: platController,
            ),
            CustomVehicleTextField(
              label: 'Tahun Keluaran',
              hint: 'Contoh : 2020',
              controller: tahunController,
              keyboardType: TextInputType.number,
            ),

            // 3. UPLOAD STNK
            const RequiredLabel(text: 'Upload Foto STNK'),
            const SizedBox(height: 4),
            const Text(
              '(PDF, Maks. 1MB)',
              style: TextStyle(color: Colors.grey, fontSize: 10),
            ),
            const SizedBox(height: 8),
            UploadBox(
              onTap: () {
                // TODO: Implement file picker
              },
            ),
            const SizedBox(height: 40),

            // 4. TOMBOL TAMBAHKAN
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement submit
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Tambahkan',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ==================== CUSTOM WIDGETS ====================

/// Widget untuk label dengan tanda bintang merah wajib
class RequiredLabel extends StatelessWidget {
  final String text;

  const RequiredLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}

/// Widget untuk text field form kendaraan dengan underline border
class CustomVehicleTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const CustomVehicleTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RequiredLabel(text: label),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.lightBlue),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget untuk pemilihan jenis kendaraan (Motor/Mobil)
class VehicleTypeSelector extends StatelessWidget {
  final bool isMotorSelected;
  final VoidCallback onMotorTap;
  final VoidCallback onMobilTap;

  const VehicleTypeSelector({
    super.key,
    required this.isMotorSelected,
    required this.onMotorTap,
    required this.onMobilTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: onMotorTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.motorcycle,
              size: 48,
              color: isMotorSelected ? Colors.lightBlue : Colors.grey.shade300,
            ),
          ),
        ),
        const SizedBox(width: 48),
        InkWell(
          onTap: onMobilTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.directions_car,
              size: 48,
              color: !isMotorSelected ? Colors.lightBlue : Colors.grey.shade300,
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget untuk box upload file
class UploadBox extends StatelessWidget {
  final VoidCallback onTap;

  const UploadBox({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: const [
            Icon(Icons.arrow_upward, color: Colors.black87, size: 20),
            SizedBox(width: 8),
            Text(
              'Tambahkan File',
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
