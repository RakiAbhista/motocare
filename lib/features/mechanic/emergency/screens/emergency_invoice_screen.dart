import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/features/cs/home/service/mechanic_emergency_service.dart';
import '../widgets/invoice/invoice_customer_info.dart';
import '../widgets/invoice/invoice_vehicle_details.dart';
import '../widgets/invoice/invoice_service_list.dart';
import '../widgets/invoice/invoice_action_buttons.dart';
import '../screens/emergency_payment_screen.dart';

class EmergencyInvoiceScreen extends StatefulWidget {
  final int emergencyId;
  final int orderId;

  const EmergencyInvoiceScreen({
    super.key,
    required this.emergencyId,
    required this.orderId,
  });

  @override
  State<EmergencyInvoiceScreen> createState() => _EmergencyInvoiceScreenState();
}

class _EmergencyInvoiceScreenState extends State<EmergencyInvoiceScreen> {
  final MechanicEmergencyService _svc = MechanicEmergencyService();
  Map<String, dynamic>? _detail;
  List<dynamic> _availableServices = [];
  List<dynamic> _services = []; // ← sumber utama service list dari getTotal
  Map<String, dynamic>? _total;
  bool _loading = true;
  bool _actionLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => _loading = true);
    final detail = await _svc.showEmergency(widget.emergencyId);
    final services = await _svc.getServices();
    Map<String, dynamic>? total;
    try {
      total = await _svc.getTotal(widget.emergencyId);
    } catch (_) {}

    // Ambil service list: prioritaskan dari getTotal, fallback dari showEmergency
    List<dynamic> serviceList = [];
    if (total != null && total['data'] != null && total['data']['services'] != null) {
      serviceList = total['data']['services'] as List<dynamic>;
    } else if (detail != null) {
      final payload = detail['data'] ?? detail;
      final order = payload?['order'] ?? {};
      serviceList = order['services'] as List<dynamic>? ?? [];
    }

    setState(() {
      _detail = detail;
      _availableServices = services;
      _total = total;
      _services = serviceList;
      _loading = false;
    });
  }

  Future<void> _refreshServices() async {
    // Refresh dari getTotal — sumber paling akurat karena langsung query n_order_services
    final total = await _svc.getTotal(widget.emergencyId);
    if (total != null && mounted) {
      List<dynamic> serviceList = [];
      if (total['data'] != null && total['data']['services'] != null) {
        serviceList = total['data']['services'] as List<dynamic>;
      }
      setState(() {
        _total = total;
        _services = serviceList;
      });
    }
  }

  Future<void> _refreshDetail() async {
    final detail = await _svc.showEmergency(widget.emergencyId);
    if (detail != null) setState(() => _detail = detail);
  }

  Future<void> _openAddServiceModal() async {
    final services = _availableServices;
    int? selectedServiceId;
    String additional = '';
    String priceTxt = '';

    // Simpan reference ke context screen (bukan dialog) untuk ScaffoldMessenger
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    await showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(builder: (sbCtx, setStateSB) {
          List<dynamic> filtered = services;
          return AlertDialog(
            title: const Text('Tambah Service'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(hintText: 'Cari layanan atau ketik manual'),
                    onChanged: (v) {
                      setStateSB(() {
                        final q = v.toLowerCase();
                        filtered = services.where((s) {
                          final name = (s['service_name'] ?? '').toString().toLowerCase();
                          final id = s['service_id']?.toString() ?? s['id']?.toString() ?? '';
                          return name.contains(q) || id.contains(q);
                        }).toList();
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final s = filtered[i];
                        final sid = s['service_id'] ?? s['id'];
                        final name = s['service_name'] ?? s['name'] ?? '';
                        final base = s['base_price']?.toString() ?? s['price']?.toString() ?? '';
                        return ListTile(
                          title: Text(name),
                          subtitle: base.isNotEmpty ? Text('Rp $base') : null,
                          trailing: Radio<int?>(
                            value: sid is int ? sid : int.tryParse(sid.toString()),
                            groupValue: selectedServiceId,
                            onChanged: (v) => setStateSB(() => selectedServiceId = v),
                          ),
                          onTap: () => setStateSB(() => selectedServiceId = sid is int ? sid : int.tryParse(sid.toString())),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Nama tambahan (optional)'),
                    onChanged: (v) => setStateSB(() => additional = v),
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Harga (IDR)', hintText: '100000'),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => setStateSB(() => priceTxt = v),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Batal')),
              ElevatedButton(
                onPressed: () async {
                  // Ambil nilai sebelum pop dialog
                  final svcId = selectedServiceId;
                  final addtl = additional.isNotEmpty ? additional : null;
                  double? price;
                  if (priceTxt.isNotEmpty) price = double.tryParse(priceTxt.replaceAll(',', ''));

                  // Tutup dialog dulu
                  Navigator.pop(dialogCtx);

                  // Sekarang kode berjalan di context screen, bukan dialog
                  setState(() => _actionLoading = true);
                  final ok = await _svc.addService(widget.emergencyId, serviceId: svcId, additionalService: addtl, price: price);
                  setState(() => _actionLoading = false);
                  if (ok) {
                    if (mounted) scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Service ditambahkan')));
                    // Refresh service list dari getTotal (sumber paling akurat)
                    await _refreshServices();
                  } else {
                    if (mounted) scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Gagal menambahkan service')));
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> _callTowing() async {
    setState(() => _actionLoading = true);
    final ok = await _svc.requestTowing(widget.emergencyId);
    setState(() => _actionLoading = false);
    if (ok) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Permintaan towing terkirim')));
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal mengirim permintaan towing')));
    }
  }

  Future<void> _proceedPayment() async {
    setState(() => _actionLoading = true);
    final ok = await _svc.proceedToPayment(widget.emergencyId);
    setState(() => _actionLoading = false);
    if (ok) {
      if (mounted) {
        // Calculate grand total (subtotal + 11% tax)
        double subtotal = 0;
        if (_total != null) {
          final tp = _total!['data']?['total_price'] ?? _total!['total_price'];
          if (tp != null) subtotal = double.tryParse(tp.toString()) ?? 0;
        } else {
          for (var s in _services) {
            final p = s['price'] ?? s['base_price'] ?? 0;
            subtotal += double.tryParse(p.toString()) ?? 0;
          }
        }
        final grandTotal = subtotal + (subtotal * 0.11);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EmergencyPaymentScreen(
              emergencyId: widget.emergencyId,
              totalAmount: grandTotal,
            ),
          ),
        );
      }
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal melanjutkan pembayaran')));
    }
  }

  Future<void> _cancelOrder() async {
    // Tampilkan dialog konfirmasi
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.danger, size: 28),
            SizedBox(width: 8),
            Text('Batalkan Order?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: const Text(
          'Apakah Anda yakin ingin membatalkan order ini? Tindakan ini tidak dapat dibatalkan.\n\nGunakan fitur ini jika order terbukti fiktif.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Kembali', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Ya, Batalkan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _actionLoading = true);
    final ok = await _svc.cancelEmergency(widget.emergencyId);
    setState(() => _actionLoading = false);

    if (ok) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order berhasil dibatalkan'),
            backgroundColor: AppColors.success,
          ),
        );
        // Kembali ke halaman sebelumnya (Emergency Screen)
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal membatalkan order'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  Future<void> _removeService(int serviceId) async {
    // Tampilkan konfirmasi
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Service?'),
        content: const Text('Apakah Anda yakin ingin menghapus service ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _actionLoading = true);
    final ok = await _svc.removeService(widget.emergencyId, serviceId);
    setState(() => _actionLoading = false);

    if (ok) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Service dihapus')));
      await _refreshServices();
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal menghapus service')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _detail ?? {};
    // data may be nested under 'data' depending on service
    final payload = data['data'] ?? data;
    final client = payload?['client'] ?? {};
    final vehicle = payload?['vehicle'] ?? {};

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF181C20)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Emergency',
          style: TextStyle(
            color: Color(0xFF181C20),
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InvoiceCustomerInfo(
                    clientName: client['name'] ?? '',
                    clientPhone: client['phone'] ?? '',
                    damagePhoto: payload['damage_photo'] ?? null,
                  ),
                  const SizedBox(height: 24),
                  InvoiceVehicleDetails(
                    vehicleBrand: vehicle['brand'] ?? '',
                    plateNumber: vehicle['plate_number'] ?? '',
                    vehicleType: vehicle['vehicle_type'] ?? '',
                    vehicleModel: vehicle['model'] ?? '',
                  ),
                  const SizedBox(height: 32),
                  InvoiceServiceList(
                    services: _services, // ← pakai _services dari getTotal
                    onAdd: _openAddServiceModal,
                    onRemove: _removeService,
                    totalData: _total,
                  ),
                  const SizedBox(height: 32),
                  InvoiceActionButtons(
                    onTowing: _callTowing,
                    onProceedPayment: _proceedPayment,
                    loading: _actionLoading,
                  ),
                  const SizedBox(height: 16),
                  // Tombol Batalkan Order
                  Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.danger.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.danger.withOpacity(0.2)),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: _actionLoading ? null : _cancelOrder,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cancel_outlined, color: AppColors.danger, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Batalkan Order',
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
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}
