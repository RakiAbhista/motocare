import 'package:flutter/material.dart';
import '../../../../widgets/custom_top_bar.dart';
import '../widgets/active_service_card.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/queue_item.dart';
import '../widgets/stats_grid.dart';
import '../widgets/order_detail_sheet.dart';
import 'view_all_queue_screen.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/core/services/mechanic_service.dart';

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
        fontFamily: 'Mulish',
      ),
      home: const MechanicDashboard(),
    );
  }
}

class MechanicDashboard extends StatefulWidget {
  const MechanicDashboard({super.key});

  @override
  State<MechanicDashboard> createState() => _MechanicDashboardState();
}

class _MechanicDashboardState extends State<MechanicDashboard> {
  bool _isLoading = true;
  Map<String, dynamic>? _dashboardData;
  Map<String, dynamic>? _activeOrder;
  List<dynamic> _queueList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    final response = await MechanicService().getDashboardData();
    if (response != null && response['status'] == 'success') {
      final data = response['data'] as Map<String, dynamic>? ?? {};
      final queue = data['incoming_queue'] as List? ?? [];
      
      Map<String, dynamic>? active;
      
      for (var item in queue) {
        if (item['status'] == 'process' || item['status'] == 'in progress') {
          active = Map<String, dynamic>.from(item);
        }
      }

      setState(() {
        _dashboardData = data;
        _activeOrder = active;
        _queueList = queue;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _fetchData,
        color: AppColors.primary,
        child: Column(
          children: [
            // 1. Header
            const CustomTopBar(),
            const SizedBox(height: 16),

            // 2. Main Content (Scrollable)
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Card Sedang Berlangsung (Active Order)
                          ActiveServiceCard(
                            activeOrder: _activeOrder,
                            onTap: _activeOrder == null
                                ? null
                                : () {
                                    OrderDetailSheet.show(
                                      context,
                                      _activeOrder!,
                                      onStatusUpdated: _fetchData,
                                    );
                                  },
                          ),
                          const SizedBox(height: 16),

                          // Bento Grid Stats
                          StatsGrid(stats: _dashboardData?['stats']),
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
                                  fontFamily: 'Mulish',
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewAllQueueScreen(
                                        queueList: _queueList,
                                        onRefresh: _fetchData,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'View All',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Mulish',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // --- List Antrian ---
                          if (_queueList.isEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.queue_outlined,
                                    size: 48,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Tidak ada antrian masuk',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Mulish',
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            ..._queueList.map((item) {
                              final vehicle = item['vehicle'] as Map<String, dynamic>? ?? {};
                              final brand = vehicle['brand'] ?? 'Honda';
                              final model = vehicle['model'] ?? 'Beat';
                              final year = vehicle['manufacturing_year'] ?? 2022;
                              final plate = vehicle['plate_number'] ?? 'B 1234 XYZ';
                              final customerName = item['customer_name'] ?? 'Pelanggan';
                              final status = (item['status'] ?? 'pending').toString().toUpperCase();
                              
                              Color statusBg = AppColors.primaryLight;
                              Color statusText = const Color(0xFF1E293B);
                              String buttonType = 'gradient';
                              String buttonLabel = 'Mulai';

                              if (status == 'PROCESS' || status == 'IN PROGRESS') {
                                statusBg = AppColors.warning.withOpacity(0.1);
                                statusText = AppColors.warning;
                                buttonType = 'grey';
                                buttonLabel = 'Detail';
                              } else if (status == 'COMPLETED' || status == 'SELESAI') {
                                statusBg = AppColors.success.withOpacity(0.1);
                                statusText = AppColors.success;
                                buttonType = 'grey';
                                buttonLabel = 'Selesai';
                              } else if (status == 'QUEUED') {
                                buttonType = 'more';
                                buttonLabel = '...';
                              }

                              return QueueItem(
                                name: customerName,
                                vehicle: '$brand $model ($year)',
                                plate: plate,
                                status: status,
                                statusBg: statusBg,
                                statusText: statusText,
                                buttonType: buttonType,
                                buttonLabel: buttonLabel,
                                fontFamily: 'Mulish',
                                onTap: () {
                                  OrderDetailSheet.show(
                                    context,
                                    Map<String, dynamic>.from(item),
                                    onStatusUpdated: _fetchData,
                                  );
                                },
                              );
                            }),

                          const SizedBox(
                            height: 100,
                          ), // Spacer agar tidak tertutup BottomNav
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(),
      extendBody: true,
    );
  }
}
