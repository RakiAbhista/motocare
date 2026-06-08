import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/core/theme/app_theme.dart';
import 'package:motocare/core/theme/app_background.dart';
import 'package:motocare/widgets/custom_card.dart';
import 'package:motocare/widgets/status_badge.dart';
import '../widgets/service_detail_bottom_sheet.dart';
import '../../home/screens/notifikasi_screen.dart';
import '../../kendaraan/widgets/detail_motor_bottom_sheet.dart';

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
      body: BengkelBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _RiwayatHeader(),
                const SizedBox(height: 24),
                Padding(
                  padding: AppTheme.pagePaddingH,
                  child: Column(
                    children: [
                      const _KendaraanInfoItem(),
                      const SizedBox(height: 16),
                      const _StatusServiceItem(),
                      const SizedBox(height: 24),
                      const _RiwayatListSection(),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
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

class _KendaraanInfoItem extends StatelessWidget {
  const _KendaraanInfoItem();

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
                const Text('Honda Beatrix', style: AppTheme.titleLarge),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('H 1945 AGS',
                      style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w600, color: AppColors.primary)),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => DetailMotorBottomSheet.show(context),
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
  const _StatusServiceItem();

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
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status Servis', style: AppTheme.bodySmall),
                  SizedBox(height: 4),
                  Text('Terakhir Servis', style: AppTheme.titleMedium),
                  SizedBox(height: 2),
                  Text('2 Bulan yang lalu',
                      style: TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold, fontSize: 14)),
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
  const _RiwayatListSection();

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
        _RiwayatListCard(
          icon: Icons.build_rounded,
          title: 'Service Rutin',
          date: '12 Feb 2024',
          location: 'Ahas Cabang Semarang Barat',
          status: 'Selesai',
          statusColor: AppColors.success,
          onTap: () => ServiceDetailBottomSheet.show(context),
        ),
        const SizedBox(height: 12),
        _RiwayatListCard(
          icon: Icons.battery_charging_full_rounded,
          title: 'Ganti Aki',
          date: '12 Feb 2024',
          location: 'Ahas Cabang Semarang Barat',
          status: 'Selesai',
          statusColor: AppColors.success,
          onTap: () => ServiceDetailBottomSheet.show(context),
        ),
        const SizedBox(height: 12),
        _RiwayatListCard(
          icon: Icons.oil_barrel_rounded,
          title: 'Ganti Oli',
          date: '12 Feb 2024',
          location: 'Ahas Cabang Semarang Barat',
          status: 'Selesai',
          statusColor: AppColors.success,
          onTap: () => ServiceDetailBottomSheet.show(context),
        ),
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
                      Text(title, style: AppTheme.titleMedium),
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
