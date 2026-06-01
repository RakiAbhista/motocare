import 'package:flutter/material.dart';
import '../../home/widgets/wehicle_card.dart';

class ConfirmationServiceScreen extends StatelessWidget {

  final String plateNumber;

  final String vehicleName;

  final String ownerName;

  final String complaint;

  const ConfirmationServiceScreen({
    super.key,
    required this.plateNumber,
    required this.vehicleName,
    required this.ownerName,
    required this.complaint,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            /// =========================
            /// HEADER
            /// =========================
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(20),

              decoration: const BoxDecoration(
                color: Color(0xFFF3F8FF),
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Row(
                    children: [

                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },

                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.blue,
                        ),
                      ),

                      const Expanded(
                        child: Text(
                          "Offline Registration",
                          textAlign: TextAlign.center,

                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(width: 40),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "STEP 3 OF 3",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Stack(
                    children: [

                      Container(
                        height: 6,

                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius:
                          BorderRadius.circular(20),
                        ),
                      ),

                      Container(
                        height: 6,
                        width:
                        MediaQuery.of(context).size.width,

                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius:
                          BorderRadius.circular(20),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Confirm Registration",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Review all registration details before submitting.",
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

            /// =========================
            /// CONTENT
            /// =========================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [

                    /// VEHICLE CARD
                    VehicleCard(
                      vehicleName: vehicleName,
                      ownerName: ownerName,
                      plateNumber: plateNumber,
                      imagePath: "assets/images/motor.png",
                    ),

                    const SizedBox(height: 20),

                    /// SERVICE SUMMARY
                    Container(
                      width: double.infinity,

                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FB),

                        borderRadius:
                        BorderRadius.circular(24),
                      ),

                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          const Row(
                            children: [

                              Icon(
                                Icons.build_circle,
                                color: Colors.blue,
                              ),

                              SizedBox(width: 10),

                              Text(
                                "Service Summary",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 25),

                          buildInfoRow(
                            "Service Type",
                            "General Service",
                          ),

                          const SizedBox(height: 18),

                          buildInfoRow(
                            "Estimated Duration",
                            "45 Minutes",
                          ),

                          const SizedBox(height: 18),

                          buildInfoRow(
                            "Estimated Cost",
                            "Rp 150.000",
                          ),

                          const SizedBox(height: 25),

                          const Text(
                            "CUSTOMER COMPLAINT",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Container(
                            width: double.infinity,

                            padding: const EdgeInsets.all(18),

                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(18),
                            ),

                            child: Text(
                              complaint,
                              style: const TextStyle(
                                fontSize: 15,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// BUTTONS
                    Row(
                      children: [

                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },

                            style: OutlinedButton.styleFrom(
                              minimumSize:
                              const Size(0, 58),

                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(18),
                              ),
                            ),

                            child: const Text(
                              "Edit",
                              style: TextStyle(
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          flex: 2,

                          child: ElevatedButton(
                            onPressed: () {

                              print("SUBMIT");

                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,

                              minimumSize:
                              const Size(0, 58),

                              elevation: 0,

                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(18),
                              ),
                            ),

                            child: const Text(
                              "Register Service",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(
      String title,
      String value,
      ) {

    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,

      children: [

        Text(
          title,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 15,
          ),
        ),

        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
