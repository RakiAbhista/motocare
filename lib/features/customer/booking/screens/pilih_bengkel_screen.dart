import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/core/theme/app_theme.dart';
import 'ringkasan_booking_screen.dart';

class PilihBengkelScreen extends StatefulWidget {
  const PilihBengkelScreen({super.key});

  @override
  State<PilihBengkelScreen> createState() => _PilihBengkelScreenState();
}

class _PilihBengkelScreenState extends State<PilihBengkelScreen> {
  int selectedIndex = 0;

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
                  const Text('Pilih Bengkel', style: AppTheme.headlineSmall),
                  const SizedBox(height: 16),
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  _buildBengkelList(),
                ],
              ),
            ),
          ),
          _buildBottomButtons(),
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
        _buildStepActive(Icons.location_on, 'Pilih\nBengkel'),
        _buildConnector(false),
        _buildStepInactive(Icons.receipt_long, 'Ringkasan &\nKonfirmasi'),
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

  Widget _buildStepInactive(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey, width: 2),
          ),
          child: Icon(icon, color: Colors.grey, size: 22),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(label, textAlign: TextAlign.center, style: AppTheme.bodySmall),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(color: AppColors.border),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Cari Bengkel',
          hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildBengkelList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) => _buildBengkelItem(index),
    );
  }

  Widget _buildBengkelItem(int index) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryLight : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: Icon(Icons.build_rounded,
                  color: isSelected ? AppColors.primary : Colors.grey, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('BENGKEL 123', style: AppTheme.titleMedium),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber.shade700, size: 14),
                      const SizedBox(width: 4),
                      const Text('4.8 (120 Penilaian)', style: AppTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
            const Text('50m', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(width: 12),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? AppColors.primary : Colors.grey.shade300,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
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
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RingkasanBookingScreen(),
              ),
            ),
            child: const Text('Berikutnya'),
          ),
        ],
      ),
    );
  }
}
