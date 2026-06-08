import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/riwayat_service.dart';
import '../widgets/service_detail_bottom_sheet.dart';
import '../widgets/detail_kendaraan_bottom_sheet.dart';
import '../../home/screens/notifikasi_screen.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  final RiwayatService _riwayatService = RiwayatService();

  bool _isLoading = true;
  List<Map<String, dynamic>> _vehicles = [];
  Map<String, dynamic>? _selectedVehicle;
  Map<String, dynamic>? _serviceHistoryData;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final vehicles = await _riwayatService.getVehicles();

    if (vehicles.isNotEmpty) {
      final firstVehicle = vehicles.first;
      final history = await _riwayatService.getServiceHistory(firstVehicle['id']);

      setState(() {
        _vehicles = vehicles;
        _selectedVehicle = firstVehicle;
        _serviceHistoryData = history;
        _isLoading = false;
      });
    } else {
      setState(() {
        _vehicles = [];
        _selectedVehicle = null;
        _serviceHistoryData = null;
        _isLoading = false;
      });
    }
  }

  Future<void> _selectVehicle(Map<String, dynamic> vehicle) async {
    setState(() => _isLoading = true);

    final history = await _riwayatService.getServiceHistory(vehicle['id']);

    setState(() {
      _selectedVehicle = vehicle;
      _serviceHistoryData = history;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1976D2)))
          : RefreshIndicator(
              onRefresh: _loadData,
              color: const Color(0xFF1976D2),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const RiwayatHeader(),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          // Vehicle selector if multiple vehicles
                          if (_vehicles.length > 1)
                            _VehicleSelector(
                              vehicles: _vehicles,
                              selectedVehicle: _selectedVehicle,
                              onSelect: _selectVehicle,
                            ),
                          if (_vehicles.length > 1) const SizedBox(height: 16),

                          // Vehicle info
                          if (_selectedVehicle != null)
                            KendaraanInfoItem(
                              vehicle: _selectedVehicle!,
                              onDetailTap: () {
                                DetailKendaraanBottomSheet.show(
                                  context,
                                  vehicleId: _selectedVehicle!['id'],
                                );
                              },
                            ),

                          if (_selectedVehicle == null)
                            _EmptyState(
                              icon: Icons.motorcycle,
                              title: 'Belum Ada Kendaraan',
                              subtitle: 'Anda belum memiliki kendaraan terdaftar.',
                            ),

                          const SizedBox(height: 24),

                          // Service status
                          if (_serviceHistoryData != null)
                            StatusServiceItem(
                              lastServiceDate: _serviceHistoryData!['last_service_date'],
                              totalServices: _serviceHistoryData!['total_services'] ?? 0,
                            ),

                          const SizedBox(height: 32),

                          // Service history list
                          if (_serviceHistoryData != null)
                            RiwayatListSection(
                              serviceHistory: List<Map<String, dynamic>>.from(
                                _serviceHistoryData!['service_history'] ?? [],
                              ),
                            ),

                          if (_serviceHistoryData == null && _selectedVehicle != null)
                            _EmptyState(
                              icon: Icons.history,
                              title: 'Belum Ada Riwayat',
                              subtitle: 'Belum ada riwayat service untuk kendaraan ini.',
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
    );
  }
}

// ─── Vehicle Selector (for multiple vehicles) ─────────────────────────
class _VehicleSelector extends StatelessWidget {
  final List<Map<String, dynamic>> vehicles;
  final Map<String, dynamic>? selectedVehicle;
  final Function(Map<String, dynamic>) onSelect;

  const _VehicleSelector({
    required this.vehicles,
    required this.selectedVehicle,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: vehicles.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final vehicle = vehicles[index];
          final isSelected = selectedVehicle?['id'] == vehicle['id'];
          return GestureDetector(
            onTap: () => onSelect(vehicle),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1976D2) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(22),
                border: isSelected
                    ? null
                    : Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.motorcycle,
                    size: 18,
                    color: isSelected ? Colors.white : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${vehicle['brand']} ${vehicle['model']}',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
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

// ─── Empty State Widget ───────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(icon, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────
class RiwayatHeader extends StatelessWidget {
  const RiwayatHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: const BoxDecoration(
          color: Color(0xFF1976D2),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             const Text(
               'Riwayat Service',
               style: TextStyle(
                 color: Colors.white,
                 fontSize: 20,
                 fontWeight: FontWeight.bold,
               ),
             ),
             InkWell(
               onTap: () => Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const NotifikasiScreen()),
               ),
               child: const Icon(Icons.notifications_none, color: Colors.white, size: 26),
             ),
           ],
         ),
      ),
    );
  }
}

