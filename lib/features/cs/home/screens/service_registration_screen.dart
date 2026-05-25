import 'package:flutter/material.dart';
import 'package:motocare/features/cs/home/screens/confirmation_service_screen.dart';

class ServiceRegistrationScreen extends StatefulWidget {
  final bool isVehicleRegistered;

  final String plateNumber;

  const ServiceRegistrationScreen({
    super.key,
    required this.isVehicleRegistered,
    required this.plateNumber,
  });

  @override
  State<ServiceRegistrationScreen> createState() =>
      _ServiceRegistrationScreenState();
}

class _ServiceRegistrationScreenState extends State<ServiceRegistrationScreen> {
  final merkController = TextEditingController();

  final typeController = TextEditingController();

  final yearController = TextEditingController();

  final complaintController = TextEditingController();

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),

              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
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
            ),

            /// STEP
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: const [
                      Text(
                        "STEP 2 OF 3",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),

                      Text(
                        "SERVICE DETAILS",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Stack(
                    children: [
                      Container(
                        height: 6,

                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                      Container(
                        height: 6,
                        width: MediaQuery.of(context).size.width * 0.65,

                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: Column(
                  children: [
                    /// ===================================
                    /// REGISTERED VEHICLE
                    /// ===================================
                    if (widget.isVehicleRegistered)
                      buildRegisteredVehicleCard(),

                    /// ===================================
                    /// MANUAL INPUT VEHICLE
                    /// ===================================
                    if (!widget.isVehicleRegistered) buildManualVehicleForm(),

                    const SizedBox(height: 20),

                    /// SERVICE REQUIREMENT
                    buildServiceRequirement(),

                    const SizedBox(height: 30),

                    /// BUTTON
                    /// BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 58,

                      child: ElevatedButton(
                        onPressed: () {

                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (context) =>
                                  ConfirmationServiceScreen(

                                    plateNumber: widget.plateNumber,

                                    vehicleName: "NMAX 155",

                                    ownerName: "Aditama Pratama",

                                    complaint:
                                    complaintController.text,
                                  ),
                            ),
                          );

                          print("CONFIRM");
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          elevation: 0,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),

                        child: const Text(
                          "Confirm Registration",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
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

  /// ===================================
  /// REGISTERED VEHICLE CARD
  /// ===================================
  Widget buildRegisteredVehicleCard() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(24),

            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
            ],
          ),

          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: Text(
                        widget.plateNumber,

                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      "NMAX 155",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      "Owner: Aditama Pratama",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              ClipRRect(
                borderRadius: BorderRadius.circular(16),

                child: Image.asset(
                  "assets/images/motor.png",
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        /// VEHICLE SPECIFICATION
        buildVehicleSpecification(),
      ],
    );
  }

  /// ===================================
  /// MANUAL FORM
  /// ===================================
  Widget buildManualVehicleForm() {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FB),
        borderRadius: BorderRadius.circular(24),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              const Text(
                "VEHICLE SPECIFICATION",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),

                child: Text(
                  widget.plateNumber,

                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          buildInputField("MERK MOTOR", "contoh : Yamaha", merkController),

          const SizedBox(height: 16),

          buildInputField("TIPE MOTOR", "contoh : Aerox", typeController),

          const SizedBox(height: 16),

          buildInputField("TAHUN KELUARAN", "contoh : 2022", yearController),
        ],
      ),
    );
  }

  /// ===================================
  /// VEHICLE SPEC
  /// ===================================
  Widget buildVehicleSpecification() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FB),
        borderRadius: BorderRadius.circular(24),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            "VEHICLE SPECIFICATION",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 20),

          const Row(
            children: [
              Expanded(
                child: vehicleInfo(title: "BRAND", value: "Yamaha"),
              ),

              Expanded(
                child: vehicleInfo(title: "TYPE", value: "Scooter"),
              ),
            ],
          ),

          SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: vehicleInfo(title: "MODEL YEAR", value: "2022"),
              ),

              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,

                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 8),

                    const Text(
                      "Active",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ===================================
  /// SERVICE REQUIREMENT
  /// ===================================
  Widget buildServiceRequirement() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,

                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(16),
                ),

                child: const Icon(Icons.build, color: Colors.white),
              ),

              const SizedBox(width: 15),

              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "Service Requirements",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  Text(
                    "Describe the issues for our mechanic",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
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

          TextField(
            controller: complaintController,
            maxLines: 5,

            decoration: InputDecoration(
              hintText:
                  "Example: Squeaking sound from the rear brake and oil change...",

              filled: true,
              fillColor: const Color(0xFFF5F7FB),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),

                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ===================================
  /// INPUT FIELD
  /// ===================================
  Widget buildInputField(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          label,

          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,

          decoration: InputDecoration(
            hintText: hint,

            filled: true,
            fillColor: Colors.white,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),

              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

/// ===================================
/// SMALL INFO ITEM
/// ===================================
class vehicleInfo extends StatelessWidget {
  final String title;

  final String value;

  const vehicleInfo({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          title,

          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          value,

          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
