import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/core/theme/app_theme.dart';

class ServiceDetailBottomSheet extends StatelessWidget {
  const ServiceDetailBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ServiceDetailBottomSheet(),
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
                  const _ServiceCostCard(),
                  const SizedBox(height: 16),
                  const _DocumentationCard(),
                  const SizedBox(height: 16),
                  const _ReceiptCard(),
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
  const _ServiceCostCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: const Icon(Icons.manage_history, size: 28, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ganti Oli', style: AppTheme.titleLarge),
                    const SizedBox(height: 2),
                    const Text('19 Maret 2025', style: AppTheme.bodySmall),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        const Text('Bengkel Semarang Barat', style: AppTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          _buildCostRow('Spare parts Oli', 'Rp 55.000'),
          const SizedBox(height: 8),
          _buildCostRow('Biaya Jasa', 'Rp 50.000'),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          _buildTotalRow('Total Biaya', 'Rp 105.000'),
        ],
      ),
    );
  }

  Widget _buildCostRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTheme.bodyMedium),
        Text(value, style: AppTheme.titleMedium),
      ],
    );
  }

  Widget _buildTotalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTheme.titleLarge),
        Text(value,
            style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
      ],
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
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dokumentasi Service', style: AppTheme.titleLarge),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDocPlaceholder(),
              _buildDocPlaceholder(),
              _buildDocPlaceholder(),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey.shade300)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('Lihat Semua Foto',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 10)),
              ),
              Expanded(child: Divider(color: Colors.grey.shade300)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDocPlaceholder() {
    return Container(
      width: 85,
      height: 85,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Receipt',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
