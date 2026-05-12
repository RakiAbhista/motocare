import 'package:flutter/material.dart';

import '../../../../widgets/custom_top_bar.dart';
import '../widgets/promo_banner_carousel.dart';
import '../../emergency/screens/panggilan_darurat_screen.dart';
import 'notifikasi_screen.dart';
import '../../kendaraan/widgets/detail_motor_bottom_sheet.dart';
import '../../booking/screens/booking_servis_screen.dart';

class BerandaScreen extends StatelessWidget {
  final bool hasActiveBooking;
  final String? daruratType;
  const BerandaScreen({super.key, this.hasActiveBooking = false, this.daruratType});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;
    final contentWidth = isWideScreen ? 800.0 : screenWidth;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PanggilanDaruratScreen()),
        ),
        backgroundColor: const Color(0xFFD32F2F),
        shape: const CircleBorder(),
        child: const Icon(Icons.warning_amber, color: Colors.black, size: 28),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header & Banner
              _buildHeader(context),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWideScreen ? 40 : 16,
                ),
                child: Center(
                  child: SizedBox(
                    width: contentWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const PromoBannerCarousel(),
                        const SizedBox(height: 24),

                        // Points & Voucher Card
                        _buildPointsVoucherCard(context),
                        const SizedBox(height: 20),

                        // Status Panggilan Darurat
                        if (daruratType != null) ...[
                          _buildStatusDarurat(),
                          const SizedBox(height: 24),
                        ],

                        const SizedBox(height: 20),

                        // Kendaraan Anda
                        _buildKendaraanCard(context),
                        const SizedBox(height: 20),

                        // Service Status & Booking
                        _buildServiceSection(context),
                        const SizedBox(height: 24),

                        // Riwayat Service Terbaru
                        _buildRecentServiceHistory(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return CustomTopBar(
      onNotificationTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NotifikasiScreen()),
      ),
    );
  }

  Widget _buildPointsVoucherCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.stars, color: Colors.blue, size: 24),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Poin Saya',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '36 Poin',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            width: 1,
            color: Colors.grey.shade200,
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur Voucher akan segera hadir!')),
              );
            },
            icon: const Icon(Icons.local_activity, size: 18),
            label: const Text('Voucher'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKendaraanCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Kendaraan Anda',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Icon(Icons.arrow_drop_down, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 100,
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Text(
                      'H 1945 AGS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => DetailMotorBottomSheet.show(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(80, 32),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Detail'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDarurat() {
    final isMekanik = daruratType == 'mekanik';
    final title = isMekanik ? 'Bengkel 123' : 'Towing H 1234 HE';
    final step2Label = isMekanik ? 'Mekanik Menuju Lokasi' : 'Towing Menuju Lokasi';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status Panggilan Darurat',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTrackerNode(true, 'Peninjauan\nPanggilan'),
              _buildTrackerLine(false),
              _buildTrackerNode(false, step2Label),
              _buildTrackerLine(false),
              _buildTrackerNode(false, 'Servis\nBerlangsung'),
              _buildTrackerLine(false),
              _buildTrackerNode(false, 'Menunggu\nPembayaran'),
            ],
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Menunggu konfirmasi mekanik...',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status Service',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          if (!hasActiveBooking) ...[
            const Text(
              'HONDA BEATRIX',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const Text(
              'H 1945 AGS',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BookingServisScreen()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Booking Servis',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ] else ...[
            const Text(
              'HONDA BEATRIX',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const Text(
              'H 1945 AGS',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTrackerNode(true, 'Sedang\nDitinjau'),
                _buildTrackerLine(false),
                _buildTrackerNode(false, 'Servis\nDimulai'),
                _buildTrackerLine(false),
                _buildTrackerNode(false, 'Menunggu\nPembayaran'),
                _buildTrackerLine(false),
                _buildTrackerNode(false, 'Servis\nSelesai'),
              ],
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Wait for review',
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrackerNode(bool isActive, String label) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.blue : Colors.transparent,
            border: Border.all(
              color: isActive ? Colors.blue : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: isActive
              ? const Icon(Icons.check, color: Colors.white, size: 14)
              : null,
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 64,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildTrackerLine(bool isActive) {
    return Container(
      width: 32,
      height: 2,
      color: isActive ? Colors.blue : Colors.grey.shade300,
      margin: const EdgeInsets.only(top: 11),
    );
  }

  Widget _buildRecentServiceHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Riwayat Servis',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              'Lihat Semua',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.check_circle, color: Colors.green, size: 24),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ganti Oli & Tune Up',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '28 Apr 2026 • Bengkel MotoCare',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }
}
