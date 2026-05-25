import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/emergency_card.dart';
import '../../widgets/header_section.dart';

class DaruratContent extends StatelessWidget {
  const DaruratContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: const [
              /// SEMUA ISI DASHBOARD KAMU
              HeaderSection(title: "Emergency Dashboard"),
              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Laporan darurat terbaru",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              SizedBox(height: 20),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: EmergencyCard(hasEmergency: true),
              ),

              SizedBox(height: 20),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: EmergencyCard(hasEmergency: false),
              ),


            ],
          ),
        ),
      ],
    );
  }
}
