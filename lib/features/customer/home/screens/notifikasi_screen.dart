import 'package:flutter/material.dart';
import '../../booking/screens/booking_servis_screen.dart';

class NotifikasiScreen extends StatelessWidget {
  const NotifikasiScreen({super.key});

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
          'Pusat Notifikasi',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- NOTIFIKASI 1: PENGINGAT SERVIS (Dengan Tombol) ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.lightBlue.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.build, color: Colors.lightBlue),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Pengingat Servis', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text('2 Jam yang lalu', style: TextStyle(color: Colors.grey, fontSize: 10)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Halo John! 👋 Sepertinya sudah 2 bulan sejak servis terakhir. Yuk, Servis Honad Beatrix Anda agar tetap nyaman dikendarai.',
                              style: TextStyle(fontSize: 12, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Tombol Abaikan & Jadwalkan
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                       OutlinedButton(
                         onPressed: () {
                           ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(content: Text('Notifikasi diabaikan')),
                           );
                         },
                         style: OutlinedButton.styleFrom(
                           side: BorderSide(color: Colors.grey.shade300),
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                           minimumSize: const Size(80, 36),
                         ),
                         child: const Text('Abaikan', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                       ),
                       const SizedBox(width: 12),
                       ElevatedButton(
                         onPressed: () => Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => const BookingServisScreen()),
                         ),
                         style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.lightBlue,
                           elevation: 0,
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                           minimumSize: const Size(100, 36),
                         ),
                         child: const Text('Jadwalkan', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                       ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- NOTIFIKASI 2: PENAWARAN TERBAIK ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.local_offer, color: Colors.lightGreen),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Penawaran Terbaik', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('5 Jam yang lalu', style: TextStyle(color: Colors.grey, fontSize: 10)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Get 20% off on your next oil change with our partner workshops.',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // --- HEADER KEMARIN ---
            const Text('Kemarin', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 16),

            // --- NOTIFIKASI 3: SERVIS SELESAI ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.check_circle_outline, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Servis Selesai', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('Kemarin', style: TextStyle(color: Colors.grey, fontSize: 10)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Servis #id_servis telah berhasil diselesaikan. Sepeda Motor Anda siap untuk diambil.',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}