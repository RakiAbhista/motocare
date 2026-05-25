import 'package:flutter/material.dart';
import 'package:motocare/features/cs/enums/service_status.dart';
import 'package:motocare/features/cs/home/screens/work_history_screen.dart';

import '../../widgets/profile_menu_card.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              /// HEADER BLUE SECTION
              Container(
                height: 260,
                width: double.infinity,

                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2D9CDB), Color(0xFF1C7ED6)],
                  ),
                  // 💡 TAMBAHKAN INI: Memberi lekukan hanya di bawah kiri dan kanan
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    // Makin besar angkanya, makin melengkung
                    bottomRight: Radius.circular(35),
                  ),
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// PROFILE IMAGE
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 3),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          "lib/features/cs/assets_dummy/person.jpeg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// PROFILE NAME
                    const Text(
                      "Joshua Jisoo",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// SUBTITLE
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Customer Service",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors
                                .white, // Ditambahkan biar teksnya kelihatan di atas gradient
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              /// CONTENT PROFILE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Administration",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    /// EDIT PROFILE
                    ProfileMenuCard(
                      icon: Icons.edit,
                      title: "Edit Profile",
                      iconColor: Colors.blue,
                      info: "Edit Profile Here",
                      onTap: () {},
                    ),

                    const SizedBox(height: 14),

                    /// Work History
                    ProfileMenuCard(
                      icon: Icons.history,
                      title: "Work History",
                      iconColor: Colors.blue,
                      info: "View Completed Service Log",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WorkHistoryScreen(
                              status: ServiceStatus.completed,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 14),

                    /// Work History
                    ProfileMenuCard(
                      icon: Icons.logout,
                      title: "Logout",
                      iconColor: Colors.red,
                      info: "End Current Session",
                      onTap: () {},
                    ),

                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
