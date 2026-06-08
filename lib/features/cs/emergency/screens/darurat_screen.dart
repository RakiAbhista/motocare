import 'package:flutter/material.dart';
import 'darurat_content.dart';
import 'package:motocare/core/theme/app_colors.dart';


class DaruratScreen extends StatefulWidget {
  const DaruratScreen({super.key});

  @override
  State<DaruratScreen> createState() => _DaruratScreen();
}

class _DaruratScreen extends State<DaruratScreen  > {

  int currentIndex = 0;

  final List<Widget> pages = [
    const DaruratContent(),
    const DaruratScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,


      /// ISI HALAMAN
      body: pages[currentIndex],

      /// NAVBAR
    );
  }
}