import 'package:flutter/material.dart';
import '../../../../widgets/custom_top_bar.dart';
import '../widgets/active_service_card.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/queue_item.dart';
import '../widgets/stats_grid.dart';
import 'view_all_queue_screen.dart';
import 'package:motocare/core/theme/app_colors.dart';

void main() {
  runApp(const MotoCareApp());
}

class MotoCareApp extends StatelessWidget {
  const MotoCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MotoCare Mechanic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Default font diset ke Mulish, pastikan sudah ditambahkan di pubspec.yaml
        fontFamily: 'Mulish',
      ),
      home: const MechanicDashboard(),
    );
  }
}

class MechanicDashboard extends StatelessWidget {
  const MechanicDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // 1. Header
          const CustomTopBar(),
          const SizedBox(height: 16),

          // 2. Main Content (Scrollable)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card Sedang Berlangsung
                  const ActiveServiceCard(),
                  const SizedBox(height: 16),

                  // Bento Grid Stats
                  const StatsGrid(),
                  const SizedBox(height: 24),

                  // Heading Incoming Queue
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Incoming Queue',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ViewAllQueueScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // --- List Antrian ---

                  // Item 1
                  const QueueItem(
                    name: 'Ahmad Subagyo',
                    vehicle: 'Honda Beat (2022)',
                    plate: 'B 1234 XYZ',
                    status: 'WAITING',
                    statusBg: AppColors.primaryLight,
                    statusText: Color(0xFF1E293B),
                    buttonType: 'gradient',
                    buttonLabel: 'Mulai',
                    fontFamily: 'Mulish',
                  ),

                  // Item 2
                  const QueueItem(
                    name: 'Siti Aminah',
                    vehicle: 'Vespa Sprint S',
                    plate: 'AD 5678 JK',
                    status: 'IN PROGRESS',
                    statusBg: AppColors.primaryLight,
                    statusText: Color(0xFF1E293B),
                    buttonType: 'grey',
                    buttonLabel: 'Detail',
                    fontFamily: 'Mulish',
                  ),

                  // Item 3
                  const QueueItem(
                    name: 'Customer 3',
                    vehicle: 'Kawasaki Ninja',
                    plate: 'AD 1234 JK',
                    status: 'QUEUED',
                    statusBg: AppColors.primaryLight,
                    statusText: Color(0xFF1E293B),
                    buttonType: 'detail',
                    buttonLabel: '...',
                    fontFamily: 'Plus Jakarta Sans',
                  ),

                  const SizedBox(
                    height: 100,
                  ), // Spacer agar tidak tertutup BottomNav
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(),
      extendBody:
          true, // Agar konten bisa scroll di bawah navigasi yang melengkung
    );
  }
}
