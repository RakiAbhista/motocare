import 'package:flutter/material.dart';
import 'package:motocare/features/cs/home/screens/payment_service_screen.dart';
import 'package:motocare/features/cs/widgets/complaint_card.dart';

import '../../enums/service_status.dart';
import '../../widgets/add_item_button.dart';
import '../../widgets/additional_service_chip.dart';
import '../../widgets/damage_photo_section.dart';
import '../../widgets/incoming_queue_section.dart';
import '../../widgets/line_item_card.dart';
import '../../widgets/service_summary_section.dart';
import '../../widgets/wehicle_card.dart';
import '../../widgets/notification_card.dart';
import 'package:motocare/core/theme/app_colors.dart';


class NotificationScreen extends StatelessWidget {

 NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// CUSTOM HEADER
            Container(
              height: 120,
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
                    "Notification",
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

             NotificationCard(
              title: "Pembayaran Berhasil",
              message: "Pembayaran untuk servis motor B 1234 XYZ telah diterima sebesar Rp 150.000.",
              time: "2m ago",
              isUnread: true,
              icon: Icons.check_circle_outline,
              iconColor: AppColors.success,
            ),
             NotificationCard(
              title: "Pekerjaan Selesai",
              message: "Mekanik telah menyelesaikan perbaikan untuk kendaraan AD 5678 JK.",
              time: "1h ago",
              isUnread: false,
              icon: Icons.build_circle_outlined,
              iconColor: AppColors.primary,
            ),
             NotificationCard(
              title: "Komplain Baru",
              message: "Pelanggan mengajukan komplain untuk servis kemaren. Mohon segera ditindaklanjuti.",
              time: "3h ago",
              isUnread: false,
              icon: Icons.warning_amber_rounded,
              iconColor: AppColors.danger,
            ),
            const SizedBox(height: 40),

          ],
        ),
      ),
    );
  }
}
