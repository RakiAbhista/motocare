import 'package:flutter/material.dart';

class EmergencyEmptyAlert extends StatelessWidget {
  const EmergencyEmptyAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 128,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withOpacity(0.5),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Tidak ada Panggilan Darurat',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1.25, // line-height: 30px / font-size: 24px = 1.25
          ),
        ),
      ),
    );
  }
}
