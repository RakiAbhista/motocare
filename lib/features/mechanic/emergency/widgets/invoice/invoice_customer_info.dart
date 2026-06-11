import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';

class InvoiceCustomerInfo extends StatelessWidget {
  final String clientName;
  final String clientPhone;
  final String? damagePhoto;

  const InvoiceCustomerInfo({
    super.key,
    this.clientName = '',
    this.clientPhone = '',
    this.damagePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.danger.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'HIGH PRIORITY',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.danger,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                clientName.isNotEmpty ? clientName : 'Nama Tidak Diketahui',
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF181C20),
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.phone, size: 14, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    clientPhone.isNotEmpty ? clientPhone : 'Hubungi Pelanggan',
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: 120,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E293B).withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: damagePhoto != null && damagePhoto!.isNotEmpty
                ? Image.network(
                    damagePhoto!,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, st) => Container(
                      color: Colors.grey[200],
                      child: const Center(child: Icon(Icons.directions_bike, size: 36, color: Colors.grey)),
                    ),
                  )
                : Container(
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.directions_bike, size: 36, color: Colors.grey)),
                  ),
          ),
        ),
      ],
    );
  }
}
