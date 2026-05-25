import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';

class InvoiceServiceList extends StatelessWidget {
  const InvoiceServiceList({super.key});

  @override
  Widget build(BuildContext context) {
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
                onPressed: () {},
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

          // Item 1: Paket Ganti Oli
          _buildInvoiceItem('Paket Ganti Oli', '95.000'),
          const SizedBox(height: 16),
          
          // Item 2: Busi Merk
          _buildInvoiceItem('Busi Merk X', '35.000'),
          const SizedBox(height: 16),
          
          // Item 3: Roller 10 gr Merk
          _buildInvoiceItem('Roller 10gr', '90.000'),
          const SizedBox(height: 16),
          
          // Item 4: Jasa Mekanik
          _buildInvoiceItem('Jasa Mekanik', '50.000'),
          
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Divider(color: Color(0xFFE6E8EA), thickness: 2),
          ),

          // 4. Telemetry Style Totals
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left Side (Subtotal & Taxes)
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SUBTOTAL', style: TextStyle(fontFamily: 'Manrope', fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF707881), letterSpacing: 1)),
                    SizedBox(height: 4),
                    Text('IDR 270.000', style: TextStyle(fontFamily: 'Manrope', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF3F4850))),
                    SizedBox(height: 16),
                    Text('TAXES (11%)', style: TextStyle(fontFamily: 'Manrope', fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF707881), letterSpacing: 1)),
                    SizedBox(height: 4),
                    Text('IDR 29.700', style: TextStyle(fontFamily: 'Manrope', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF3F4850))),
                  ],
                ),
                
                const VerticalDivider(color: AppColors.primary, thickness: 2, width: 32),
                
                // Right Side (Total Amount)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('TOTAL AMOUNT', style: TextStyle(fontFamily: 'Manrope', fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: 2.2)),
                      SizedBox(height: 8),
                      Text(
                        'Rp. 299.700',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 26, // Disesuaikan agar muat di layar mobile
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

  // Helper Widget untuk Form Input Jasa & Harga
  Widget _buildInvoiceItem(String title, String price) {
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
                child: Text(price, style: const TextStyle(fontFamily: 'Manrope', fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Icon Delete/Remove
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.remove_circle_outline, color: Colors.grey, size: 20),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        )
      ],
    );
  }
}
