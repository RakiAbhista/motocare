import 'package:flutter/material.dart';
import '../widgets/service_detail_bottom_sheet.dart';
import '../../kendaraan/widgets/detail_motor_bottom_sheet.dart';
import '../../home/screens/notifikasi_screen.dart';

class RiwayatScreen extends StatelessWidget {
  const RiwayatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const RiwayatHeader(),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const KendaraanInfoItem(),
                  const SizedBox(height: 24),
                  const StatusServiceItem(),
                  const SizedBox(height: 32),
                  const RiwayatListSection(),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class RiwayatHeader extends StatelessWidget {
  const RiwayatHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: const BoxDecoration(
          color: Color(0xFF1976D2),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             const Text(
               'Riwayat Service',
               style: TextStyle(
                 color: Colors.white,
                 fontSize: 20,
                 fontWeight: FontWeight.bold,
               ),
             ),
             InkWell(
               onTap: () => Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const NotifikasiScreen()),
               ),
               child: const Icon(Icons.notifications_none, color: Colors.white, size: 26),
             ),
           ],
         ),
      ),
    );
  }
}

class KendaraanInfoItem extends StatelessWidget {
  const KendaraanInfoItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kendaraan anda',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.motorcycle,
                size: 50,
                color: Color(0xFF90A4AE),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Honda Beatrix',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'H 1945 AGS',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => DetailMotorBottomSheet.show(context),
                    child: const Text(
                      'Detail',
                      style: TextStyle(
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class StatusServiceItem extends StatelessWidget {
  const StatusServiceItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.history_outlined, color: Color(0xFF5A5A5A), size: 18),
            SizedBox(width: 6),
            Text(
              'Status Service',
              style: TextStyle(
                color: Color(0xFF5A5A5A),
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Terakhir Service',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          '2 Bulan yang lalu',
          style: TextStyle(
            color: Color(0xFF1976D2),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class RiwayatListSection extends StatelessWidget {
  const RiwayatListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Riwayat Service',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF1A1A1A),
              ),
            ),
             GestureDetector(
               onTap: () {
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Fitur Filter akan segera hadir!')),
                 );
               },
               child: const Text(
                 'Filter',
                 style: TextStyle(
                   color: Color(0xFF1976D2),
                   fontWeight: FontWeight.w600,
                   fontSize: 14,
                 ),
               ),
             ),
          ],
        ),
        const SizedBox(height: 16),
        RiwayatListCard(
          icon: Icons.build,
          title: 'Service Rutin',
          date: '12 Feb 2024',
          location: 'Ahas Cabang Semarang Barat',
          onTap: () => ServiceDetailBottomSheet.show(context),
        ),
        const SizedBox(height: 16),
        RiwayatListCard(
          icon: Icons.battery_charging_full,
          title: 'Ganti Aki',
          date: '12 Feb 2024',
          location: 'Ahas Cabang Semarang Barat',
          onTap: () => ServiceDetailBottomSheet.show(context),
        ),
        const SizedBox(height: 16),
        RiwayatListCard(
          icon: Icons.oil_barrel,
          title: 'Ganti Oli',
          date: '12 Feb 2024',
          location: 'Ahas Cabang Semarang Barat',
          onTap: () => ServiceDetailBottomSheet.show(context),
        ),
      ],
    );
  }
}

class RiwayatListCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String date;
  final String location;
  final VoidCallback? onTap;

  const RiwayatListCard({
    super.key,
    required this.icon,
    required this.title,
    required this.date,
    required this.location,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF37474F),
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                location,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    );
  }
}
