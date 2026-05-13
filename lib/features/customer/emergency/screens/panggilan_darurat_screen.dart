import 'package:flutter/material.dart';
import '../../home/screens/beranda_screen.dart';

class PanggilanDaruratScreen extends StatefulWidget {
  const PanggilanDaruratScreen({super.key});

  @override
  State<PanggilanDaruratScreen> createState() => _PanggilanDaruratScreenState();
}

class _PanggilanDaruratScreenState extends State<PanggilanDaruratScreen> {
  // State untuk pura-pura loading upload foto
  bool isUploaded = false;

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
        title: const Text('Panggilan Darurat', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. LOKASI SAAT INI
            const Text('Lokasi Saat Ini', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.lightBlue, size: 28),
                const SizedBox(width: 12),
                Expanded(child: Text('Jl. Banjarsari No. 212, Tembalang, Semarang', style: TextStyle(color: Colors.grey.shade700, fontSize: 12))),
              ],
            ),
            const SizedBox(height: 24),

            // 2. BENGKEL TERDEKAT
            const Text('Bengkel Terdekat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.lightBlue.shade200, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.build, color: Colors.black87),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('BENGKEL 123', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Row(
                        children: const [
                          Icon(Icons.star, color: Colors.yellow, size: 14),
                          SizedBox(width: 4),
                          Text('4.8 (120 Penilaian)', style: TextStyle(color: Colors.grey, fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ),
                const Text('50m', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 32),

            // 3. DETAIL KENDARAAN (Dinamis: Kosong / Terisi)
            RichText(
              text: const TextSpan(
                text: 'Detail Kendaraan', style: TextStyle(color: Colors.grey, fontSize: 14),
                children: [TextSpan(text: '*', style: TextStyle(color: Colors.red))],
              ),
            ),
            const SizedBox(height: 16),
            _buildInputField('Merk Kendaraan :'),
            _buildInputField('Tipe Kendaraan :'),
            _buildInputField('Nomor Plat :'),
            const SizedBox(height: 24),

            // 4. FOTO KERUSAKAN FISIK (Interaktif)
            const Text('Foto Kerusakan Fisik', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const Text('Pastikan gambar terlihat jelas.', style: TextStyle(color: Colors.grey, fontSize: 10)),
            const SizedBox(height: 16),
            Row(
              children: [
                // Thumbnail Foto (Muncul kalau isUploaded = true)
                if (isUploaded)
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 80, height: 80,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.motorcycle, color: Colors.grey, size: 40), // Placeholder motor hijau
                      ),
                      Positioned(
                        top: -8, right: 4,
                        child: GestureDetector(
                          onTap: () => setState(() => isUploaded = false), // Hapus foto
                          child: Container(
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: const Icon(Icons.cancel, color: Colors.red, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                // Tombol Upload
                GestureDetector(
                  onTap: () => setState(() => isUploaded = true), // Simulasi upload
                  child: Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.upload_file, color: Colors.black87),
                        SizedBox(height: 4),
                        Text('Tambah', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),

            // 5. TOMBOL PANGGIL MEKANIK & TOWING
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const BerandaScreen(daruratType: 'mekanik')),
                  (route) => false,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC62828),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Panggil Mekanik', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
            const Center(child: Text('atau', style: TextStyle(color: Colors.grey))),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const BerandaScreen(daruratType: 'towing')),
                  (route) => false,
                ),
                child: const Text('Panggil Towing', style: TextStyle(color: Color(0xFFC62828), fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              style: const TextStyle(fontSize: 12),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlue, width: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}