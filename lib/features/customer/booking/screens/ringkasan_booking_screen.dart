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
                  const Text('Ringkasan Booking', style: AppTheme.headlineSmall),
                  const SizedBox(height: 20),
                  _buildSummaryCard(
                    title: 'Kendaraan',
                    child: _buildVehicleInfo(),
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryCard(
                    title: 'Detail Kendaraan',
                    child: _buildDetailKendaraan(),
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryCard(
                    title: 'Foto Kerusakan',
                    child: _buildPhotoSection(),
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryCard(
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepCompleted(Icons.motorcycle, 'Pilih\nKendaraan'),
        _buildConnector(true),
        _buildStepCompleted(Icons.location_on, 'Pilih\nBengkel'),
        _buildConnector(true),
        _buildStepActive(Icons.receipt_long, 'Ringkasan &\nKonfirmasi'),
      ],
    );
  }

  Widget _buildConnector(bool isActive) {
    return Container(
      width: 40,
      height: 2,
      color: isActive ? AppColors.primary : Colors.grey.shade300,
      margin: const EdgeInsets.only(bottom: 28),
    );
  }

  Widget _buildStepCompleted(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(label, textAlign: TextAlign.center, style: AppTheme.bodySmall),
        ),
      ],
    );
  }

  Widget _buildStepActive(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
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

  Widget _buildSummaryCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTheme.titleMedium),
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
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          ),
          child: const Icon(Icons.motorcycle, size: 40, color: AppColors.primary),
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
              Text('4.8 (120 Penilaian)', style: AppTheme.bodySmall),
            ],
          ),
        ),
        const Text('50m', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
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
