import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/core/theme/app_theme.dart';
import 'package:motocare/core/theme/app_background.dart';
import 'package:motocare/widgets/custom_card.dart';
import 'package:motocare/widgets/status_badge.dart';
import '../widgets/service_detail_bottom_sheet.dart';
import '../../home/screens/notifikasi_screen.dart';
import '../../kendaraan/widgets/detail_motor_bottom_sheet.dart';
import 'package:motocare/core/services/riwayat_service.dart';

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
  }

  Future<void> refresh() async {
    await _loadData();
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
      body: BengkelBackground(
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _RiwayatHeader(),
                    const SizedBox(height: 12),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _loadData,
                        color: AppColors.primary,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: AppTheme.pagePaddingH,
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

                                if (_selectedVehicle != null)
                                  _KendaraanInfoItem(vehicle: _selectedVehicle!),

                                if (_selectedVehicle == null)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 40),
                                    child: Center(
                                      child: Text(
                                        'Belum ada kendaraan terdaftar',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),

                                const SizedBox(height: 16),

                                if (_serviceHistoryData != null)
                                  _StatusServiceItem(
                                    lastServiceDate: _serviceHistoryData!['last_service_date'],
                                    totalServices: _serviceHistoryData!['total_services'] ?? 0,
                                  ),

                                const SizedBox(height: 24),

                                if (_serviceHistoryData != null)
                                  _RiwayatListSection(
                                    serviceHistory: List<Map<String, dynamic>>.from(
                                      _serviceHistoryData!['service_history'] ?? [],
                                    ),
                                  ),
                                const SizedBox(height: 100),
                              ],
                            ),
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
}

class _RiwayatHeader extends StatelessWidget {
  const _RiwayatHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Riwayat Servis',
                style: AppTheme.headlineLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'Lihat riwayat servis kendaraan Anda',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotifikasiScreen()),
            ),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.notifications, color: Colors.white, size: 22),
            ),
          ),
        ],
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
                color: isSelected ? AppColors.primary : Colors.grey.shade100,
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

class _KendaraanInfoItem extends StatelessWidget {
  final Map<String, dynamic> vehicle;
  const _KendaraanInfoItem({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      accentColor: AppColors.primary,
      cutCorner: true,
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.motorcycle, size: 45, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${vehicle['brand'] ?? ''} ${vehicle['model'] ?? ''}', style: AppTheme.titleLarge),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(vehicle['plate_number'] ?? '',
                      style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w600, color: AppColors.primary)),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => DetailMotorBottomSheet.show(context, vehicle: vehicle),
                  child: Text('Lihat Detail', style: AppTheme.linkText),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ),
        ],
      ),
    );
  }
}

class _StatusServiceItem extends StatelessWidget {
  final String? lastServiceDate;
  final int totalServices;

  const _StatusServiceItem({
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.15)),
        color: AppColors.warning.withValues(alpha: 0.04),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: const Icon(Icons.history_rounded, color: AppColors.warning, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status Servis', style: AppTheme.bodySmall),
                  const SizedBox(height: 4),
                  const Text('Terakhir Servis', style: AppTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(_formatTimeAgo(lastServiceDate),
                      style: const TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(
                    'Total service: $totalServices kali',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            StatusBadge.warning('Perlu Servis'),
          ],
        ),
      ),
    );
  }
}

class _RiwayatListSection extends StatelessWidget {
  final List<Map<String, dynamic>> serviceHistory;

  const _RiwayatListSection({
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
            const Row(
              children: [
                Icon(Icons.receipt_long_rounded, color: AppColors.primary, size: 20),
                SizedBox(width: 8),
                Text('Riwayat Servis', style: AppTheme.titleLarge),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur Filter akan segera hadir!')),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Filter', style: AppTheme.linkText),
                    const SizedBox(width: 4),
                    Icon(Icons.filter_list, size: 16, color: AppColors.primary.withValues(alpha: 0.6)),
                  ],
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
                  Icon(Icons.history_rounded, size: 48, color: Colors.grey.shade300),
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
          final status = order['status'] ?? 'Selesai';

          // Build service names string
          final serviceNamesFull = services.map((s) => s['service_name'] ?? '').join(', ');
          String serviceNames = serviceNamesFull;
          const int maxLen = 24;
          if (serviceNamesFull.length > maxLen) {
            serviceNames = serviceNamesFull.substring(0, maxLen).trim();
            // try to avoid cutting mid-word
            final lastComma = serviceNames.lastIndexOf(',');
            if (lastComma > 0 && lastComma > (maxLen - 8)) {
              serviceNames = serviceNames.substring(0, lastComma);
            }
            serviceNames = '$serviceNames...';
          }

          // Get icon based on first service name
          IconData icon = Icons.build_rounded;
          if (serviceNames.toLowerCase().contains('oli')) {
            icon = Icons.oil_barrel_rounded;
          } else if (serviceNames.toLowerCase().contains('aki')) {
            icon = Icons.battery_charging_full_rounded;
          } else if (serviceNames.toLowerCase().contains('filter')) {
            icon = Icons.filter_alt_rounded;
          } else if (serviceNames.toLowerCase().contains('rem')) {
            icon = Icons.disc_full_rounded;
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

          Color statusColor = AppColors.success;
          if (status == 'pending') statusColor = AppColors.warning;
          if (status == 'process') statusColor = AppColors.primary;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _RiwayatListCard(
              icon: icon,
              title: serviceNames.isNotEmpty ? serviceNames : 'Service',
              date: formattedDate,
              location: workshop?['name'] ?? '-',
              status: status == 'pending' ? 'Ditinjau' : (status == 'process' ? 'Proses' : 'Selesai'),
              statusColor: statusColor,
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

class _RiwayatListCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String date;
  final String location;
  final String status;
  final Color statusColor;
  final VoidCallback? onTap;

  const _RiwayatListCard({
    required this.icon,
    required this.title,
    required this.date,
    required this.location,
    required this.status,
    required this.statusColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(color: Colors.grey.shade100),
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
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: AppTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(date, style: AppTheme.labelSmall.copyWith(color: AppColors.primary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 12, color: Colors.grey.shade400),
                      const SizedBox(width: 4),
                      Text(location, style: AppTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            StatusBadge.success(status),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, color: Colors.grey.shade300, size: 20),
          ],
        ),
      ),
    );
  }
}
