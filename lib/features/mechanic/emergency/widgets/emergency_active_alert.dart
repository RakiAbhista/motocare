import 'package:flutter/material.dart';
import 'package:motocare/features/cs/home/service/mechanic_emergency_service.dart';
import '../screens/detail_emergency_screen.dart';
import 'package:motocare/core/theme/app_colors.dart';

class EmergencyActiveAlert extends StatefulWidget {
  const EmergencyActiveAlert({super.key});

  @override
  State<EmergencyActiveAlert> createState() => _EmergencyActiveAlertState();
}

class _EmergencyActiveAlertState extends State<EmergencyActiveAlert> {
  Map<String, dynamic>? _emergency;
  bool _loading = true;
  bool _accepted = false;

  @override
  void initState() {
    super.initState();
    _loadEmergency();
  }

  Future<void> _loadEmergency() async {
    try {
      final svc = MechanicEmergencyService();
      final list = await svc.getEmergencies();
      if (list.isNotEmpty) {
        setState(() => _emergency = Map<String, dynamic>.from(list.first as Map));
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  String _formatTime(String? iso) {
    if (iso == null) return 'Just Now';
    try {
      final dt = DateTime.parse(iso);
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 1) return 'Just Now';
      if (diff.inHours < 1) return '${diff.inMinutes} mins ago';
      if (diff.inDays < 1) return '${diff.inHours} hrs ago';
      return '${diff.inDays} days ago';
    } catch (_) {
      return 'Just Now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientName = _emergency?['client']?['name']?.toString() ?? '-';
    final clientPhone = _emergency?['client']?['phone']?.toString() ?? '';
    final plate = _emergency?['vehicle']?['plate_number']?.toString() ?? '-';
    final brand = _emergency?['vehicle']?['brand']?.toString() ?? '';
    final model = _emergency?['vehicle']?['model']?.toString() ?? '';
    final title = (_emergency?['status']?.toString() ?? _emergency?['order_status']?.toString() ?? '-').toUpperCase();
    final time = _formatTime(_emergency?['created_at']?.toString());

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.danger, // Warna merah darurat
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.danger.withOpacity(0.2),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Badge High Priority & Waktu
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: const Text(
                  'HIGH PRIORITY',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Row 2: Judul Masalah
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.25,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Row 3: Detail Keluhan
          Text(
            'Plat nomor: $plate. Pengguna: $clientName ${clientPhone.isNotEmpty ? "($clientPhone)" : ''}\nKendaraan: $brand $model',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.9),
              height: 1.62,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Row 4: Tombol Aksi
          Row(
            children: [
              if (!_accepted) ...[
                // Tombol Terima Panggilan (Primary)
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final svc = MechanicEmergencyService();
                      final id = _emergency?['emergency_id'] as int? ?? _emergency?['id'] as int?;
                      if (id == null) {
                        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ID panggilan tidak ditemukan')));
                        return;
                      }
                      final ok = await svc.acceptEmergency(id);
                      if (ok) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Panggilan diterima')));
                          setState(() => _accepted = true);
                          // Navigate to detail page with the emergency id so backend will be queried
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DetailEmergencyScreen(emergencyId: id)),
                          );
                        }
                      } else {
                        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal menerima panggilan')));
                      }
                    } catch (e) {
                      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.danger,
                    elevation: 5,
                    shadowColor: Colors.black.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                  child: const Text(
                    'Terima Panggilan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],

              // Tombol Lihat Detail (Secondary)
              OutlinedButton(
                onPressed: () {
                  final id = _emergency?['emergency_id'] as int? ?? _emergency?['id'] as int?;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailEmergencyScreen(emergencyId: id),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
                child: const Text(
                  'Lihat Detail',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
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
