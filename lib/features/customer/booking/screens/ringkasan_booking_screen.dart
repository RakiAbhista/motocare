import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/core/theme/app_theme.dart';
import 'package:motocare/widgets/main_wrapper.dart';

class RingkasanBookingScreen extends StatelessWidget {
  const RingkasanBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Servis'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: AppTheme.pagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStepper(),
                  const SizedBox(height: 32),
                  const Row(
                    children: [
                      Icon(Icons.receipt_long_rounded, color: AppColors.primary, size: 22),
                      SizedBox(width: 8),
                      Text('Ringkasan Booking', style: AppTheme.headlineSmall),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text('Pastikan data booking Anda sudah benar',
                      style: AppTheme.bodySmall),
                  const SizedBox(height: 20),
                  _buildSummaryCard(
                    icon: Icons.motorcycle,
                    title: 'Kendaraan',
                    child: _buildVehicleInfo(),
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryCard(
                    icon: Icons.info_outline,
                    title: 'Detail Kendaraan',
                    child: _buildDetailKendaraan(),
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryCard(
                    icon: Icons.camera_alt_outlined,
                    title: 'Foto Kerusakan',
                    child: _buildPhotoSection(),
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryCard(
                    icon: Icons.location_on,
                    title: 'Bengkel',
                    child: _buildBengkelInfo(),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          _buildBottomButtons(context),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStepCompleted(Icons.motorcycle, 'Pilih\nKendaraan'),
          _buildConnector(true),
          _buildStepCompleted(Icons.location_on, 'Pilih\nBengkel'),
          _buildConnector(true),
          _buildStepActive(Icons.receipt_long, 'Ringkasan &\nKonfirmasi'),
        ],
      ),
    );
  }

  Widget _buildConnector(bool isActive) {
    return Container(
      width: 36,
      height: 2,
      color: isActive ? AppColors.primary : Colors.grey.shade200,
      margin: const EdgeInsets.only(bottom: 24),
    );
  }

  Widget _buildStepCompleted(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 72,
          child: Text(label, textAlign: TextAlign.center, style: AppTheme.bodySmall),
        ),
      ],
    );
  }

  Widget _buildStepActive(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 72,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textBody,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({required IconData icon, required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text(title, style: AppTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildVehicleInfo() {
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.08),
                blurRadius: 4,
              ),
            ],
          ),
          child: const Icon(Icons.motorcycle, size: 36, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Honda Beatrix', style: AppTheme.titleMedium),
            SizedBox(height: 2),
            Text('H 1945 AGS', style: AppTheme.bodySmall),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailKendaraan() {
    return Column(
      children: [
        _buildAutoFillRow('Merk Kendaraan', 'Autofill'),
        _buildAutoFillRow('Tipe Kendaraan', 'Autofill'),
        _buildAutoFillRow('Nomor Plat', 'Autofill'),
        _buildAutoFillRow('Tahun Keluaran', 'Autofill'),
      ],
    );
  }

  Widget _buildAutoFillRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text('$label : ', style: AppTheme.bodySmall),
          Text(value, style: AppTheme.titleMedium),
        ],
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
          ),
        ],
      ),
      child: const Icon(Icons.image, color: Colors.grey, size: 40),
    );
  }

  Widget _buildBengkelInfo() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          ),
          child: const Icon(Icons.build_rounded, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('BENGKEL 123', style: AppTheme.titleMedium),
              SizedBox(height: 2),
              Row(
                children: [
                  Icon(Icons.star, size: 14, color: Color(0xFFF59E0B)),
                  SizedBox(width: 4),
                  Text('4.8 (120 Penilaian)', style: AppTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text('50m',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      padding: AppTheme.pagePadding,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kembali'),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const MainWrapper(hasActiveBooking: true)),
              (route) => false,
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Kirim'),
            ),
          ),
        ],
      ),
    );
  }
}
