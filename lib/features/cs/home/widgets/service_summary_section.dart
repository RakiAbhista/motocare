import 'package:flutter/material.dart';

class ServiceSummarySection extends StatelessWidget {
  final int subtotal;
  final double taxPercent;

  const ServiceSummarySection({
    super.key,
    required this.subtotal,
    this.taxPercent = 11,
  });

  String formatRupiah(num value) {
    return 'IDR ${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final double taxAmount = subtotal * (taxPercent / 100);
    final double totalAmount = subtotal + taxAmount;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 24,
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// DIVIDER
          Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),

          const SizedBox(height: 24),

          /// SUBTOTAL
          Text(
            'SUBTOTAL',
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 1.5,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            formatRupiah(subtotal),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 20),

          /// TAXES
          Text(
            'TAXES (${taxPercent.toStringAsFixed(0)}%)',
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 1.5,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            formatRupiah(taxAmount),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 30),

          /// TOTAL AMOUNT
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              /// BLUE LINE
              Container(
                width: 3,
                height: 50,
                color: Colors.blue,
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Align(
                      alignment: Alignment.centerRight,

                      child: Text(
                        'TOTAL AMOUNT',
                        style: TextStyle(
                          fontSize: 12,
                          letterSpacing: 2,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Rp.${totalAmount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 54,
                        height: 1,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}