import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motocare/features/cs/home/screens/scanner_plate_screen.dart';
import 'package:motocare/features/cs/widgets/header_section.dart';

import '../../widgets/incoming_queue_section.dart';
import '../../widgets/welcome_card.dart';
import '../../widgets/workflow_section.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HeaderSection ditaruh di luar Padding (Bisa full width)
              const HeaderSection(title: "Service Dashboard"),

              // 2. Bungkus sisa kontennya dengan Padding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 20),
                    WelcomeCard(),
                    SizedBox(height: 20),
                    WorkflowSection(),
                    SizedBox(height: 20),
                    /// HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Incoming Queue",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          "View All",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    IncomingQueueSection(),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),

        /// Floating Button
        Positioned(
          bottom: 80,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ScannerPlateScreen()),
              );
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
