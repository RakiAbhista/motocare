import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import '../widgets/assign_mechanic_bottom_sheet.dart';
import '../widgets/emergency_app_bar.dart';
import '../widgets/emergency_customer_card.dart';
import '../widgets/emergency_initial_report.dart';
import '../widgets/emergency_map_section.dart';
import '../widgets/emergency_timer_card.dart';
import '../models/emergency_model.dart';
import '../service/emergency_service.dart';

class EmergencyAssignmentScreen extends StatefulWidget {
  final int emergencyId;

  const EmergencyAssignmentScreen({super.key, required this.emergencyId});

  @override
  State<EmergencyAssignmentScreen> createState() =>
      _EmergencyAssignmentScreenState();
}

class _EmergencyAssignmentScreenState extends State<EmergencyAssignmentScreen> {
  final EmergencyService _emergencyService = EmergencyService();
  EmergencyModel? _emergency;
  bool _isLoading = true;
  String? _errorMessage;

  final MapController mapController = MapController(
    initPosition: GeoPoint(
      latitude: -7.052312315405609,
      longitude: 110.43440956674928,
    ),
  );

  MechanicModel? _selectedMechanic;

  @override
  void initState() {
    super.initState();
    _loadEmergencyDetail();
  }

  Future<void> _loadEmergencyDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _emergencyService.getEmergencyDetail(widget.emergencyId);

    if (result['success']) {
      setState(() {
        _emergency = result['data'] as EmergencyModel;
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = result['message'];
        _isLoading = false;
      });
    }
  }

  bool _isSubmitting = false;

  Future<void> _confirmAssignment() async {
    if (_selectedMechanic == null) return;

    setState(() => _isSubmitting = true);

    final result = await _emergencyService.assignMechanic(
      emergencyId: widget.emergencyId,
      mechanicId: _selectedMechanic!.id,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (result['success'] == true) {
      _showSuccessDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Gagal assign mekanik'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.blue, size: 64),
            const SizedBox(height: 16),
            const Text(
              "Mekanik Berhasil Di-assign!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "${_selectedMechanic!.name} telah ditugaskan untuk menangani emergency ini.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // tutup dialog
                  Navigator.of(context).pop(); // kembali ke list
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Kembali",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openAssignMechanicSheet() async {
    final result = await showModalBottomSheet<MechanicModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AssignMechanicBottomSheet(),
    );
    if (result != null) {
      setState(() => _selectedMechanic = result);
    }
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: $_errorMessage'),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _loadEmergencyDetail,
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  )
                : _buildContent(context, _emergency!),
      ),
    );
  }

  Widget _buildContent(BuildContext context, EmergencyModel emergency) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          /// APP BAR
          const EmergencyAppBar(),

          const SizedBox(height: 20),

          /// MAIN CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// LABEL BADGE
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "PANGGILAN TOWING",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// TITLE
                Text(
                  "Engine Failure: ${emergency.plateNumber}",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                /// ADDRESS & TIME
                Text(
                  "Requested at ${emergency.createdAt} • ${emergency.location ?? 'Lokasi belum tersedia'}",
                  style: TextStyle(color: Colors.grey[700], fontSize: 15),
                ),

                const SizedBox(height: 24),

                /// TIMER
                const EmergencyTimerCard(),

                const SizedBox(height: 24),

                /// MAP
                EmergencyMapSection(mapController: mapController),

                const SizedBox(height: 24),

                /// CUSTOMER DETAILS
                EmergencyCustomerCard(
                  customerName: emergency.customerName,
                  vehicle: "${emergency.vehicleBrand} ${emergency.vehicleModel}",
                ),

                const SizedBox(height: 24),

                /// INITIAL REPORT
                EmergencyInitialReport(
                  description: emergency.description ?? "Tidak ada deskripsi keluhan yang diberikan",
                ),

                const SizedBox(height: 24),

                /// ASSIGN MECHANIC CARD
                _AssignMechanicCard(
                  selectedMechanic: _selectedMechanic,
                  onTap: _openAssignMechanicSheet,
                ),

                /// CONFIRM BUTTON — only visible when mechanic is selected
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _confirmAssignment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 22,
                          width: 45,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          "Konfirmasi",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Assign Mechanic Card Widget
// ─────────────────────────────────────────────
class _AssignMechanicCard extends StatelessWidget {
  final MechanicModel? selectedMechanic;
  final VoidCallback onTap;

  const _AssignMechanicCard({
    required this.selectedMechanic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selectedMechanic != null
                ? Colors.blue.withOpacity(0.5)
                : Colors.grey.shade200,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            /// ICON / AVATAR
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: selectedMechanic != null
                  ? const Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 28,
                    )
                  : const Icon(
                      Icons.engineering_outlined,
                      color: Colors.blue,
                      size: 28,
                    ),
            ),

            const SizedBox(width: 14),

            /// TEXT
            Expanded(
              child: selectedMechanic != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedMechanic!.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: selectedMechanic!.status.toLowerCase() == 'available' ? Colors.blue[50] : Colors.grey[200],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                selectedMechanic!.status.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: selectedMechanic!.status.toLowerCase() == 'available' ? Colors.blue : Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "No Mechanic Assigned",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          "Tap the button to browse available technicians",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
            ),

            const SizedBox(width: 10),

            /// PLUS BUTTON
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                selectedMechanic != null ? Icons.edit : Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
