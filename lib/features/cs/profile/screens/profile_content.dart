import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';
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

                decoration: BoxDecoration(
                  color: AppColors.primary,
                  // 💡 TAMBAHKAN INI: Memberi lekukan hanya di bawah kiri dan kanan
                  borderRadius: const BorderRadius.only(
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
              const SizedBox(height: 10),


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
                      onTap: () {
                        _showEditPhoneDialog(context);
                      },
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

                    /// Log Out
                    ProfileMenuCard(
                      icon: Icons.logout,
                      title: "Logout",
                      iconColor: Colors.red,
                      info: "End Current Session",
                      onTap: () {
                        _showLogoutDialog(context);
                      },
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

  void _showEditPhoneDialog(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Edit Phone Number",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: "Enter your phone number",
              prefixIcon: const Icon(Icons.phone),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                final newPhone = phoneController.text.trim();
                if (newPhone.isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Phone number updated to $newPhone"),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Confirm Logout",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Are you sure you want to end your current session?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Nanti logika proses logout (misal clear token & pindah halaman) taruh disini
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Logged out successfully"),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Logout", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
