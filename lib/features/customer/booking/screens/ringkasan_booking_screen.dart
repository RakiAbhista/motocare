import 'dart:io';
import 'package:flutter/material.dart';
import 'package:motocare/core/services/booking_service.dart';
import 'package:motocare/features/customer/booking/models/booking_models.dart';
import '../../../../widgets/main_wrapper.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.lightBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Booking Servis',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoadingSummary
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStepper(),
                        const SizedBox(height: 40),
                        const Text(
                          'Ringkasan Booking',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        _buildVehicleCard(),
                        const SizedBox(height: 24),
                        _buildDetailKendaraan(),
                        const SizedBox(height: 24),
                        _buildLayananSection(),
                        const SizedBox(height: 24),
                        _buildKomplaySection(),
                        if (widget.damagePhoto != null) ...[
                          const SizedBox(height: 24),
                          _buildPhotoSection(),
                        ],
                        const SizedBox(height: 24),
                        _buildBengkelCard(),
                        const SizedBox(height: 24),
                        _buildTotalSection(),
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
        Container(width: 40, height: 2, color: Colors.blue),
        _buildStepCompleted(Icons.location_on, 'Pilih\nBengkel'),
        Container(width: 40, height: 2, color: Colors.blue),
        _buildStepActive(Icons.receipt_long, 'Ringkasan &\nKonfirmasi'),
      ],
    );
  }

  Widget _buildStepCompleted(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: Colors.lightBlue),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: Colors.grey)),
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
            border: Border.all(color: Colors.lightBlue, width: 2),
          ),
          child: Icon(icon, color: Colors.lightBlue),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildVehicleCard() {
    final v = widget.selectedVehicle;
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.lightBlue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.motorcycle,
              size: 50, color: Colors.lightBlue),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${v.brand} ${v.model}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                v.plateNumber,
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailKendaraan() {
    final v = widget.selectedVehicle;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Detail Kendaraan',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.grey)),
        const SizedBox(height: 12),
        _buildRow('Merk', v.brand),
        _buildRow('Model', v.model),
        _buildRow('Nomor Plat', v.plateNumber),
        _buildRow('Tahun', v.manufacturingYear.toString()),
        _buildRow('Tipe', v.vehicleType),
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text('$label : ',
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildLayananSection() {
    final services = _summary?.services ?? widget.selectedServices;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Layanan Servis',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.grey)),
        const SizedBox(height: 10),
        ...services.map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(s.serviceName,
                      style: const TextStyle(fontSize: 13)),
                  Text(
                    _formatPrice(double.tryParse(s.basePrice) ?? 0),
                    style: const TextStyle(
                        fontSize: 13,
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildKomplaySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Catatan Keluhan',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.grey)),
        const SizedBox(height: 8),
        Text(widget.complaint,
            style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Foto Kerusakan',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.grey)),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(widget.damagePhoto!,
              width: 120, height: 120, fit: BoxFit.cover),
        ),
      ],
    );
  }

  Widget _buildBengkelCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.lightBlue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.build, color: Colors.lightBlue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              widget.selectedWorkshop.name,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection() {
    final total = _summary?.totalPrice ??
        widget.selectedServices.fold<double>(
            0.0, (sum, s) => sum + (double.tryParse(s.basePrice) ?? 0));
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Total Biaya',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(
            _formatPrice(total),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.lightBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: _isSubmitting ? null : () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade400,
              elevation: 0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Kembali',
                style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: _isSubmitting ? null : _submitBooking,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue,
              disabledBackgroundColor: Colors.grey.shade300,
              elevation: 0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text('Kirim',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
          ),
        ],
      ),
    );
  }
}
