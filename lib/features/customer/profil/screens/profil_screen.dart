import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/core/theme/app_theme.dart';
import 'package:motocare/features/customer/kendaraan/screens/tambah_kendaraan_screen.dart';
import 'package:motocare/features/customer/kendaraan/widgets/detail_motor_bottom_sheet.dart';
import 'package:motocare/widgets/custom_card.dart';
import 'package:motocare/core/services/auth_service.dart';
import 'package:motocare/core/services/customer_home_service.dart';
import 'package:motocare/features/auth/login/screens/login_screen.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final _homeService = CustomerHomeService();
  Map<String, dynamic>? _homeData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> refresh() async {
    await _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await _homeService.getHomeData();
    if (mounted) {
      if (data['success'] == true && data['data'] != null) {
        setState(() {
          _homeData = data['data'];
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              child: Column(
                children: [
                  _ProfileHeader(
                    name: _homeData?['user_summary']?['name'] ?? 'Customer',
                    email: _homeData?['user_summary']?['email'] ?? '',
                    onEditProfile: () => _showEditPhoneDialog(context),
                    onLogout: () => _showLogoutDialog(context),
                  ),
                  const SizedBox(height: 28),
                  Padding(
                    padding: AppTheme.pagePaddingH,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _PointsCard(
                          points: _homeData?['user_summary']?['points'] ?? 0,
                          vouchers: _homeData?['user_summary']?['active_vouchers_count'] ??
                              _homeData?['user_summary']?['active_vouchers'] ?? 0,
                        ),
                        const SizedBox(height: 28),
                        _VehicleSection(
                          vehicles: List<Map<String, dynamic>>.from(
                            _homeData?['vehicles'] ?? [],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
    );
  }

  void _showEditPhoneDialog(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Ubah Nomor Telepon",
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: "Masukkan nomor telepon baru",
              prefixIcon: const Icon(Icons.phone),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                final newPhone = phoneController.text.trim();
                if (newPhone.isNotEmpty) {
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Nomor telepon diperbarui ke $newPhone"),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Simpan", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final pageContext = context;

    showDialog(
      context: pageContext,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Konfirmasi Keluar",
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text(
              "Apakah Anda yakin ingin keluar dari akun?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                showDialog(
                  context: pageContext,
                  barrierDismissible: false,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
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
              child: const Text("Keluar",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback? onEditProfile;
  final VoidCallback? onLogout;

  const _ProfileHeader({
    required this.name,
    this.email = '',
    this.onEditProfile,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 16, 20, 36),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(35),
              bottomRight: Radius.circular(35),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 30),
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
                    child: Icon(Icons.person, size: 60, color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (email.isNotEmpty) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    email,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ],
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
              if (value == 'edit_profile') {
                onEditProfile?.call();
              } else if (value == 'logout') {
                onLogout?.call();
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

class _PointsCard extends StatelessWidget {
  final int points;
  final int vouchers;

  const _PointsCard({this.points = 0, this.vouchers = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        color: AppColors.primary.withOpacity(0.05),
        border: Border.all(color: AppColors.primary.withOpacity(0.12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildPointItem(Icons.stars_rounded, '$points', 'Poin'),
            Container(height: 40, width: 1, color: AppColors.primary.withOpacity(0.15)),
            _buildPointItem(Icons.local_activity_rounded, '$vouchers', 'Voucher'),
          ],
        ),
      ),
    );
  }

  Widget _buildPointItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 28),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.primary.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _VehicleSection extends StatelessWidget {
  final List<Map<String, dynamic>> vehicles;

  const _VehicleSection({required this.vehicles});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.motorcycle, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text('Kendaraan Anda', style: AppTheme.titleLarge),
          ],
        ),
        const SizedBox(height: 16),
        if (vehicles.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text('Belum ada kendaraan terdaftar',
                  style: TextStyle(color: Colors.grey)),
            ),
          ),
        ...vehicles.map((vehicle) {
          final name = '${vehicle['brand'] ?? ''} ${vehicle['model'] ?? ''}'.trim();
          final plate = vehicle['plate_number'] ?? '-';
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _VehicleListItem(
              name: name.isNotEmpty ? name : 'Kendaraan',
              plate: plate,
              onTap: () => DetailMotorBottomSheet.show(context, vehicle: vehicle),
            ),
          );
        }),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Punya kendaraan lain?', style: AppTheme.titleMedium),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TambahKendaraanScreen()),
              ),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Tambah'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _VehicleListItem extends StatelessWidget {
  final String name;
  final String plate;
  final VoidCallback? onTap;

  const _VehicleListItem({
    required this.name,
    required this.plate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      accentColor: AppColors.primary,
      cutCorner: true,
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.motorcycle, size: 45, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTheme.titleLarge),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(plate, style: AppTheme.bodySmall.copyWith(color: AppColors.primary)),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.primary.withOpacity(0.4)),
            ),
            child: const Text('Detail'),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
