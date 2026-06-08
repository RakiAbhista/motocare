import 'package:flutter/material.dart';
import 'package:motocare/core/services/booking_service.dart';
import 'package:motocare/features/customer/booking/models/booking_models.dart';

class PilihLayananBottomSheet extends StatefulWidget {
  final List<ServiceModel> initialSelected;

  const PilihLayananBottomSheet({
    super.key,
    this.initialSelected = const [],
  });

  static Future<List<ServiceModel>?> show(
    BuildContext context, {
    List<ServiceModel> initialSelected = const [],
  }) {
    return showModalBottomSheet<List<ServiceModel>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PilihLayananBottomSheet(
        initialSelected: initialSelected,
      ),
    );
  }

  @override
  State<PilihLayananBottomSheet> createState() =>
      _PilihLayananBottomSheetState();
}

class _PilihLayananBottomSheetState extends State<PilihLayananBottomSheet> {
  final _service = BookingService();
  List<ServiceModel> _services = [];
  final Set<int> _selectedIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedIds.addAll(widget.initialSelected.map((s) => s.id));
    _loadServices();
  }

  Future<void> _loadServices() async {
    final services = await _service.getServices();
    if (mounted) {
      setState(() {
        _services = services;
        _isLoading = false;
      });
    }
  }

  String _formatPrice(String price) {
    final num = double.tryParse(price) ?? 0;
    final formatted = num.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return 'Rp $formatted';
  }

  @override
  Widget build(BuildContext context) {
    final List<String> layananList = [
      'Paket Ganti Oli (Oli Mesin + Gardan)',
      'Servis Rutin',
      'Ganti Kampas Rem',
      'Tune Up',
      'Lainnya',
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          const Text(
            'Pilih Layanan',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: layananList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.grey.shade400,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        layananList[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
