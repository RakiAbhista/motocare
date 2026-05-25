import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';

import 'beranda_content.dart';
import '../../emergency/screens/darurat_screen.dart';
import '../../profile/screens/profile_screen.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {

  int currentIndex = 0;

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

      /// NAVBAR
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Beranda",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: "Darurat",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}