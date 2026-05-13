import 'package:flutter/material.dart';
import '../../emergency/screens/emergency_screen.dart';
import '../../profile/profil.dart';
import 'package:motocare/core/theme/app_colors.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home_filled, 'Beranda', isSelected: true),
          _navItem(Icons.report_gmailerrorred_rounded, 'Darurat', onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MechanicEmergencyScreen(),
              ),
            );
          }),
          _navItem(Icons.person, 'Profil', onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfilScreen(),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, {bool isSelected = false, VoidCallback? onTap}) {
    final color = isSelected
        ? AppColors.primary
        : const Color(0xFFC3C7CC);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
