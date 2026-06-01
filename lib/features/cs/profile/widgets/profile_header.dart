import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';

import 'profile_dialogs.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// BLUE BACKGROUND CONTAINER
        Container(
          height: 260,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(35),
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
                    "lib/features/cs/shared/assets_dummy/person.jpeg",
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

              /// ROLE / SUBTITLE
              const Text(
                "Customer Service",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              /// PHONE NUMBER
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.phone,
                    size: 14,
                    color: Colors.white70,
                  ),
                  SizedBox(width: 5),
                  Text(
                    "+62 812-3456-7890",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        /// SETTINGS BUTTON - TOP RIGHT (titik tiga)
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          right: 12,
          child: PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
              size: 28,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.white,
            elevation: 8,
            offset: const Offset(0, 45),
            onSelected: (value) {
              if (value == 'edit_profile') {
                showEditPhoneDialog(context);
              } else if (value == 'logout') {
                showLogoutDialog(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit_profile',
                child: Row(
                  children: const [
                    Icon(Icons.edit, color: Colors.blue, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: const [
                    Icon(Icons.logout, color: Colors.red, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
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
