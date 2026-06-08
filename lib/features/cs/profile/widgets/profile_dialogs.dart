import 'package:flutter/material.dart';
import 'package:motocare/core/services/auth_service.dart';
import 'package:motocare/features/auth/login/screens/login_screen.dart';

import 'package:motocare/features/cs/profile/service/profile_service.dart';

/// Dialog untuk edit nomor telepon
void showEditPhoneDialog(BuildContext context) {
  final TextEditingController phoneController = TextEditingController();
  final pageContext = context;

  showDialog(
    context: pageContext,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Edit Phone Number",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: "Enter your phone number",
            prefixIcon: const Icon(Icons.phone),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              final newPhone = phoneController.text.trim();
              if (newPhone.isNotEmpty) {
                // Tampilkan loading dialog
                showDialog(
                  context: dialogContext,
                  barrierDismissible: false,
                  builder: (_) => const Center(child: CircularProgressIndicator()),
                );

                // Hit API
                final result = await ProfileService().updateProfile('Customer Service', newPhone);

                // Tutup loading
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }

                if (result['success']) {
                  // Tutup edit dialog
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                  if (pageContext.mounted) {
                    ScaffoldMessenger.of(pageContext).showSnackBar(
                      SnackBar(
                        content: Text("Phone number updated to $newPhone"),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } else {
                  // Tampilkan pesan error
                  if (pageContext.mounted) {
                    ScaffoldMessenger.of(pageContext).showSnackBar(
                      SnackBar(
                        content: Text(result['message'] ?? 'Gagal update phone number'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}

/// Dialog konfirmasi logout
void showLogoutDialog(BuildContext context) {
  final pageContext = context; // ← simpan sebelum masuk builder

  showDialog(
    context: pageContext,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Confirm Logout",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
            "Are you sure you want to end your current session?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext); // tutup confirm dialog

              // tampilkan loading
              showDialog(
                context: pageContext,
                barrierDismissible: false,
                builder: (_) => const Center(child: CircularProgressIndicator()),
              );

              try {
                await AuthService().logout();
              } catch (_) {}

              if (pageContext.mounted) {
                Navigator.of(pageContext).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}