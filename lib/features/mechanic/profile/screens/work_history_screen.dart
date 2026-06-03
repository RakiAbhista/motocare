import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';

class MechanicWorkHistoryScreen extends StatelessWidget {
  const MechanicWorkHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // List data dummy riwayat pekerjaan mekanik
    final List<Map<String, dynamic>> historyJobs = [
      {
        'customer': 'Ahmad Subagyo',
        'vehicle': 'Honda Beat (2022)',
        'plate': 'B 1234 XYZ',
        'service': 'Ganti Oli & Servis Ringan',
        'date': '02 Juni 2026, 14:30',
        'price': 'Rp 120.000',
        'type': 'REGULAR',
      },
      {
        'customer': 'Rina Wijaya',
        'vehicle': 'Yamaha Mio M3 (2021)',
        'plate': 'AD 4567 TY',
        'service': 'Ganti Kampas Rem Depan',
        'date': '01 Juni 2026, 10:15',
        'price': 'Rp 85.000',
        'type': 'EMERGENCY',
      },
      {
        'customer': 'Joko Susilo',
        'vehicle': 'Suzuki Smash (2018)',
        'plate': 'H 8821 OP',
        'service': 'Tune-up Karburator & Bersihkan Busi',
        'date': '31 Mei 2026, 16:00',
        'price': 'Rp 95.000',
        'type': 'REGULAR',
      },
      {
        'customer': 'Fajar Nugroho',
        'vehicle': 'Kawasaki Ninja 250',
        'plate': 'AD 9999 GG',
        'service': 'Ganti Rantai & Gear Set',
        'date': '29 Mei 2026, 11:00',
        'price': 'Rp 350.000',
        'type': 'REGULAR',
      },
      {
        'customer': 'Siti Aminah',
        'vehicle': 'Vespa Sprint S',
        'plate': 'AD 5678 JK',
        'service': 'Perbaikan Kelistrikan & Lampu',
        'date': '28 Mei 2026, 09:30',
        'price': 'Rp 150.000',
        'type': 'EMERGENCY',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Riwayat Pekerjaan',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: historyJobs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_toggle_off_rounded,
                    size: 64,
                    color: const Color(0xFF1E293B).withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada riwayat pekerjaan',
                    style: TextStyle(
                      color: const Color(0xFF1E293B).withOpacity(0.5),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemCount: historyJobs.length,
              itemBuilder: (context, index) {
                final job = historyJobs[index];
                final isEmergency = job['type'] == 'EMERGENCY';

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E293B).withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xFF1E293B).withOpacity(0.05),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header: Date and Badge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              job['date']!,
                              style: TextStyle(
                                fontSize: 12,
                                color: const Color(0xFF1E293B).withOpacity(0.5),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isEmergency
                                    ? AppColors.danger.withOpacity(0.1)
                                    : AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                isEmergency ? 'DARURAT' : 'REGULER',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: isEmergency
                                      ? AppColors.danger
                                      : AppColors.primary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Customer & Vehicle Info
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.motorcycle_rounded,
                                color: AppColors.primary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    job['vehicle']!,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${job['customer']} • ${job['plate']}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: const Color(0xFF1E293B)
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24, thickness: 1),
                        // Service Detail and Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tindakan:',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: const Color(0xFF1E293B)
                                          .withOpacity(0.4),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    job['service']!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1E293B),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Pendapatan:',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: const Color(0xFF1E293B)
                                        .withOpacity(0.4),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  job['price']!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.success,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
