import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';

class WorkStatusCard extends StatefulWidget {
  final bool initialStatus;
  final ValueChanged<bool> onStatusChanged;

  const WorkStatusCard({
    super.key,
    required this.initialStatus,
    required this.onStatusChanged,
  });

  @override
  State<WorkStatusCard> createState() => _WorkStatusCardState();
}

class _WorkStatusCardState extends State<WorkStatusCard> {
  late bool _isOnline;

  @override
  void initState() {
    super.initState();
    _isOnline = widget.initialStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF1E293B).withOpacity(0.05),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Status Kerja",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _isOnline ? "Online • Siap menerima tugas" : "Offline • Istirahat / Tutup",
                style: TextStyle(
                  fontSize: 12,
                  color: _isOnline ? AppColors.success : Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Switch.adaptive(
            value: _isOnline,
            activeColor: AppColors.success,
            onChanged: (value) {
              setState(() {
                _isOnline = value;
              });
              widget.onStatusChanged(value);
            },
          ),
        ],
      ),
    );
  }
}
