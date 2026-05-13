import 'package:flutter/material.dart';
import '../screens/detail_emergency_screen.dart';
import 'package:motocare/core/theme/app_colors.dart';

class EmergencyActiveAlert extends StatelessWidget {
  const EmergencyActiveAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.danger, // Warna merah darurat
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.danger.withOpacity(0.2),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Badge High Priority & Waktu
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: const Text(
                  'HIGH PRIORITY',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Just Now',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Row 2: Judul Masalah
          const Text(
            'MESIN MATI',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.25,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Row 3: Detail Keluhan
          Text(
            'Plat nomor: H 4 HA. Pengguna\nKeluhan : Mesin mati secara tiba-tiba',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.9),
              height: 1.62,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Row 4: Tombol Aksi
          Row(
            children: [
              // Tombol Terima Panggilan (Primary)
              ElevatedButton(
                onPressed: () {
                  // Tambahkan logika terima panggilan di sini
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.danger,
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
                child: const Text(
                  'Terima Panggilan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Tombol Lihat Detail (Secondary)
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailEmergencyScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
                child: const Text(
                  'Lihat Detail',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
