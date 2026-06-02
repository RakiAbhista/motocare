import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/features/customer/home/screens/beranda_screen.dart';
import 'package:motocare/features/customer/home/screens/terdekat_screen.dart';
import 'package:motocare/features/customer/profil/screens/profil_screen.dart';
import 'package:motocare/features/customer/riwayat/screens/riwayat_screen.dart';

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
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildCurrentScreen(_currentIndex),
      bottomNavigationBar: _CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  Widget _buildCurrentScreen(int index) {
    switch (index) {
      case 0:
        return BerandaScreen(
          hasActiveBooking: widget.hasActiveBooking,
          daruratType: widget.daruratType,
        );
      case 1:
        return const RiwayatScreen();
      case 2:
        return const TerdekatScreen();
      case 3:
        return const ProfilScreen();
      default:
        return const BerandaScreen();
    }
  }
}

class _CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const _CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.home_rounded,
                label: 'Beranda',
                isSelected: currentIndex == 0,
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.receipt_long_rounded,
                label: 'Riwayat',
                isSelected: currentIndex == 1,
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.location_on_rounded,
                label: 'Terdekat',
                isSelected: currentIndex == 2,
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.person_outline_rounded,
                label: 'Profil',
                isSelected: currentIndex == 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 26,
            color: isSelected ? AppColors.primary : Colors.grey,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? AppColors.primary : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
