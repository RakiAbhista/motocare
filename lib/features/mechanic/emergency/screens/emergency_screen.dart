import 'package:flutter/material.dart';
import '../../../../widgets/custom_top_bar.dart';
import '../widgets/emergency_bottom_nav.dart';
import '../widgets/emergency_active_alert.dart';
import '../widgets/emergency_empty_alert.dart';
import 'package:motocare/features/cs/home/service/mechanic_emergency_service.dart';

class MechanicEmergencyScreen extends StatefulWidget {
  final bool showCompletionPopup;
  const MechanicEmergencyScreen({super.key, this.showCompletionPopup = false});

  @override
  State<MechanicEmergencyScreen> createState() => _MechanicEmergencyScreenState();
}

class _MechanicEmergencyScreenState extends State<MechanicEmergencyScreen> {
  bool _isLoading = true;
  bool _hasEmergency = false;
  List<dynamic> _history = [];

  @override
  void initState() {
    super.initState();
    _checkEmergencies();

    if (widget.showCompletionPopup) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showCompletionPopup();
      });
    }
  }

  Future<void> _checkEmergencies() async {
    try {
      final list = await MechanicEmergencyService().getEmergencies();
      final historyList = await MechanicEmergencyService().getHistory();
      if (mounted) {
        setState(() {
          _hasEmergency = list.isNotEmpty;
          _history = historyList;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _hasEmergency = false;
          _history = [];
          _isLoading = false;
        });
      }
    }
  }

  void _showCompletionPopup() {
    showDialog(
      context: context,
      barrierDismissible: true, // Can close by tapping outside
      builder: (dialogContext) {
        // Automatically close the dialog after 15 seconds if no action is taken
        Future.delayed(const Duration(seconds: 15), () {
          if (mounted && dialogContext.mounted && Navigator.of(dialogContext, rootNavigator: true).canPop()) {
            Navigator.of(dialogContext, rootNavigator: true).pop();
          }
        });
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 8),
              Text('Order Selesai', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Plus Jakarta Sans')),
            ],
          ),
          content: const Text(
            'Terima kasih telah menyelesaikan orderan darurat ini dengan baik. Status Anda kini kembali tersedia untuk menerima panggilan lain.',
            style: TextStyle(height: 1.5, fontFamily: 'Plus Jakarta Sans'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              child: const Text('Tutup', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: Column(
        children: [
          // 1. Header
          const CustomTopBar(),
          const SizedBox(height: 16),

          // 2. Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24), // Jarak dari header
                  // Editorial Header "Emergency"
                  const Text(
                    'Emergency',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                      letterSpacing: -0.9,
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (_isLoading)
                    const Center(child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ))
                  else if (_hasEmergency)
                    const EmergencyActiveAlert()
                  else
                    const EmergencyEmptyAlert(),

                  if (!_isLoading && _history.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    const Text(
                      'Riwayat Panggilan Darurat',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._history.map((h) => _buildHistoryItem(h)),
                  ],

                  const SizedBox(
                    height: 100,
                  ), // Spacer agar tidak tertutup nav bar
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const EmergencyBottomNav(),
      extendBody: true,
    );
  }

  Widget _buildHistoryItem(dynamic data) {
    final clientName = data['client']?['name']?.toString() ?? '-';
    final plate = data['vehicle']?['plate_number']?.toString() ?? '-';
    final brand = data['vehicle']?['brand']?.toString() ?? '';
    final model = data['vehicle']?['model']?.toString() ?? '';
    final dateRaw = data['created_at']?.toString() ?? '';
    final status = (data['order_status']?.toString() ?? data['status']?.toString() ?? 'completed').toLowerCase();
    
    String formattedDate = '';
    if (dateRaw.isNotEmpty) {
      try {
        final dt = DateTime.parse(dateRaw).toLocal();
        formattedDate = '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}';
      } catch (_) {
        formattedDate = dateRaw;
      }
    }

    Color statusColor = Colors.green;
    String statusText = 'Selesai';
    if (status == 'canceled' || status == 'cancelled') {
      statusColor = Colors.red;
      statusText = 'Dibatalkan';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedDate,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            clientName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 4),
          Text(
            '$brand $model ($plate)',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
