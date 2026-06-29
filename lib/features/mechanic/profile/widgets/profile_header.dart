import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final VoidCallback? onEditPhone;
  final VoidCallback? onLogout;

  const ProfileHeader({
    super.key,
    required this.name,
    this.phoneNumber = '',
    this.onEditPhone,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(35),
              bottomRight: Radius.circular(35),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 15),
                /// PROFILE IMAGE WITH SHADOW
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const ClipOval(
                    child: Center(
                      child: Icon(
                        Icons.engineering_rounded,
                        size: 55,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                /// PROFILE NAME
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (phoneNumber.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  /// PHONE NUMBER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.phone,
                        size: 14,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        phoneNumber,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),

        /// DROPDOWN MENU - TOP RIGHT (titik tiga)
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
              if (value == 'edit_phone') {
                onEditPhone?.call();
              } else if (value == 'logout') {
                onLogout?.call();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit_phone',
                child: Row(
                  children: const [
                    Icon(Icons.phone_android_rounded, color: Colors.blue, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Ubah Nomor Telepon',
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
                      'Keluar',
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
