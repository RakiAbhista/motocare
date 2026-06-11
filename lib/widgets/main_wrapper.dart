import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/features/customer/home/screens/beranda_screen.dart';
import 'package:motocare/features/customer/home/screens/terdekat_screen.dart';
import 'package:motocare/features/customer/profil/screens/profil_screen.dart';
import 'package:motocare/features/customer/riwayat/screens/riwayat_screen.dart';
import 'package:motocare/features/customer/emergency/screens/panggilan_darurat_screen.dart';

class MainWrapper extends StatefulWidget {
  final bool hasActiveBooking;
  final String? daruratType;

  const MainWrapper({
    super.key,
    this.hasActiveBooking = false,
    this.daruratType,
  });

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;
  final GlobalKey _berandaKey = GlobalKey();
  final GlobalKey _riwayatKey = GlobalKey();
  final GlobalKey _terdekatKey = GlobalKey();
  final GlobalKey _profilKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          BerandaScreen(
            key: _berandaKey,
            hasActiveBooking: widget.hasActiveBooking,
            daruratType: widget.daruratType,
          ),
          RiwayatScreen(key: _riwayatKey),
          TerdekatScreen(key: _terdekatKey),
          ProfilScreen(key: _profilKey),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFEF4444),
        shape: const CircleBorder(),
        elevation: 4.0,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PanggilanDaruratScreen()),
          );
        },
        child: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 28),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        elevation: 8.0,
        child: SizedBox(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(icon: Icons.home, label: "Beranda", isActive: _selectedIndex == 0, index: 0),
              _buildNavItem(icon: Icons.receipt_long, label: "Riwayat", isActive: _selectedIndex == 1, index: 1),

              const SizedBox(width: 40),

              _buildNavItem(icon: Icons.location_on, label: "Terdekat", isActive: _selectedIndex == 2, index: 2),
              _buildNavItem(icon: Icons.person, label: "Profil", isActive: _selectedIndex == 3, index: 3),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // After first frame, trigger refresh on the initially selected page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        if (_selectedIndex == 0) (_berandaKey.currentState as dynamic)?.refresh();
        if (_selectedIndex == 1) (_riwayatKey.currentState as dynamic)?.refresh();
        if (_selectedIndex == 2) (_terdekatKey.currentState as dynamic)?.refresh();
        if (_selectedIndex == 3) (_profilKey.currentState as dynamic)?.refresh();
      } catch (_) {}
    });
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);
        // call refresh on the selected page (if available)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          try {
            if (index == 0) ( _berandaKey.currentState as dynamic)?.refresh();
            if (index == 1) ( _riwayatKey.currentState as dynamic)?.refresh();
            if (index == 2) ( _terdekatKey.currentState as dynamic)?.refresh();
            if (index == 3) ( _profilKey.currentState as dynamic)?.refresh();
          } catch (_) {}
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: isActive ? AppColors.primary : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? AppColors.primary : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
