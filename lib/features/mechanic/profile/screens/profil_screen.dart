import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';
import '../widgets/profil_content.dart';
import '../widgets/profile_bottom_nav.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ProfileContent(),
      ),
      bottomNavigationBar: ProfileBottomNav(),
      extendBody: true,
    );
  }
}
