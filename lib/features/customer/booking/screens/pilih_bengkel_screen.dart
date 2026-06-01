import 'dart:io';
import 'package:flutter/material.dart';
import 'package:motocare/core/services/booking_service.dart';
import 'package:motocare/features/customer/booking/models/booking_models.dart';
import 'ringkasan_booking_screen.dart';

class PilihBengkelScreen extends StatefulWidget {
  final Vehicle selectedVehicle;
  final List<ServiceModel> selectedServices;
  final String complaint;
  final File? damagePhoto;

  const PilihBengkelScreen({
    super.key,
    required this.selectedVehicle,
    required this.selectedServices,
    required this.complaint,
    this.damagePhoto,
  });

  @override
  State<PilihBengkelScreen> createState() => _PilihBengkelScreenState();
}

class _PilihBengkelScreenState extends State<PilihBengkelScreen> {
  final _service = BookingService();
  List<Workshop> _workshops = [];
  Workshop? _selectedWorkshop;
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadWorkshops();
  }

  Future<void> _loadWorkshops() async {
    final workshops = await _service.getWorkshops();
    if (mounted) {
      setState(() {
        _workshops = workshops;
        _isLoading = false;
      });
    }
  }

  List<Workshop> get _filteredWorkshops => _workshops
      .where((w) =>
          w.name.toLowerCase().contains(_searchQuery.toLowerCase()))
      .toList();

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStepper(),
                  const SizedBox(height: 40),
                  const Text(
                    'Pilih Bengkel',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildBengkelList(),
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
        Container(width: 40, height: 2, color: Colors.blue),
        _buildStepActive(Icons.location_on, 'Pilih\nBengkel'),
        Container(width: 40, height: 2, color: Colors.grey.shade300),
        _buildStepInactive(Icons.receipt_long, 'Ringkasan &\nKonfirmasi'),
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

  Widget _buildStepInactive(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey, width: 2),
          ),
          child: Icon(icon, color: Colors.grey),
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

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: const InputDecoration(
          hintText: 'Cari Bengkel',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildBengkelList() {
    final list = _filteredWorkshops;
    if (list.isEmpty) {
      return const Center(
        child: Text('Tidak ada bengkel ditemukan.',
            style: TextStyle(color: Colors.grey)),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final workshop = list[index];
        final isSelected = _selectedWorkshop?.id == workshop.id;
        return GestureDetector(
          onTap: () => setState(() => _selectedWorkshop = workshop),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Colors.lightBlue : Colors.transparent,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
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
                    color: isSelected
                        ? Colors.lightBlue.shade100
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.build,
                      color: isSelected
                          ? Colors.lightBlue
                          : Colors.black54),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    workshop.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected ? Colors.lightBlue : Colors.grey.shade300,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
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
            onPressed: _selectedWorkshop == null
                ? null
                : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RingkasanBookingScreen(
                          selectedVehicle: widget.selectedVehicle,
                          selectedServices: widget.selectedServices,
                          selectedWorkshop: _selectedWorkshop!,
                          complaint: widget.complaint,
                          damagePhoto: widget.damagePhoto,
                        ),
                      ),
                    ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue,
              disabledBackgroundColor: Colors.grey.shade300,
              elevation: 0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Berikutnya',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
