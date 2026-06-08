import 'package:flutter/material.dart';

import '../../shared/enums/service_status.dart';
import '../../home/widgets/incoming_queue_section.dart';
import '../../home/models/latest_order_model.dart';
import '../../home/service/order_service.dart';

class WorkHistoryScreen extends StatefulWidget {
  final ServiceStatus status;

  const WorkHistoryScreen({super.key, required this.status});

  @override
  State<WorkHistoryScreen> createState() => _WorkHistoryScreenState();
}

class _WorkHistoryScreenState extends State<WorkHistoryScreen> {
  final OrderService _orderService = OrderService();
  List<LatestOrderModel> _completedOrders = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _orderService.getOrders();

    if (result['success']) {
      try {
        final dataList = result['data'] as List<dynamic>;
        final allOrders = dataList
            .map((m) => LatestOrderModel.fromJson(m as Map<String, dynamic>))
            .toList();

        // Hanya tampil yang status nya completed aja
        final completed = allOrders.where((o) => o.status.toLowerCase() == 'completed').toList();

        setState(() {
          _completedOrders = completed;
          _isLoading = false;
        });
      } catch (e, stacktrace) {
        print('Parse Error: $e\n$stacktrace');
        setState(() {
          _errorMessage = 'Gagal memproses data: $e';
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _errorMessage = result['message'];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// CUSTOM HEADER
            Container(
              height: 160,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
              decoration: const BoxDecoration(color: Color(0xFFF0F7FF)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  /// BACK BUTTON
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.blue,
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  /// TITLE
                  const Text(
                    "Work History",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(40.0),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Center(
                  child: Column(
                    children: [
                      Text('Error: $_errorMessage'),
                      ElevatedButton(
                        onPressed: _loadOrders,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              )
            else
              IncomingQueueSection(
                orders: _completedOrders,
                showCompletedOnly: true,
              ),
          ],
        ),
      ),
    );
  }
}
