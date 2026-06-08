import 'package:flutter/material.dart';
import 'package:motocare/features/cs/home/screens/scanner_plate_screen.dart';
import 'package:motocare/features/cs/shared/widgets/header_section.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/features/cs/home/models/latest_order_model.dart';
import 'package:motocare/features/cs/home/service/dashboard_service.dart';

import '../../home/widgets/incoming_queue_section.dart';
import '../../home/widgets/welcome_card.dart';
import '../../home/widgets/workflow_section.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final DashboardService _dashboardService = DashboardService();

  List<LatestOrderModel> _latestOrders = [];
  bool _isLoading = true;
  String? _errorMessage;

  String _csName = 'Loading...';
  int _totalOrder = 0;
  int _totalCompleted = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final data = await _dashboardService.getDashboard();

    if (!mounted) return;

    if (data['success'] == true) {
      final rawList = data['latest_orders'] as List<dynamic>;
      final statistics = data['statistics'] as Map<String, dynamic>? ?? {};
      setState(() {
        _csName = data['cs_name'] ?? 'Customer Service';
        _totalOrder = (statistics['total_orders'] as num?)?.toInt() ?? 0;
        _totalCompleted = (statistics['completed_repairs'] as num?)?.toInt() ?? 0;
        _latestOrders = rawList
            .map((item) => LatestOrderModel.fromJson(item as Map<String, dynamic>))
            .toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = data['message'] ?? 'Terjadi kesalahan';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderSection(title: "Service Dashboard"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    WelcomeCard(
                      csName: _csName,
                      totalOrder: _totalOrder,
                      totalCompleted: _totalCompleted,
                    ),
                    const SizedBox(height: 20),
                    const WorkflowSection(),
                    const SizedBox(height: 20),

                    /// HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Incoming Queue",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // TODO: navigate ke halaman all queue
                          },
                          child: const Text(
                            "View All",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// QUEUE CONTENT
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_errorMessage != null)
                      Column(
                        children: [
                          Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                          TextButton(
                            onPressed: _loadDashboardData,
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      )
                    else
                      IncomingQueueSection(orders: _latestOrders),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),

        /// Floating Button
        Positioned(
          bottom: 80,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ScannerPlateScreen()),
              );
            },
            backgroundColor: AppColors.secondary,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}