import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';

class InvoiceServiceList extends StatelessWidget {
  final List<dynamic> services;
  final VoidCallback? onAdd;
  final Function(int)? onRemove;
  final Map<String, dynamic>? totalData;

  const InvoiceServiceList({
    super.key,
    this.services = const [],
    this.onAdd,
    this.onRemove,
    this.totalData,
  });

  @override
  Widget build(BuildContext context) {
    final subtotal = _calcSubtotal();
    final tax = subtotal * 0.11;
    final grandTotal = subtotal + tax;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFE6E8EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & Tambah Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Detail Servis',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF191C1E),
                  letterSpacing: -0.45,
                ),
              ),
              TextButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 18),
                label: const Text(
                  'Tambah',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Dynamic service items
          if (services.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Icon(Icons.build_circle_outlined, size: 40, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  Text(
                    'Belum ada servis ditambahkan',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          else
            for (var i = 0; i < services.length; i++) ...[
                _buildInvoiceItem(
                  services[i]['service_name'] ?? services[i]['additional_service'] ?? 'Layanan',
                  (services[i]['price'] ?? services[i]['base_price'] ?? '0').toString(),
                  () {
                    final serviceId = services[i]['id'];
                    if (serviceId != null && onRemove != null) {
                      onRemove!(int.tryParse(serviceId.toString()) ?? 0);
                    }
                  },
                ),
              const SizedBox(height: 16),
            ],
          
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Divider(color: Color(0xFFE6E8EA), thickness: 2),
          ),

          // 4. Telemetry Style Totals — Now Dynamic
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left Side (Subtotal & Taxes)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('SUBTOTAL', style: TextStyle(fontFamily: 'Manrope', fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF707881), letterSpacing: 1)),
                    const SizedBox(height: 4),
                    Text(_formatCurrency(subtotal), style: const TextStyle(fontFamily: 'Manrope', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF3F4850))),
                    const SizedBox(height: 16),
                    const Text('TAXES (11%)', style: TextStyle(fontFamily: 'Manrope', fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF707881), letterSpacing: 1)),
                    const SizedBox(height: 4),
                    Text(_formatCurrency(tax), style: const TextStyle(fontFamily: 'Manrope', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF3F4850))),
                  ],
                ),
                
                const VerticalDivider(color: AppColors.primary, thickness: 2, width: 32),
                
                // Right Side (Total Amount)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('TOTAL AMOUNT', style: TextStyle(fontFamily: 'Manrope', fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: 2.2)),
                      const SizedBox(height: 8),
                      Text(
                        _formatCurrency(grandTotal),
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF191C1E),
                          letterSpacing: -1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Hitung subtotal dari service list atau total_price dari backend
  double _calcSubtotal() {
    // Prioritas 1: dari totalData (backend total_price)
    if (totalData != null) {
      final tp = totalData!['data']?['total_price'] ?? totalData!['total_price'];
      if (tp != null) {
        return double.tryParse(tp.toString()) ?? 0;
      }
    }
    // Prioritas 2: sum manual dari services
    try {
      double sum = 0;
      for (var s in services) {
        final p = s['price'] ?? s['base_price'] ?? 0;
        sum += double.tryParse(p.toString()) ?? 0;
      }
      return sum;
    } catch (_) {
      return 0;
    }
  }

  String _formatCurrency(double value) {
    // Format angka dengan pemisah ribuan
    final intVal = value.round();
    final str = intVal.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return 'Rp $buffer';
  }

  // Helper Widget untuk Form Input Jasa & Harga
  Widget _buildInvoiceItem(String title, String price, VoidCallback? onRemoveItem) {
    // Format harga
    String formattedPrice = price;
    final numPrice = double.tryParse(price);
    if (numPrice != null) {
      formattedPrice = _formatCurrency(numPrice).replaceFirst('Rp ', '');
    }

    return Row(
      children: [
        // Kolom Deskripsi Servis
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('SERVICE DESCRIPTION', style: TextStyle(fontFamily: 'Manrope', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF707881))),
              const SizedBox(height: 4),
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4F6),
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.centerLeft,
                child: Text(title, style: const TextStyle(fontFamily: 'Manrope', fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF191C1E))),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Kolom Harga
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('PRICE (IDR)', style: TextStyle(fontFamily: 'Manrope', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF707881))),
              const SizedBox(height: 4),
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4F6),
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.centerRight,
                child: Text(formattedPrice, style: const TextStyle(fontFamily: 'Manrope', fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Icon Delete/Remove
        IconButton(
          onPressed: onRemoveItem,
          icon: const Icon(Icons.remove_circle_outline, color: Colors.grey, size: 20),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        )
      ],
    );
  }
}
