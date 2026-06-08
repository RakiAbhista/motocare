import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/core/services/auth_service.dart';
import 'profile_header.dart';
import 'work_status_card.dart';
import 'servis_selesai_card.dart';
import 'profile_menu_card.dart';
import '../screens/work_history_screen.dart';
import 'package:motocare/main.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  bool _isOnline = true;
  String _phoneNumber = "0812-3456-7890";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          /// HEADER SECTION
          const ProfileHeader(name: "Budi Setiawan"),

          const SizedBox(height: 24),

          /// STATUS KERJA SECTION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: WorkStatusCard(
              initialStatus: _isOnline,
              onStatusChanged: (value) {
                setState(() {
                  _isOnline = value;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _isOnline
                          ? "Status Anda sekarang ONLINE. Siap menerima panggilan darurat & antrian!"
                          : "Status Anda sekarang OFFLINE. Anda tidak akan menerima panggilan baru.",
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: _isOnline ? AppColors.success : AppColors.warning,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          /// SINGLE STAT SECTION (SERVIS SELESAI)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: ServisSelesaiCard(count: "148"),
          ),

          const SizedBox(height: 24),

          /// ADMINISTRATION / SETTINGS SECTION
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Administrasi & Akun",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                /// EDIT PROFILE
                ProfileMenuCard(
                  icon: Icons.phone_android_rounded,
                  title: "Ubah Nomor Telepon",
                  iconColor: Colors.blue,
                  info: _phoneNumber,
                  onTap: () {
                    _showEditPhoneDialog(context);
                  },
                ),

                const SizedBox(height: 12),

                /// WORK HISTORY
                ProfileMenuCard(
                  icon: Icons.history_rounded,
                  title: "Riwayat Pekerjaan",
                  iconColor: Colors.purple,
                  info: "Lihat log servis yang telah selesai",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MechanicWorkHistoryScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                /// LOG OUT
                ProfileMenuCard(
                  icon: Icons.logout_rounded,
                  title: "Keluar dari Akun",
                  iconColor: Colors.red,
                  info: "Akhiri sesi kerja saat ini",
                  onTap: () {
                    _showLogoutDialog(context);
                  },
                ),

                const SizedBox(height: 120), // Spacer agar tidak tertutup bottom nav
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditPhoneDialog(BuildContext context) {
    final TextEditingController phoneController = TextEditingController(text: _phoneNumber);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Ubah Nomor Telepon",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: "Masukkan nomor telepon baru",
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
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                final newPhone = phoneController.text.trim();
                if (newPhone.isNotEmpty) {
                  setState(() {
                    _phoneNumber = newPhone;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Nomor telepon berhasil diperbarui ke $newPhone"),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Simpan", style: TextStyle(color: Colors.white)),
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
        bool isLoggingOut = false;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                "Konfirmasi Keluar",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: const Text(
                "Apakah Anda yakin ingin keluar dan mengakhiri sesi kerja hari ini?",
              ),
              actions: [
                TextButton(
                  onPressed: isLoggingOut ? null : () {
                    Navigator.pop(context);
                  },
                  child: const Text("Batal", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: isLoggingOut
                      ? null
                      : () async {
                          setDialogState(() => isLoggingOut = true);

                          final result = await AuthService().logout();

                          if (!context.mounted) return;
                          Navigator.pop(context); // close dialog

                          // Navigate to login / role selection
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => const MyApp()),
                            (route) => false,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result['message'] ?? 'Berhasil keluar dari akun.'),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor:
                                  result['success'] == true ? AppColors.success : Colors.red,
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isLoggingOut
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Keluar",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
