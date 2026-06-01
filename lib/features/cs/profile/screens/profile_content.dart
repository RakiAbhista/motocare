import 'package:flutter/material.dart';
import 'package:motocare/features/cs/enums/service_status.dart';
import 'package:motocare/features/cs/home/screens/work_history_screen.dart';

import '../../widgets/profile_menu_card.dart';
import '../widgets/profile_header.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              /// HEADER BLUE SECTION
              const ProfileHeader(),

              const SizedBox(height: 20),

              /// SECTION TITLE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Administration",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              /// MENU CARDS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
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
