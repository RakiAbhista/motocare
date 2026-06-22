import 'package:flutter/material.dart';
import 'package:motocare/features/cs/emergency/models/emergency_model.dart';
import '../screens/emergency_assignment_screen.dart';

class EmergencyCard extends StatelessWidget {
  final EmergencyModel emergency;
  final VoidCallback? onRefresh;

  const EmergencyCard({
    super.key,
    required this.emergency,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOngoing = emergency.mechanic != null && emergency.mechanic?.id != null;
    final Color cardColor = const Color(0xFFD31313);
    final Color badgeColor = isOngoing ? const Color(0xFF3564C4) : Colors.red[300]!;
    final String statusText = isOngoing ? "SEDANG BERJALAN: ${emergency.status.toUpperCase()}" : "BUTUH MEKANIK";
    final IconData bgIcon = isOngoing ? Icons.engineering : Icons.location_on;
    final String buttonText = isOngoing ? "Lihat Detail" : "Assign Mekanik";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
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
          Positioned(
            right: -10,
            top: -10,
            child: Icon(
              bgIcon,
              size: 90,
              color: isOngoing ? Colors.white.withOpacity(0.06) : const Color(0xFFE53935).withOpacity(0.3),
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
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText,
                  style: const TextStyle(
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

              /// MEKANIK INFO (IF ONGOING)
              if (isOngoing) ...[
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(
                      Icons.engineering_outlined,
                      color: Colors.white70,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Mekanik: ${emergency.mechanic?.name ?? '-'}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 20),

              /// ACTION BUTTON
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmergencyAssignmentScreen(emergencyId: emergency.id),
                    ),
                  );
                  if (result == true) {
                    onRefresh?.call();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(buttonText),
              ),
            ],
          ),
        ],
      ),
    );
  }
}