import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';

class InvoiceActionButtons extends StatelessWidget {
  const InvoiceActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Quick Action Button: Ajukan Layanan Towing
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.danger.withOpacity(0.1), // Transparan merah
            borderRadius: BorderRadius.circular(16),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {},
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_shipping_outlined, color: AppColors.danger, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Ajukan Layanan Towing',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.danger,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Action Button: Lanjutkan Pembayaran
        Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primary],
            ),
            borderRadius: BorderRadius.circular(9999),
            boxShadow: [
              BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(9999),
              onTap: () {},
              child: const Center(
                child: Text(
                  'Lanjutkan Pembayaran',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16, // Sedikit dikecilkan dari 18 agar proporsional
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
