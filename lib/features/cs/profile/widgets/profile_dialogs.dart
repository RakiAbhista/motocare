import 'package:flutter/material.dart';
import 'package:motocare/core/services/auth_service.dart';
import 'package:motocare/features/auth/login/screens/login_screen.dart';

/// Dialog untuk edit nomor telepon
void showEditPhoneDialog(BuildContext context) {
  final TextEditingController phoneController = TextEditingController();

  showDialog(
    context: context,
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
            onPressed: () {
              final newPhone = phoneController.text.trim();
              if (newPhone.isNotEmpty) {
                Navigator.pop(dialogContext);
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