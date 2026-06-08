import 'package:flutter/material.dart';
import 'package:motocare/features/cs/emergency/models/emergency_model.dart';

import '../screens/emergency_assignment_screen.dart';

class EmergencyCard extends StatelessWidget {
  final EmergencyModel emergency;

  const EmergencyCard({
    super.key,
    required this.emergency,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFD31313),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          /// ICON BACKGROUND
          const Positioned(
            right: -10,
            top: -10,
            child: Icon(
              Icons.location_on,
              size: 90,
              color: Color(0xFFE53935),
            ),
          ),

          /// CONTENT
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// STATUS BADGE
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.red[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "PANGGILAN MEKANIK",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// CUSTOMER NAME
              Text(
                emergency.customerName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              /// VEHICLE INFO
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Kendaraan: ${emergency.vehicleBrand} ${emergency.vehicleModel}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Plat Nomor: ${emergency.plateNumber}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// DETAIL BUTTON
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmergencyAssignmentScreen(emergencyId: emergency.id),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Lihat Detail"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}