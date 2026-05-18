import 'package:flutter/material.dart';
import '../../../../widgets/custom_top_bar.dart';
import '../widgets/emergency_bottom_nav.dart';
import '../widgets/emergency_active_alert.dart';

class MechanicEmergencyScreen extends StatelessWidget {
  const MechanicEmergencyScreen({super.key});

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

                  // Section - Emergency Alert
                  // Silakan uncomment salah satu widget di bawah ini
                  // untuk mengganti tampilan (kosong atau ada panggilan)

                  // Tampilan saat ada panggilan:
                  const EmergencyActiveAlert(),

                  // Tampilan saat kosong:
                  // const EmergencyEmptyAlert(),
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
}
