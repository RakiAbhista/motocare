import 'package:flutter/material.dart';

import '../emergency/screens/emergency_assignment_screen.dart';

class EmergencyCard extends StatelessWidget {

  final bool hasEmergency;

  const EmergencyCard({
    super.key,
    required this.hasEmergency,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(

        color: hasEmergency
            ? const Color(0xFFD31313)
            : Colors.grey[300],

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
              Icons.location_on,
              size: 90,

              color: hasEmergency
                  ? Colors.red[400]
                  : Colors.grey[400],
            ),
          ),

          /// CONTENT
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// STATUS
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),

                decoration: BoxDecoration(
                  color: hasEmergency
                      ? Colors.red[300]
                      : Colors.grey[400],

                  borderRadius: BorderRadius.circular(20),
                ),

                child: Text(
                  hasEmergency
                      ? "PANGGILAN MEKANIK"
                      : "STATUS",

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// TITLE
              Text(
                hasEmergency
                    ? "MESIN MATI"
                    : "Tidak ada Panggilan Darurat",

                style: TextStyle(
                  color: hasEmergency
                      ? Colors.white
                      : Colors.white,

                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              /// DETAIL
              if (hasEmergency)
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Plat nomor: H 4 HA. Pengguna",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),

                    SizedBox(height: 6),

                    Text(
                      "Keluhan : Mesin mati secara tiba-tiba",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 20),

              /// BUTTON
              if (hasEmergency)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (context) =>
                        const EmergencyAssignmentScreen(),
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