import 'package:flutter/material.dart';
import 'package:motocare/features/customer/kendaraan/screens/tambah_kendaraan_screen.dart';
import 'package:motocare/features/customer/kendaraan/widgets/detail_motor_bottom_sheet.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              _HeaderWithOverlapCard(),
              _VehicleSection(),
              _HelpAndSupport(),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderWithOverlapCard extends StatelessWidget {
  const _HeaderWithOverlapCard();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        const _ProfileHeader(),
        const _PointsAndVoucherCard(),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 260,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue, Color(0xFF29B6F6)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const Icon(
              Icons.person,
              size: 70,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'John Doe',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _PointsAndVoucherCard extends StatelessWidget {
  const _PointsAndVoucherCard();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -25,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const _PointsSection(),
            Container(
              height: 30,
              width: 2,
              color: Colors.grey.shade200,
            ),
            const _VoucherSection(),
          ],
        ),
      ),
    );
  }
}

class _PointsSection extends StatelessWidget {
  const _PointsSection();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.star, color: Colors.blue, size: 30),
        SizedBox(width: 8),
        Text(
          '36 Points',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class _VoucherSection extends StatelessWidget {
  const _VoucherSection();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.local_activity, color: Colors.blue, size: 30),
        SizedBox(width: 8),
        Text(
          '2 Voucher',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class _VehicleSection extends StatelessWidget {
  const _VehicleSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kendaraan anda',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          const _VehicleListItem(
            name: 'Honda Beatrix',
            plate: 'H 1945 AGS',
          ),
          const SizedBox(height: 16),
          const _VehicleListItem(
            name: 'Honda Beatrix',
            plate: 'H 1945 AGS',
          ),
          const SizedBox(height: 8),
          _AddVehicleButton(),
        ],
      ),
    );
  }
}

class _VehicleListItem extends StatelessWidget {
  final String name;
  final String plate;

  const _VehicleListItem({required this.name, required this.plate});

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
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.motorcycle,
              size: 50,
              color: Colors.grey,
            ),
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
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                _DetailButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailButton extends StatelessWidget {
  const _DetailButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => DetailMotorBottomSheet.show(context),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.blue),
        minimumSize: const Size(80, 30),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Detail',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}

class _AddVehicleButton extends StatelessWidget {
  const _AddVehicleButton();

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
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahKendaraanScreen()),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.blue),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Tambah',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _HelpAndSupport extends StatelessWidget {
  const _HelpAndSupport();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Center(
        child: RichText(
          text: const TextSpan(
            text: 'Butuh Bantuan? ',
            style: TextStyle(color: Colors.grey, fontSize: 12),
            children: const [
              TextSpan(
                text: 'Klik Disini!',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