// ─── Kendaraan Info ───────────────────────────────────────────────────
class KendaraanInfoItem extends StatelessWidget {
  final Map<String, dynamic> vehicle;
  final VoidCallback? onDetailTap;

  const KendaraanInfoItem({
    super.key,
    required this.vehicle,
    this.onDetailTap,
  });

  @override
  Widget build(BuildContext context) {
    final brand = vehicle['brand'] ?? '';
    final model = vehicle['model'] ?? '';
    final plate = vehicle['plate_number'] ?? '-';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kendaraan anda',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.motorcycle,
                size: 50,
                color: Color(0xFF90A4AE),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$brand $model',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plate,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: onDetailTap,
                    child: const Text(
                      'Detail',
                      style: TextStyle(
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Status Service ───────────────────────────────────────────────────
class StatusServiceItem extends StatelessWidget {
  final String? lastServiceDate;
  final int totalServices;

  const StatusServiceItem({
    super.key,
    this.lastServiceDate,
    required this.totalServices,
  });

  String _formatTimeAgo(String? dateStr) {
    if (dateStr == null) return 'Belum pernah service';
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inDays == 0) return 'Hari ini';
      if (diff.inDays == 1) return 'Kemarin';
      if (diff.inDays < 7) return '${diff.inDays} hari yang lalu';
      if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} minggu yang lalu';
      if (diff.inDays < 365) return '${(diff.inDays / 30).floor()} bulan yang lalu';
      return '${(diff.inDays / 365).floor()} tahun yang lalu';
    } catch (_) {
      return 'Tidak diketahui';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.history_outlined, color: Color(0xFF5A5A5A), size: 18),
            SizedBox(width: 6),
            Text(
              'Status Service',
              style: TextStyle(
                color: Color(0xFF5A5A5A),
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Terakhir Service',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _formatTimeAgo(lastServiceDate),
          style: const TextStyle(
            color: Color(0xFF1976D2),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Total service: $totalServices kali',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

// ─── Riwayat List Section ─────────────────────────────────────────────
class RiwayatListSection extends StatelessWidget {
  final List<Map<String, dynamic>> serviceHistory;

  const RiwayatListSection({
    super.key,
    required this.serviceHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Riwayat Service',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF1A1A1A),
              ),
            ),
             GestureDetector(
               onTap: () {
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Fitur Filter akan segera hadir!')),
                 );
               },
               child: const Text(
                 'Filter',
                 style: TextStyle(
                   color: Color(0xFF1976D2),
                   fontWeight: FontWeight.w600,
                   fontSize: 14,
                 ),
               ),
             ),
          ],
        ),
        const SizedBox(height: 16),

        if (serviceHistory.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Icon(Icons.history, size: 48, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text(
                    'Belum ada riwayat service',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

        ...serviceHistory.map((order) {
          final services = List<Map<String, dynamic>>.from(order['services'] ?? []);
          final workshop = order['workshop'] as Map<String, dynamic>?;
          final bookingDate = order['booking_date'] as String?;

          // Build service names string
          final serviceNames = services.map((s) => s['service_name'] ?? '').join(', ');

          // Get icon based on first service name
          IconData icon = Icons.build;
          if (serviceNames.toLowerCase().contains('oli')) {
            icon = Icons.oil_barrel;
          } else if (serviceNames.toLowerCase().contains('aki')) {
            icon = Icons.battery_charging_full;
          } else if (serviceNames.toLowerCase().contains('filter')) {
            icon = Icons.filter_alt;
          } else if (serviceNames.toLowerCase().contains('rem')) {
            icon = Icons.disc_full;
          }

          String formattedDate = '-';
          if (bookingDate != null) {
            try {
              final date = DateTime.parse(bookingDate);
              formattedDate = DateFormat('dd-MM-yyyy').format(date);
            } catch (_) {
              formattedDate = bookingDate;
            }
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: RiwayatListCard(
              icon: icon,
              title: serviceNames.isNotEmpty ? serviceNames : 'Service',
              date: formattedDate,
              location: workshop?['name'] ?? '-',
              onTap: () => ServiceDetailBottomSheet.show(
                context,
                orderData: order,
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}

// ─── Riwayat List Card ────────────────────────────────────────────────
class RiwayatListCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String date;
  final String location;
  final VoidCallback? onTap;

  const RiwayatListCard({
    super.key,
    required this.icon,
    required this.title,
    required this.date,
    required this.location,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF37474F),
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF1A1A1A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    date,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                location,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 13,
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
