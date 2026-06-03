import 'package:flutter/material.dart';
import '../widgets/queue_item.dart';
import '../widgets/order_detail_sheet.dart';
import 'package:motocare/core/theme/app_colors.dart';

class ViewAllQueueScreen extends StatelessWidget {
  final List<dynamic> queueList;
  final VoidCallback? onRefresh;

  const ViewAllQueueScreen({
    super.key,
    required this.queueList,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Daftar Semua Antrian',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'Mulish',
          ),
        ),
        centerTitle: true,
      ),
      body: queueList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.queue_outlined,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Tidak ada antrian masuk',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Mulish',
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: queueList.length,
              itemBuilder: (context, index) {
                final item = queueList[index];
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
                      onStatusUpdated: onRefresh,
                    );
                  },
                );
              },
            ),
    );
  }
}
