import 'package:flutter/material.dart';
import 'package:motocare/features/cs/home/screens/payment_service_screen.dart';
import 'package:motocare/features/cs/home/widgets/complaint_card.dart';

import '../../shared/enums/service_status.dart';
import '../../home/widgets/add_item_button.dart';
import '../../home/widgets/additional_service_chip.dart';
import '../../home/widgets/damage_photo_section.dart';
import '../../home/widgets/incoming_queue_section.dart';
import '../../home/widgets/line_item_card.dart';
import '../../home/widgets/service_summary_section.dart';
import '../../home/widgets/wehicle_card.dart';

class WorkHistoryScreen extends StatelessWidget {
  final ServiceStatus status;

  const WorkHistoryScreen({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Column(
          children: [
            /// CUSTOM HEADER
            Container(
              height: 160,
              width: double.infinity,

              padding: const EdgeInsets.only(top: 50, left: 20, right: 20),

              decoration: const BoxDecoration(color: Color(0xFFF0F7FF)),

              child: Stack(
                alignment: Alignment.center,

                children: [
                  /// BACK BUTTON
                  Align(
                    alignment: Alignment.centerLeft,

                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },

                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.blue,
                        size: 32,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// TITLE
                  const Text(
                    "Work History",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            IncomingQueueSection(showCompletedOnly: true),

          ],
        ),
      ),
    );
  }
}
