import 'package:flutter/material.dart';
import '../../emergency/screens/panggilan_darurat_screen.dart';
import '../../booking/screens/booking_servis_screen.dart';

class DetailMotorBottomSheet extends StatelessWidget {
  const DetailMotorBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DetailMotorBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFFF4F8FB),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _MotorHeaderCard(),
                  const SizedBox(height: 16),
                  _SpecsCard(),
                  const SizedBox(height: 16),
                  _ServiceInfoCard(),
                  const SizedBox(height: 16),
                  _StnkCard(),
                  const SizedBox(height: 24),
                  _ActionButtonsRow(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MotorHeaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: const Icon(Icons.motorcycle, size: 50, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Honda Beatrix',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'H 1945 AGS',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
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

class _SpecsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Tahun : 2019',
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Kilometer : 12.500 KM',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _ServiceInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Informasi Service',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Service Terakhir : 12 Maret 2025',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          SizedBox(height: 8),
          Text(
            'Status : Perlu Service',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _StnkCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'STNK',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                const Center(child: Icon(Icons.image, color: Colors.blue, size: 40)),
          ),
        ],
      ),
    );
  }
}

class _ActionButtonsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
         Expanded(
           child: ElevatedButton(
             onPressed: () {
               Navigator.pop(context);
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const PanggilanDaruratScreen()),
               );
             },
             style: ElevatedButton.styleFrom(
               backgroundColor: const Color(0xFFC62828),
               padding: const EdgeInsets.symmetric(vertical: 16),
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(16),
               ),
             ),
             child: const Column(
               children: [
                 Icon(Icons.car_repair, color: Colors.white, size: 32),
                 SizedBox(height: 4),
                 Text(
                   'Panggilan Darurat',
                   style: TextStyle(
                     color: Colors.white,
                     fontSize: 12,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
               ],
             ),
           ),
         ),
         const SizedBox(width: 16),
         Expanded(
           child: OutlinedButton(
             onPressed: () {
               Navigator.pop(context);
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const BookingServisScreen()),
               );
             },
             style: OutlinedButton.styleFrom(
               backgroundColor: Colors.white,
               side: const BorderSide(color: Colors.blue, width: 2),
               padding: const EdgeInsets.symmetric(vertical: 16),
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(16),
               ),
             ),
             child: const Column(
               children: [
                 Icon(Icons.assignment_turned_in, color: Colors.blue, size: 32),
                 SizedBox(height: 4),
                 Text(
                   'Booking Servis',
                   style: TextStyle(
                     color: Colors.blue,
                     fontSize: 12,
                     fontWeight: FontWeight.bold,
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
