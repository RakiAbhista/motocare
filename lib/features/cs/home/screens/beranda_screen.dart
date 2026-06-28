import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';

import 'beranda_content.dart';
import '../../emergency/screens/darurat_screen.dart';
import '../../profile/screens/profile_screen.dart';
import 'package:motocare/features/cs/home/screens/scanner_plate_screen.dart';

class BerandaScreen extends StatefulWidget {
  final int initialIndex;
  const BerandaScreen({super.key, this.initialIndex = 0});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  final List<Widget> pages = [
    const HomeContent(),
    const DaruratScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      /// ISI HALAMAN
      body: pages[currentIndex],

      /// Pindahkan FAB ke sini agar tidak terhalang batas body
      floatingActionButton: currentIndex == 0 ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ScannerPlateScreen()),
          );
        },
        backgroundColor: AppColors.secondary,
        child: const Icon(Icons.add, color: Colors.white),
      ) : null,

      /// NAVBAR - Custom Container matching mechanic style
      bottomNavigationBar: Container(
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
            _navItem(Icons.home_filled, 'Beranda', 0),
            _navItem(Icons.report_gmailerrorred_rounded, 'Darurat', 1),
            _navItem(Icons.person, 'Profil', 2),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isSelected = currentIndex == index;
    final color = isSelected ? AppColors.primary : const Color(0xFFC3C7CC);
    return GestureDetector(
      onTap: () => setState(() => currentIndex = index),
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
