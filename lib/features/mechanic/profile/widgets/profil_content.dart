import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'profile_header.dart';
import 'work_status_card.dart';
import 'servis_selesai_card.dart';
import 'profile_menu_card.dart';
import '../screens/work_history_screen.dart';
import 'package:motocare/core/services/auth_service.dart';
import 'package:motocare/features/auth/login/screens/login_screen.dart';
import 'package:motocare/features/mechanic/profile/services/profile_service.dart';


class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  final ProfileService _profileService = ProfileService();


  bool _isLoading = true;
  String _nama = '';
  String _phoneNumber = '';
  bool _isOnline = false;
  int _totalServisSelesai = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);

    final result = await _profileService.getProfile();

    if (!mounted) return;

    if (result['success']) {
      final data = result['data'];
      setState(() {
        _nama = data['nama'] ?? '';
        _phoneNumber = data['nomor_telepon'] ?? '';
        _isOnline = data['status_kerja'] ?? false;
        _totalServisSelesai = data['total_servis_selesai'] ?? 0;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Gagal memuat profil'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _handleStatusChanged(bool value) async {
    final result = await _profileService.updateStatus(value);

    if (!mounted) return;

    if (result['success']) {
      setState(() => _isOnline = value);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            value
                ? 'Status Anda sekarang ONLINE. Siap menerima panggilan darurat & antrian!'
                : 'Status Anda sekarang OFFLINE. Anda tidak akan menerima panggilan baru.',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: value ? AppColors.success : AppColors.warning,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Gagal mengubah status'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          /// HEADER SECTION (with dropdown for edit phone + logout)
          ProfileHeader(
            name: _nama,
            phoneNumber: _phoneNumber,
            onEditPhone: () => _showEditPhoneDialog(context),
            onLogout: () => _showLogoutDialog(context),
          ),

          const SizedBox(height: 24),

          /// STATUS KERJA SECTION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: WorkStatusCard(
              initialStatus: _isOnline,
              onStatusChanged: _handleStatusChanged,
            ),
          ),

          const SizedBox(height: 16),

          /// SINGLE STAT SECTION (SERVIS SELESAI)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ServisSelesaiCard(count: '$_totalServisSelesai'),
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
                /// WORK HISTORY (kept as menu card)
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

                const SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditPhoneDialog(BuildContext context) {
    final TextEditingController phoneController =
        TextEditingController(text: _phoneNumber);

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
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                final newPhone = phoneController.text.trim();
                if (newPhone.isEmpty) return;

                Navigator.pop(context);

                final result = await _profileService.updatePhone(newPhone);

                if (!mounted) return;

                if (result['success']) {
                  setState(() => _phoneNumber = newPhone);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          result['message'] ?? 'Nomor telepon berhasil diperbarui'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppColors.success,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result['message'] ?? 'Gagal memperbarui nomor'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.red,
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

  void _showLogoutDialog(BuildContext pageContext) {
    showDialog(
      context: pageContext,
      builder: (dialogContext) {
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
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                if (pageContext.mounted) {
                  ScaffoldMessenger.of(pageContext).showSnackBar(
                    const SnackBar(content: Text('Memproses logout...')),
                  );
                }
                try {
                  final res = await AuthService().logout();
                  final msg = res['message'] ??
                      (res['success'] == true
                          ? 'Berhasil keluar dari akun.'
                          : 'Gagal logout');
                  if (pageContext.mounted) {
                    ScaffoldMessenger.of(pageContext).showSnackBar(SnackBar(
                      content: Text(msg),
                      backgroundColor:
                          res['success'] == true ? Colors.green : Colors.red,
                    ));
                  }
                } catch (e) {
                  if (pageContext.mounted) {
                    ScaffoldMessenger.of(pageContext).showSnackBar(SnackBar(
                      content: Text('Terjadi kesalahan saat logout: $e'),
                      backgroundColor: Colors.red,
                    ));
                  }
                }
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
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Keluar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}