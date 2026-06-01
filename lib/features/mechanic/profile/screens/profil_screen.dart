import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/vehicle_list_section.dart';
import '../widgets/help_support_text.dart';
import '../widgets/profile_bottom_nav.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeaderWithOverlapCard(),
              VehicleSection(),
              HelpAndSupport(),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const ProfileBottomNav(),
      extendBody: true,
    );
  }
}
