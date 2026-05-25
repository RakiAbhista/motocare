import 'package:flutter/material.dart';

class VehicleCard extends StatelessWidget {
  final String vehicleName;
  final String ownerName;
  final String plateNumber;
  final String imagePath;

  const VehicleCard({
    super.key,
    required this.vehicleName,
    required this.ownerName,
    required this.plateNumber,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FF),
        borderRadius: BorderRadius.circular(24),
      ),

      child: Row(
        children: [
          /// IMAGE
          Container(
            width: 90,
            height: 90,

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),

            child: Padding(
              padding: const EdgeInsets.all(10),

              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(width: 16),

          /// INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  vehicleName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  ownerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  plateNumber,

                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
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