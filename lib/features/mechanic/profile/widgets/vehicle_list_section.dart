import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';
// import 'package:motocare/features/customer/kendaraan/screens/tambah_kendaraan_screen.dart';
// import 'package:motocare/features/customer/kendaraan/widgets/detail_motor_bottom_sheet.dart';

class VehicleSection extends StatelessWidget {
  const VehicleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kendaraan anda',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          const VehicleListItem(name: 'Honda Beatrix', plate: 'H 1945 AGS'),
          const SizedBox(height: 16),
          const VehicleListItem(name: 'Honda Beatrix', plate: 'H 1945 AGS'),
          const SizedBox(height: 8),
          const AddVehicleButton(),
        ],
      ),
    );
  }
}

class VehicleListItem extends StatelessWidget {
  final String name;
  final String plate;

  const VehicleListItem({super.key, required this.name, required this.plate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.motorcycle, size: 50, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  plate,
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                ),
                const SizedBox(height: 8),
                const DetailButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailButton extends StatelessWidget {
  const DetailButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        // DetailMotorBottomSheet.show(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Detail Motor belum tersedia')),
        );
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.primary),
        minimumSize: const Size(80, 30),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text('Detail', style: TextStyle(color: AppColors.primary)),
    );
  }
}

class AddVehicleButton extends StatelessWidget {
  const AddVehicleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Punya kendaraan lain?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        OutlinedButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const TambahKendaraanScreen(),
            //   ),
            // );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fitur tambah kendaraan belum tersedia')),
            );
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Tambah',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
