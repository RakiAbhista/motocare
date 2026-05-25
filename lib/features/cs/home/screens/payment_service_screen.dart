import 'package:flutter/material.dart';

class PaymentServiceScreen extends StatelessWidget {
  const PaymentServiceScreen({super.key});

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
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),

              child: Row(
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
                      "Pembayaran",
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

            /// =========================
            /// CONTENT
            /// =========================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),

                child: Column(
                  children: [

                    /// ICON
                    Container(
                      width: 90,
                      height: 90,

                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(24),
                      ),

                      child: const Icon(
                        Icons.payments_outlined,
                        color: Colors.blue,
                        size: 48,
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// TITLE
                    const Text(
                      "Servis Sudah Selesai",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Silahkan selesaikan pembayaran",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// =========================
                    /// VEHICLE INFO
                    /// =========================
                    Align(
                      alignment: Alignment.centerLeft,

                      child: Text(
                        "Data Kendaraan",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FB),
                        borderRadius: BorderRadius.circular(22),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [

                          Text(
                            "Honda Beatrix",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 8),

                          Text(
                            "H 1945 AGS",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 35),

                    /// =========================
                    /// SERVICE SUMMARY
                    /// =========================
                    Align(
                      alignment: Alignment.centerLeft,

                      child: Text(
                        "Ringkasan Servis",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    buildItem(
                      title: "Ganti Oli Mesin",
                      subtitle: "Merk Oli",
                      price: "Rp. 60.000,-",
                    ),

                    const SizedBox(height: 20),

                    buildItem(
                      title: "Ganti Busi",
                      subtitle: "Merk Busi",
                      price: "Rp. 50.000,-",
                    ),

                    const SizedBox(height: 30),

                    const Divider(),

                    const SizedBox(height: 20),

                    buildPriceRow(
                      "Subtotal",
                      "Rp. 110.000,-",
                    ),

                    const SizedBox(height: 12),

                    buildPriceRow(
                      "Jasa",
                      "Rp. 50.000,-",
                    ),

                    const SizedBox(height: 25),

                    buildTotalRow(
                      "Total",
                      "Rp. 160.000,-",
                    ),

                    const SizedBox(height: 40),

                    /// =========================
                    /// BUTTON
                    /// =========================
                    SizedBox(
                      width: double.infinity,
                      height: 60,

                      child: ElevatedButton(
                        onPressed: () {

                          print("PAYMENT CONFIRMED");
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          elevation: 0,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),

                        child: const Text(
                          "Konfirmasi Pembayaran",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem({
    required String title,
    required String subtitle,
    required String price,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          width: 12,
          height: 12,

          margin: const EdgeInsets.only(top: 8),

          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),

        Text(
          price,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget buildPriceRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [

        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black87,
          ),
        ),

        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget buildTotalRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [

        Text(
          title,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(
          value,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}