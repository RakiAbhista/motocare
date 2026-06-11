import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';

class InvoiceVehicleDetails extends StatelessWidget {
  final String vehicleBrand;
  final String plateNumber;
  final String vehicleType;
  final String vehicleModel;

  const InvoiceVehicleDetails({
    super.key,
    this.vehicleBrand = '',
    this.plateNumber = '',
    this.vehicleType = '',
    this.vehicleModel = '',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('VEHICLE', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF434652))),
                const SizedBox(height: 4),
                Text(vehicleBrand.isNotEmpty ? '$vehicleBrand ${vehicleModel.isNotEmpty ? vehicleModel : ''}' : '-', style: const TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF181C20))),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('PLATE NUMBER', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF434652))),
                const SizedBox(height: 4),
                Text(plateNumber.isNotEmpty ? plateNumber : '-', style: const TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF181C20))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
