import 'package:flutter/material.dart';
import 'package:motocare/features/cs/home/screens/payment_service_screen.dart';
import 'package:motocare/features/cs/home/widgets/complaint_card.dart';

import '../../shared/enums/service_status.dart';
import '../../home/widgets/add_item_bottom_sheet.dart';
import '../../home/widgets/add_item_button.dart';
import '../../home/widgets/additional_service_chip.dart';
import '../../home/widgets/damage_photo_section.dart';
import '../../home/widgets/line_item_card.dart';
import '../../home/widgets/service_summary_section.dart';
import '../../home/widgets/wehicle_card.dart';

class DetailServiceScreen extends StatelessWidget {
  final ServiceStatus status;

  const DetailServiceScreen({super.key, required this.status});

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
                    "Service Detail",
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

            /// CONTENT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  "Service ID",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w200),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  "Job ID #MC-9021",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: VehicleCard(
                vehicleName: 'HonadBeatrx',
                ownerName: 'Siti Aminah',
                plateNumber: 'B 1234 XYZ',
                imagePath: "lib/features/cs/shared/assets_dummy/motorcycle_1.jpg",

              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  "Keluhan",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: Column(
                children: [
                  /// USER COMPLAIN SECTION
                  ComplaintCard(
                    icon: Icons.warning,
                    title: "Servis Rutin",
                    iconColor: Colors.red,
                    info:
                        "Motor mengalami brebet saat hendak di nyalakan, dan harus menunggu selama 5 menit sampai mesin stabil",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: DamagePhotoSection(
                imagePaths: [
                  'lib/features/cs/shared/assets_dummy/damage1.jpeg',
                  'lib/features/cs/shared/assets_dummy/damage2.jpg',
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  "Tambahan Service",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: Align(
                alignment: Alignment.centerLeft,

                child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 12,
                  runSpacing: 12,

                  children: [
                    AdditionalServiceChip(title: 'Ganti Busi'),

                    AdditionalServiceChip(title: 'Ganti Oli'),

                    AdditionalServiceChip(title: 'Ganti Part'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  const Text(
                    "Line Items",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  if (status == ServiceStatus.inProgress)
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) =>  AddItemBottomSheet(),
                        );
                      },
                      icon: const Icon(Icons.add, color: Colors.black, size: 28),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // if (status == ServiceStatus.inProgress) ...[
            //   Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 20),

            //     child: AddItemButton(
            //       onPressed: () {
            //         print("ADD ITEM");
            //       },
            //     ),
            //   ),

            //   const SizedBox(height: 20),
            // ],

            ///Items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: Column(
                children: [
                  LineItemCard(
                    itemName: 'Ganti Oli Mesin',
                    quantity: 1,
                    price: 75000,
                  ),

                  const SizedBox(height: 14),

                  LineItemCard(itemName: 'Busi NGK', quantity: 2, price: 25000),
                ],
              ),
            ),

            const SizedBox(height: 30),

            ServiceSummarySection(subtotal: 270000, taxPercent: 11),

            if (status == ServiceStatus.waitingPayment)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                /// PROCEED PAYMENT
                child: SizedBox(
                  width: double.infinity,
                  height: 58,

                  child: ElevatedButton(
                    onPressed: () {

                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) => const PaymentServiceScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,

                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    child: const Text(
                      "Proceed Payment",

                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 30),

            if (status == ServiceStatus.inProgress)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: SizedBox(
                  width: double.infinity,
                  height: 58,

                  child: ElevatedButton(
                    onPressed: () {

                      /// TODO:
                      /// CHANGE STATUS TO WAITING PAYMENT

                      print("FINALIZE SERVICE");
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    child: const Text(
                      "Finalize Service",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),



            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
