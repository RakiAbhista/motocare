import 'package:flutter/material.dart';
import 'package:motocare/features/cs/home/screens/darurat_content.dart';
import 'package:motocare/features/cs/home/screens/profile_content.dart';

import 'profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen  > {

  int currentIndex = 0;

  final List<Widget> pages = [
    const ProfileContent(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      /// ISI HALAMAN
      body: pages[currentIndex],

      /// NAVBAR
    );
  }
}