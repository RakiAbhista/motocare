import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import '../widgets/assign_mechanic_bottom_sheet.dart';
import '../widgets/emergency_app_bar.dart';
import '../widgets/emergency_customer_card.dart';
import '../widgets/emergency_initial_report.dart';
import '../widgets/emergency_map_section.dart';
import '../widgets/emergency_timer_card.dart';

class EmergencyAssignmentScreen extends StatefulWidget {
  const EmergencyAssignmentScreen({super.key});

  @override
  State<EmergencyAssignmentScreen> createState() =>
      _EmergencyAssignmentScreenState();
}

class _EmergencyAssignmentScreenState
    extends State<EmergencyAssignmentScreen> {

  final MapController mapController = MapController(
    initPosition: GeoPoint(
      latitude: -7.052312315405609,
      longitude: 110.43440956674928,
    ),
  );

  MechanicModel? _selectedMechanic;

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
        child: SingleChildScrollView(
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
                    const Text(
                      "Engine Failure: BR-9902-XK",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// ADDRESS & TIME
                    Text(
                      "Requested at 14:20 PM • Jalan Raya Menteng, No. 42",
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
                    const EmergencyCustomerCard(),

                    const SizedBox(height: 24),

                    /// INITIAL REPORT
                    const EmergencyInitialReport(),

                    const SizedBox(height: 24),

                    /// ASSIGN MECHANIC CARD
                    _AssignMechanicCard(
                      selectedMechanic: _selectedMechanic,
                      onTap: _openAssignMechanicSheet,
                    ),

                    /// CONFIRM BUTTON — only visible when mechanic is selected
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: _selectedMechanic != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: SizedBox(
                                width: double.infinity,
                                height: 58,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  child: const Text(
                                    "Konfirmasi",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
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
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        selectedMechanic!.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.person,
                          color: Colors.blue,
                          size: 28,
                        ),
                      ),
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
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                "TERSEDIA",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.star,
                                size: 13, color: Colors.amber),
                            const SizedBox(width: 2),
                            Text(
                              selectedMechanic!.rating.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
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

