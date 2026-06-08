import 'package:flutter/material.dart';
import 'package:motocare/features/cs/home/models/latest_order_model.dart';
import 'package:motocare/features/cs/home/widgets/queue_card.dart';
import '../../shared/enums/service_status.dart';
import '../screens/detail_service_screen.dart';

class IncomingQueueSection extends StatelessWidget {
  final List<LatestOrderModel> orders;
  final bool showCompletedOnly;

  const IncomingQueueSection({
    super.key,
    required this.orders,
    this.showCompletedOnly = false,
  });

  // Map status string dari API → ServiceStatus enum
  ServiceStatus _mapStatus(String status) {
    switch (status.toLowerCase()) {
      case 'in_progress':
        return ServiceStatus.inProgress;
      case 'completed':
        return ServiceStatus.completed;
      case 'pending':
      case 'waiting_payment':
      default:
        return ServiceStatus.waitingPayment;
    }
  }

  String _buttonText(ServiceStatus status) {
    switch (status) {
      case ServiceStatus.pending:
      case ServiceStatus.waitingPayment:
        return 'Pembayaran';
      case ServiceStatus.inProgress:
      case ServiceStatus.completed:
        return 'Detail';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = showCompletedOnly
        ? orders.where((o) => o.status == 'completed').toList()
        : orders;

    if (filtered.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Text('Tidak ada antrian saat ini'),
        ),
      );
    }

    return Column(
      children: List.generate(filtered.length, (index) {
        final order = filtered[index];
        final serviceStatus = _mapStatus(order.status);

        return Column(
          children: [
            QueueCard(
              customerName: order.customerName,
              vehicle: '${order.vehicleBrand} ${order.vehicleModel}',
              plate: order.plateNumber,
              status: serviceStatus,
              buttonText: _buttonText(serviceStatus),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailServiceScreen(
                      orderId: order.id,
                      status: serviceStatus,
                    ),
                  ),
                );
              },
            ),
            if (index < filtered.length - 1) const SizedBox(height: 14),
          ],
        );
      }),
    );
  }
}