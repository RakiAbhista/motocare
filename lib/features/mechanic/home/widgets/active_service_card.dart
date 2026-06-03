import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';

class ActiveServiceCard extends StatelessWidget {
  final Map<String, dynamic>? activeOrder;
  final VoidCallback? onTap;

  const ActiveServiceCard({
    super.key,
    this.activeOrder,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (activeOrder == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryLight, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            const Icon(
              Icons.assignment_turned_in_outlined,
              color: AppColors.primary,
              size: 40,
            ),
            const SizedBox(height: 12),
            const Text(
              'Tidak Ada Servis Aktif',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
                fontFamily: 'Mulish',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pilih antrian di bawah untuk mulai bekerja',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                fontFamily: 'Mulish',
              ),
            ),
          ],
        ),
      );
    }

    final vehicle = activeOrder!['vehicle'] as Map<String, dynamic>? ?? {};
    final brand = vehicle['brand'] ?? 'Honda';
    final model = vehicle['model'] ?? 'Beat';
    final customerName = activeOrder!['customer_name'] ?? 'Pelanggan';
    final orderId = activeOrder!['order_id'] ?? activeOrder!['id'] ?? 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, Color(0xFF1D4ED8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SEDANG BERLANGSUNG',
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.9),
                    fontFamily: 'Mulish',
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Order #$orderId',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Mulish',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              customerName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: 'Mulish',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$brand $model',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
                fontFamily: 'Mulish',
              ),
            ),
            const SizedBox(height: 16),
            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer_outlined, size: 14, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Aktif',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Mulish',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
