import 'package:flutter/material.dart';
import 'darurat_content.dart';

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

      /// ISI HALAMAN
      body: pages[currentIndex],

      /// NAVBAR
    );
  }
}