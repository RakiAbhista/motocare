import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/core/theme/app_theme.dart';
import '../../emergency/screens/panggilan_darurat_screen.dart';
import '../../booking/screens/booking_servis_screen.dart';
import 'package:motocare/core/services/riwayat_service.dart';

class DetailMotorBottomSheet extends StatefulWidget {
  final Map<String, dynamic>? vehicle;
  final int? vehicleId;

  const DetailMotorBottomSheet({super.key, this.vehicle, this.vehicleId});

  static void show(BuildContext context, {Map<String, dynamic>? vehicle, int? vehicleId}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DetailMotorBottomSheet(vehicle: vehicle, vehicleId: vehicleId),
    );
  }

  @override
  State<DetailMotorBottomSheet> createState() => _DetailMotorBottomSheetState();
}

class _DetailMotorBottomSheetState extends State<DetailMotorBottomSheet> {
  Map<String, dynamic>? _vehicleData;
  bool _isLoading = false;
  final RiwayatService _riwayatService = RiwayatService();

  @override
  void initState() {
    super.initState();
    if (widget.vehicle != null) {
      _vehicleData = widget.vehicle;
    } else if (widget.vehicleId != null) {
      _loadDetail(widget.vehicleId!);
    }
  }

  Future<void> _loadDetail(int id) async {
    setState(() => _isLoading = true);
    final detail = await _riwayatService.getVehicleDetail(id);
    if (mounted) {
      setState(() {
        _vehicleData = detail;
        _isLoading = false;
      });
    }
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
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _MotorHeaderCard(vehicle: _vehicleData),
                        const SizedBox(height: 16),
                        _SpecsCard(vehicle: _vehicleData),
                        const SizedBox(height: 16),
                        _ServiceInfoCard(vehicle: _vehicleData),
                        const SizedBox(height: 16),
                        _StnkCard(vehicle: _vehicleData),
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
  final Map<String, dynamic>? vehicle;
  const _MotorHeaderCard({this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: const Icon(Icons.motorcycle, size: 50, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${vehicle?['brand'] ?? ''} ${vehicle?['model'] ?? ''}', style: AppTheme.titleLarge),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    vehicle?['plate_number'] ?? '-',
                    style: const TextStyle(
                      color: AppColors.primary,
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
    );
  }
}

class _SpecsCard extends StatelessWidget {
  final Map<String, dynamic>? vehicle;
  const _SpecsCard({this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSpecRow('Tahun', vehicle != null ? '${vehicle!['manufacturing_year'] ?? '-'}' : '-'),
          const SizedBox(height: 8),
          _buildSpecRow('Kilometer', '-'),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTheme.bodySmall),
        Text(value, style: AppTheme.titleMedium),
      ],
    );
  }
}

class _ServiceInfoCard extends StatelessWidget {
  final Map<String, dynamic>? vehicle;
  const _ServiceInfoCard({this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi Service',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Text('Service Terakhir : -', style: AppTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Status : ', style: AppTheme.bodySmall),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: const Text(
                  'Perlu Service',
                  style: TextStyle(
                    color: AppColors.warning,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StnkCard extends StatelessWidget {
  final Map<String, dynamic>? vehicle;
  const _StnkCard({this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'STNK',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: Center(child: Text(vehicle?['registration_doc'] ?? '-', style: AppTheme.titleMedium)),
          ),
        ],
      ),
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
              backgroundColor: AppColors.dangerDark,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Column(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.white, size: 28),
                SizedBox(height: 4),
                Text('Panggilan Darurat',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
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
              side: const BorderSide(color: AppColors.primary, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Column(
              children: [
                Icon(Icons.assignment_turned_in, color: AppColors.primary, size: 28),
                SizedBox(height: 4),
                Text('Booking Servis',
                    style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
