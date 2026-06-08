import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ServiceDetailBottomSheet extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const ServiceDetailBottomSheet({
    super.key,
    required this.orderData,
  });

  static void show(BuildContext context, {required Map<String, dynamic> orderData}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ServiceDetailBottomSheet(orderData: orderData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFFF4F8FB),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ServiceCostCard(orderData: orderData),
                  const SizedBox(height: 16),
                  const _DocumentationCard(),
                  const SizedBox(height: 16),
                  _ReceiptCard(orderData: orderData),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCostCard extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const _ServiceCostCard({required this.orderData});

  String _formatCurrency(dynamic price) {
    if (price == null) return 'Rp 0';
    double amount;
    if (price is String) {
      amount = double.tryParse(price) ?? 0;
    } else if (price is num) {
      amount = price.toDouble();
    } else {
      amount = 0;
    }
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final services = List<Map<String, dynamic>>.from(orderData['services'] ?? []);
    final workshop = orderData['workshop'] as Map<String, dynamic>?;
    final bookingDate = orderData['booking_date'] as String?;
    final totalPrice = orderData['total_price'];

    // Build service names string
    final serviceNames = services.map((s) => s['service_name'] ?? '').join(', ');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.manage_history, size: 40, color: Colors.black87),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      serviceNames.isNotEmpty ? serviceNames : 'Service',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      _formatDate(bookingDate),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: Colors.black54),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            workshop?['name'] ?? '-',
                            style: const TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade200, thickness: 1),
          const SizedBox(height: 8),

          // List each service with its price
          ...services.map((service) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      service['service_name'] ?? '-',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  Text(
                    _formatCurrency(service['base_price']),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
            );
          }).toList(),

          const SizedBox(height: 4),
          Divider(color: Colors.grey.shade200, thickness: 1),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Biaya', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(
                _formatCurrency(totalPrice),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DocumentationCard extends StatelessWidget {
  const _DocumentationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dokumentasi Service', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 85, height: 85, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8))),
              Container(width: 85, height: 85, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8))),
              Container(width: 85, height: 85, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey.shade300)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text('Lihat Semua Foto', style: TextStyle(color: Colors.grey, fontSize: 10)),
              ),
              Expanded(child: Divider(color: Colors.grey.shade300)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const _ReceiptCard({required this.orderData});

  String _formatCurrency(dynamic price) {
    if (price == null) return 'Rp 0';
    double amount;
    if (price is String) {
      amount = double.tryParse(price) ?? 0;
    } else if (price is num) {
      amount = price.toDouble();
    } else {
      amount = 0;
    }
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final services = List<Map<String, dynamic>>.from(orderData['services'] ?? []);
    final workshop = orderData['workshop'] as Map<String, dynamic>?;
    final orderId = orderData['order_id'];
    final totalPrice = orderData['total_price'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Receipt',
                style: TextStyle(
                  color: Color(0xFF1565C0),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                'Order #$orderId',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Bengkel
          _receiptRow('Bengkel', workshop?['name'] ?? '-'),
          const SizedBox(height: 8),
          Divider(color: Colors.grey.shade200),
          const SizedBox(height: 8),
          // Services
          ...services.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: _receiptRow(
              s['service_name'] ?? '-',
              _formatCurrency(s['base_price']),
            ),
          )).toList(),
          const SizedBox(height: 8),
          Divider(color: Colors.grey.shade300, thickness: 1.5),
          const SizedBox(height: 8),
          _receiptRow(
            'Total',
            _formatCurrency(totalPrice),
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _receiptRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isBold ? const Color(0xFF1A1A1A) : Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isBold ? const Color(0xFF1A1A1A) : Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
