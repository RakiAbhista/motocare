import 'package:flutter/material.dart';
import '../../../../core/services/riwayat_service.dart';
import '../../emergency/screens/panggilan_darurat_screen.dart';
import '../../booking/screens/booking_servis_screen.dart';

class DetailKendaraanBottomSheet extends StatefulWidget {
  final int vehicleId;

  const DetailKendaraanBottomSheet({
    super.key,
    required this.vehicleId,
  });

  static void show(BuildContext context, {required int vehicleId}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DetailKendaraanBottomSheet(vehicleId: vehicleId),
    );
  }

  @override
  State<DetailKendaraanBottomSheet> createState() => _DetailKendaraanBottomSheetState();
}

class _DetailKendaraanBottomSheetState extends State<DetailKendaraanBottomSheet> {
  final RiwayatService _service = RiwayatService();
  bool _isLoading = true;
  Map<String, dynamic>? _vehicleData;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    final data = await _service.getVehicleDetail(widget.vehicleId);
    setState(() {
      _vehicleData = data;
      _isLoading = false;
    });
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF1976D2)))
                : _vehicleData == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 48, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            Text(
                              'Gagal memuat detail kendaraan',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            _MotorHeaderCard(vehicle: _vehicleData!),
                            const SizedBox(height: 16),
                            _SpecsCard(vehicle: _vehicleData!),
                            const SizedBox(height: 16),
                            _VehicleInfoCard(vehicle: _vehicleData!),
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
  final Map<String, dynamic> vehicle;

  const _MotorHeaderCard({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final brand = vehicle['brand'] ?? '';
    final model = vehicle['model'] ?? '';
    final plate = vehicle['plate_number'] ?? '-';

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
                Text(
                  '$brand $model',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                  child: Text(
                    plate,
                    style: const TextStyle(
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
  final Map<String, dynamic> vehicle;

  const _SpecsCard({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final year = vehicle['manufacturing_year']?.toString() ?? '-';
    final type = vehicle['vehicle_type'] ?? '-';

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
          Text(
            'Tahun : $year',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Tipe : $type',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _VehicleInfoCard extends StatelessWidget {
  final Map<String, dynamic> vehicle;

  const _VehicleInfoCard({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final brand = vehicle['brand'] ?? '-';
    final model = vehicle['model'] ?? '-';
    final plate = vehicle['plate_number'] ?? '-';
    final year = vehicle['manufacturing_year']?.toString() ?? '-';
    final type = vehicle['vehicle_type'] ?? '-';

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
            'Informasi Kendaraan',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          _infoRow('Merek', brand),
          const SizedBox(height: 10),
          _infoRow('Model', model),
          const SizedBox(height: 10),
          _infoRow('Plat Nomor', plate),
          const SizedBox(height: 10),
          _infoRow('Tahun Pembuatan', year),
          const SizedBox(height: 10),
          _infoRow('Tipe Kendaraan', type),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
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
