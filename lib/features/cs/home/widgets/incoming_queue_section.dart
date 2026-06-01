import 'package:flutter/material.dart';
import 'package:motocare/features/cs/home/widgets/queue_card.dart';

import '../../shared/enums/service_status.dart';
import '../screens/detail_service_screen.dart';

class IncomingQueueSection extends StatelessWidget {
  final bool showCompletedOnly;

  const IncomingQueueSection({
    super.key,
    this.showCompletedOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        /// WAITING PAYMENT
        if (!showCompletedOnly)
          QueueCard(
            customerName: "Ahmad Subagyo",
            vehicle: "Honda Beat (2022)",
            plate: "B 1234 XYZ",
            status: ServiceStatus.waitingPayment,
            buttonText: "Pembayaran",
              imagePath: "lib/features/cs/shared/assets_dummy/motorcycle_1.jpg",
            onTap: () {
              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (_) => const DetailServiceScreen(
                    status: ServiceStatus.waitingPayment,
                  ),
                ),
              );
            },
          ),

        if (!showCompletedOnly)
          const SizedBox(height: 14),

        /// IN PROGRESS
        if (!showCompletedOnly)
          QueueCard(
            customerName: "Siti Aminah",
            vehicle: "Vespa Sprint S",
            plate: "AD 5678 JK",
            status: ServiceStatus.inProgress,
            buttonText: "Detail",
            imagePath: "lib/features/cs/shared/assets_dummy/motorcycle_2.png",


            onTap: () {
              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (_) => const DetailServiceScreen(
                    status: ServiceStatus.inProgress,
                  ),
                ),
              );
            },
          ),

        if (!showCompletedOnly)
          const SizedBox(height: 14),

        /// COMPLETED
        QueueCard(
          customerName: "Rian Hidayat",
          vehicle: "Honda CBR 150R",
          plate: "L 9901 QR",
          status: ServiceStatus.completed,
          buttonText: "Detail",
          imagePath: "lib/features/cs/shared/assets_dummy/motorcycle_3.jpg",


          onTap: () {
            Navigator.push(
              context,

              MaterialPageRoute(
                builder: (_) => const DetailServiceScreen(
                  status: ServiceStatus.completed,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
