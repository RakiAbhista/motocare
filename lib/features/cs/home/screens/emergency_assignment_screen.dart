import 'package:flutter/material.dart';

class EmergencyAssignmentScreen extends StatelessWidget {
  const EmergencyAssignmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              /// =========================
              /// HEADER
              /// =========================
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
                      "Emergency Assignment",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {},

                    icon: const Icon(
                      Icons.notifications_none,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// =========================
              /// MAIN CARD
              /// =========================
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    /// LABEL
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: const Text(
                        "PANGGILAN TOWING",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// TITLE
                    const Text(
                      "Engine Failure: BR-9902-XK",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// ADDRESS
                    Text(
                      "Requested at 14:20 PM • Jalan Raya Menteng, No. 42",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// TIMER CARD
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24),

                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF2196F3),
                            Color(0xFF42A5F5),
                          ],
                        ),

                        borderRadius: BorderRadius.circular(22),
                      ),

                      child: Column(
                        children: const [
                          Text(
                            "RESPONSETARGET",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          SizedBox(height: 6),

                          Text(
                            "15:00",
                            style: TextStyle(
                              fontSize: 44,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          SizedBox(height: 6),

                          Text(
                            "40 minutes remaining",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// LOCATION HEADER
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                      children: [
                        Text(
                          "LIVE LOCATION",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Row(
                          children: const [
                            Icon(
                              Icons.location_searching,
                              size: 14,
                              color: Colors.blue,
                            ),

                            SizedBox(width: 4),

                            Text(
                              "TRACKING LIVE",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    /// MAP
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),

                      child: Stack(
                        children: [
                          Image.asset(
                            "assets/images/map_dummy.png",
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                          ),

                          Positioned(
                            top: 14,
                            left: 14,

                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),

                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(14),
                              ),

                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.blue,
                                    size: 18,
                                  ),

                                  SizedBox(width: 6),

                                  Text(
                                    "Jalan Raya Menteng, No. 42, Central Jakarta",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// CUSTOMER DETAILS
                    Text(
                      "CUSTOMER DETAILS",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Container(
                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FB),
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Row(
                        children: [
                          /// IMAGE
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: AssetImage(
                              "assets/images/profile.jpg",
                            ),
                          ),

                          const SizedBox(width: 14),

                          /// TEXT
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: [
                                const Text(
                                  "Aditya Pratama",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  "Yamaha NMAX 250 • Matte Black",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Row(
                                  children: [
                                    Container(
                                      padding:
                                      const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),

                                      decoration: BoxDecoration(
                                        color: Colors.blue[100],
                                        borderRadius:
                                        BorderRadius.circular(8),
                                      ),

                                      child: const Text(
                                        "GOLD MEMBER",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 8),

                                    Container(
                                      padding:
                                      const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),

                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius:
                                        BorderRadius.circular(8),
                                      ),

                                      child: const Text(
                                        "6 TRIPS",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          /// CALL BUTTON
                          Container(
                            width: 44,
                            height: 44,

                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),

                            child: const Icon(
                              Icons.phone,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// INITIAL REPORT
                    Container(
                      width: double.infinity,

                      padding: const EdgeInsets.all(18),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),

                        border: Border.all(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),

                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [
                          Text(
                            "INITIAL REPORT",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            '"Engine stalled suddenly while riding at 40km/h. Smoke detected from the right side. Battery indicator was flickering earlier this morning."',
                            style: TextStyle(
                              height: 1.6,
                              color: Colors.grey[700],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    /// BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 58,

                      child: ElevatedButton(
                        onPressed: () {},

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          elevation: 0,

                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(18),
                          ),
                        ),

                        child: const Text(
                          "Konfirmasi",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}