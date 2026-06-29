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
  final int initialIndex;

  const MainWrapper({
    super.key,
    this.hasActiveBooking = false,
    this.daruratType,
    this.initialIndex = 0,
  });

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  late int _selectedIndex;
  final GlobalKey _berandaKey = GlobalKey();
  final GlobalKey _riwayatKey = GlobalKey();
  final GlobalKey _terdekatKey = GlobalKey();
  final GlobalKey _profilKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    // After first frame, trigger refresh on the initially selected page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshPage(_selectedIndex);
    });
  }

  void _refreshPage(int index) {
    try {
      if (index == 0) (_berandaKey.currentState as dynamic)?.refresh();
      if (index == 1) (_riwayatKey.currentState as dynamic)?.refresh();
      if (index == 2) (_terdekatKey.currentState as dynamic)?.refresh();
      if (index == 3) (_profilKey.currentState as dynamic)?.refresh();
    } catch (_) {}
  }

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
            _navItem(Icons.receipt_long, 'Riwayat', 1),
            _buildDaruratButton(),
            _navItem(Icons.location_on, 'Terdekat', 2),
            _navItem(Icons.person, 'Profil', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildDaruratButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PanggilanDaruratScreen(),
          ),
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFEF4444).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.report_gmailerrorred_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Darurat',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFFEF4444),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? AppColors.primary : const Color(0xFFC3C7CC);
    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _refreshPage(index);
        });
      },
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
