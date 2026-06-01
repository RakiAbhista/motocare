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
    final selectedServices =
        _services.where((s) => _selectedIds.contains(s.id)).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
              const Text(
                'Pilih Layanan Servis',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                'Bisa pilih lebih dari satu layanan',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _services.isEmpty
                        ? const Center(
                            child: Text(
                              'Layanan tidak tersedia.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            itemCount: _services.length,
                            itemBuilder: (context, index) {
                              final service = _services[index];
                              final isSelected =
                                  _selectedIds.contains(service.id);
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedIds.remove(service.id);
                                    } else {
                                      _selectedIds.add(service.id);
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.lightBlue.shade50
                                        : Colors.white,
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: isSelected,
                                        activeColor: Colors.lightBlue,
                                        onChanged: (val) {
                                          setState(() {
                                            if (val == true) {
                                              _selectedIds.add(service.id);
                                            } else {
                                              _selectedIds.remove(service.id);
                                            }
                                          });
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          service.serviceName,
                                          style: TextStyle(
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        _formatPrice(service.basePrice),
                                        style: const TextStyle(
                                          color: Colors.lightBlue,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
              // Bottom bar: total + save button
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${selectedServices.length} layanan dipilih',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            _formatPrice(
                              selectedServices
                                  .fold<double>(
                                    0,
                                    (sum, s) =>
                                        sum +
                                        (double.tryParse(s.basePrice) ?? 0),
                                  )
                                  .toString(),
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.lightBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _selectedIds.isEmpty
                          ? null
                          : () {
                              Navigator.pop(context, selectedServices);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        disabledBackgroundColor: Colors.grey.shade300,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
