import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/core/theme/app_theme.dart';
import 'package:motocare/core/theme/app_background.dart';
import 'package:motocare/widgets/custom_top_bar.dart';
import 'package:motocare/widgets/custom_card.dart';
import 'package:motocare/widgets/section_header.dart';
import 'package:motocare/widgets/status_badge.dart';
import '../widgets/promo_banner_carousel.dart';
import 'notifikasi_screen.dart';
import '../../kendaraan/widgets/detail_motor_bottom_sheet.dart';
import '../../booking/screens/booking_servis_screen.dart';
import 'package:motocare/core/services/customer_home_service.dart';

class BerandaScreen extends StatefulWidget {
  final bool hasActiveBooking;
  final String? daruratType;
  const BerandaScreen({super.key, this.hasActiveBooking = false, this.daruratType});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  Map<String, dynamic>? homeData;
  bool isLoading = true;
  final _service = CustomerHomeService();

  @override
  void initState() {
    super.initState();
  }

  Future<void> refresh() async {
    await _loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    final data = await _service.getHomeData();
    if (mounted) {
      if (data['success'] == true && data['data'] != null) {
        setState(() {
          homeData = data['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Gagal memuat data dari server.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BengkelBackground(
        child: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: AppTheme.pagePaddingH,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PromoBannerCarousel(banners: homeData?['banners'] as List<dynamic>? ?? []),
                              const SizedBox(height: 24),
                              _buildPointsVoucherCard(context),
                              const SizedBox(height: 24),
                              if (widget.daruratType != null) ...[
                                _buildStatusDarurat(),
                                const SizedBox(height: 24),
                              ],
                              _buildKendaraanCard(context),
                              const SizedBox(height: 24),
                              _buildServiceSection(context),
                              const SizedBox(height: 24),
                              _buildRecentServiceHistory(),
                              const SizedBox(height: 100),
                            ],
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

  Widget _buildHeader(BuildContext context) {
    return CustomTopBar(
      onNotificationTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NotifikasiScreen()),
      ),
    );
  }

  Widget _buildPointsVoucherCard(BuildContext context) {
    final userSummary = homeData?['user_summary'];
    final points = userSummary?['points'] ?? 0;
    final voucherCount = userSummary?['active_vouchers_count'] ?? userSummary?['active_vouchers'] ?? 0;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.08),
            AppColors.primary.withValues(alpha: 0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg - 1),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: const Icon(Icons.stars_rounded, color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                        const Text('Poin Saya', style: AppTheme.bodySmall),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text('$points', style: TextStyle(color: AppColors.primary, fontSize: 28, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 4),
                        Text('Poin', style: TextStyle(color: AppColors.primary.withValues(alpha: 0.7), fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.local_activity, size: 12, color: AppColors.warning),
                              const SizedBox(width: 4),
                              Text('$voucherCount Voucher', style: const TextStyle(color: AppColors.warning, fontSize: 11, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Tukar', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 4),
                      Icon(Icons.chevron_right, color: Colors.white.withValues(alpha: 0.7), size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKendaraanCard(BuildContext context) {
    final vehicles = homeData?['vehicles'] as List<dynamic>?;
    final vehicle = (vehicles != null && vehicles.isNotEmpty) ? vehicles.first : null;
    final vehicleName = vehicle != null ? '${vehicle['brand']} ${vehicle['model']}' : 'Tidak ada kendaraan';
    final plateNumber = vehicle?['plate_number'] ?? '-';

    return CustomCard(
      accentColor: AppColors.primary,
      cutCorner: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.motorcycle, color: AppColors.primary, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Kendaraan Anda',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 12, color: AppColors.success),
                    SizedBox(width: 4),
                    Text('Aktif', style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 100,
                height: 90,
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
                child: const Icon(Icons.motorcycle, size: 50, color: AppColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(vehicleName, style: AppTheme.titleLarge)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(plateNumber, style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 8),
                        const Text('2020', style: AppTheme.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 32,
                      child: OutlinedButton(
                        onPressed: () => DetailMotorBottomSheet.show(context, vehicle: vehicle),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          side: BorderSide(color: AppColors.primary.withValues(alpha: 0.4)),
                        ),
                        child: const Text('Detail Kendaraan', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDarurat() {
    final isMekanik = widget.daruratType == 'mekanik';
    final title = isMekanik ? 'Bengkel 123' : 'Towing H 1234 HE';
    final step2Label = isMekanik ? 'Mekanik Menuju Lokasi' : 'Towing Menuju Lokasi';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.2)),
        color: AppColors.danger.withValues(alpha: 0.04),
        boxShadow: [
          BoxShadow(
            color: AppColors.danger.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: const Icon(Icons.warning_amber_rounded, color: AppColors.danger, size: 18),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Status Panggilan Darurat',
                    style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                StatusBadge.danger('Aktif'),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.danger,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTheme.titleMedium.copyWith(color: AppColors.danger)),
                    const SizedBox(height: 2),
                    const Text('Sedang dalam penanganan...', style: AppTheme.bodySmall),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTrackerNode(true, 'Peninjauan\nPanggilan'),
                _buildTrackerLine(false),
                _buildTrackerNode(false, step2Label),
                _buildTrackerLine(false),
                _buildTrackerNode(false, 'Servis\nBerlangsung'),
                _buildTrackerLine(false),
                _buildTrackerNode(false, 'Menunggu\nPembayaran'),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 12, height: 12,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.danger),
                    ),
                    SizedBox(width: 8),
                    Text('Menunggu konfirmasi mekanik...', style: TextStyle(color: AppColors.danger, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceSection(BuildContext context) {
    final vehicles = homeData?['vehicles'] as List<dynamic>?;
    final vehicle = (vehicles != null && vehicles.isNotEmpty) ? vehicles.first : null;
    final vehicleName = vehicle != null ? '${vehicle['brand']} ${vehicle['model']}' : 'Tidak ada kendaraan';
    final plateNumber = vehicle?['plate_number'] ?? '-';

    // Check if there's an active order
    final activeOrder = homeData?['active_order'] as Map<String, dynamic>?;
    final hasActiveOrder = activeOrder != null;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.06),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: const Icon(Icons.build_rounded, color: AppColors.primary, size: 18),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Status Servis',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (!hasActiveOrder) ...[
              Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                    child: const Icon(Icons.motorcycle, size: 28, color: AppColors.primary),
                  ),
                  const SizedBox(width: 14),
                        Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(vehicleName, style: AppTheme.titleMedium),
                        const SizedBox(height: 2),
                        Text(plateNumber, style: AppTheme.bodySmall),
                      ],
                    ),
                  ),
                  StatusBadge.warning('Belum Servis'),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BookingServisScreen()),
                  ),
                  icon: const Icon(Icons.build_rounded, size: 18),
                  label: const Text('Booking Servis Sekarang'),
                ),
              ),
            ] else ...[
              Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                    child: const Icon(Icons.motorcycle, size: 28, color: AppColors.primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(vehicleName, style: AppTheme.titleMedium),
                        const SizedBox(height: 2),
                        Text(plateNumber, style: AppTheme.bodySmall),
                      ],
                    ),
                  ),
                  StatusBadge.primary('Dalam Antrian'),
                ],
              ),
              const SizedBox(height: 16),
              _buildTrackerWithStatus(activeOrder['status'] as String?),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    StatusBadge.primary(_getStatusLabel(activeOrder['status'] as String?)),
                    const SizedBox(height: 8),
                    Text('Tanggal: ${((activeOrder['booking_date'] as String?) ?? '-').split('T').first}', style: AppTheme.labelSmall),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getStatusLabel(String? status) {
    switch (status) {
      case 'pending':
        return 'Sedang Ditinjau';
      case 'process':
        return 'Servis Dimulai';
      case 'payment':
        return 'Menunggu Pembayaran';
      default:
        return 'Status Tidak Diketahui';
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'process':
        return Colors.blue;
      case 'payment':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  int _getStatusStep(String? status) {
    switch (status) {
      case 'pending':
        return 0;
      case 'process':
        return 1;
      case 'payment':
        return 2;
      default:
        return -1;
    }
  }

  Widget _buildTrackerWithStatus(String? status) {
    final steps = ['Ditinjau', 'Dimulai', 'Pembayaran'];
    final currentStep = _getStatusStep(status);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (index) {
        return Row(
          children: [
            _buildTrackerNode(index <= currentStep, steps[index]),
            if (index < steps.length - 1)
              _buildTrackerLine(index < currentStep),
          ],
        );
      }),
    );
  }

  Widget _buildTrackerNode(bool isActive, String label) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isActive ? 28 : 24,
          height: isActive ? 28 : 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.primary : Colors.transparent,
            border: Border.all(
              color: isActive ? AppColors.primary : Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 6,
                    ),
                  ]
                : null,
          ),
          child: isActive
              ? const Icon(Icons.check, color: Colors.white, size: 14)
              : null,
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 64,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Widget _buildTrackerLine(bool isActive) {
    return Container(
      width: 32,
      height: 2,
      decoration: BoxDecoration(
        gradient: isActive
            ? const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
              )
            : null,
        color: isActive ? null : Colors.grey.shade300,
      ),
      margin: const EdgeInsets.only(top: 13),
    );
  }

  Widget _buildRecentServiceHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Riwayat Servis',
          actionLabel: 'Lihat Semua',
        ),
        const SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(color: AppColors.success.withValues(alpha: 0.15)),
            color: AppColors.success.withValues(alpha: 0.03),
            boxShadow: [
              BoxShadow(
                color: AppColors.success.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      ),
                      child: const Icon(Icons.check_circle, color: AppColors.success, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Ganti Oli & Tune Up', style: AppTheme.titleMedium),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 10, color: Colors.grey.shade400),
                              const SizedBox(width: 4),
                              Text('28 Apr 2026', style: AppTheme.labelSmall),
                              const SizedBox(width: 12),
                              Icon(Icons.location_on, size: 10, color: Colors.grey.shade400),
                              const SizedBox(width: 4),
                              Text('Bengkel MotoCare', style: AppTheme.labelSmall),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.chevron_right, color: AppColors.success, size: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
