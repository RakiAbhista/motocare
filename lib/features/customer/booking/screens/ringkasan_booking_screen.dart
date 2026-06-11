import 'dart:io';
import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/core/theme/app_theme.dart';
import 'package:motocare/widgets/main_wrapper.dart';
import 'package:motocare/features/customer/booking/models/booking_models.dart';
import 'package:motocare/core/services/booking_service.dart';

class RingkasanBookingScreen extends StatefulWidget {
  final Vehicle selectedVehicle;
  final List<ServiceModel> selectedServices;
  final Workshop selectedWorkshop;
  final String complaint;
  final File? damagePhoto;

  const RingkasanBookingScreen({
    super.key,
    required this.selectedVehicle,
    required this.selectedServices,
    required this.selectedWorkshop,
    required this.complaint,
    this.damagePhoto,
  });

  @override
  State<RingkasanBookingScreen> createState() =>
      _RingkasanBookingScreenState();
}

class _RingkasanBookingScreenState extends State<RingkasanBookingScreen> {
  final _service = BookingService();
  BookingSummary? _summary;
  bool _isLoadingSummary = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    final summary = await _service.getSummary(
      vehicleId: widget.selectedVehicle.id,
      workshopId: widget.selectedWorkshop.id,
      serviceIds: widget.selectedServices.map((s) => s.id).toList(),
    );
    if (mounted) {
      setState(() {
        _summary = summary;
        _isLoadingSummary = false;
      });
    }
  }

  Future<void> _submitBooking() async {
    setState(() => _isSubmitting = true);
    final result = await _service.createBooking(
      vehicleId: widget.selectedVehicle.id,
      workshopId: widget.selectedWorkshop.id,
      serviceIds: widget.selectedServices.map((s) => s.id).toList(),
      complaint: widget.complaint,
      damagePhoto: widget.damagePhoto,
      totalPrice: _summary?.totalPrice ??
          widget.selectedServices.fold<double>(
              0, (sum, s) => sum + (double.tryParse(s.basePrice) ?? 0)),
    );
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking berhasil dibuat!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const MainWrapper(hasActiveBooking: true)),
        (route) => false,
      );
    } else {
      final msg = result['message'] ?? 'Terjadi kesalahan, coba lagi.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.red),
      );
    }
  }

  String _formatPrice(double price) {
    final formatted = price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return 'Rp $formatted';
  }

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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.selectedVehicle.brand} ${widget.selectedVehicle.model}', style: AppTheme.titleMedium),
            const SizedBox(height: 2),
            Text(widget.selectedVehicle.plateNumber, style: AppTheme.bodySmall),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailKendaraan() {
    final v = widget.selectedVehicle;
    return Column(
      children: [
        _buildRow('Merk Kendaraan', v.brand),
        _buildRow('Tipe Kendaraan', v.vehicleType),
        _buildRow('Nomor Plat', v.plateNumber),
        _buildRow('Tahun Keluaran', v.manufacturingYear.toString()),
      ],
    );
  }

  Widget _buildRow(String label, String value) {
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
    if (widget.damagePhoto == null) {
      return const Text('Tidak ada foto dilampirkan', style: AppTheme.bodySmall);
    }
    return Container(
      width: 120,
      height: 120,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        child: Image.file(widget.damagePhoto!, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildBengkelInfo() {
    final w = widget.selectedWorkshop;
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(w.name, style: AppTheme.titleMedium),
              const SizedBox(height: 2),
              const Row(
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
            onPressed: _isSubmitting ? null : _submitBooking,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Kirim'),
            ),
          ),
        ],
      ),
    );
  }
}
