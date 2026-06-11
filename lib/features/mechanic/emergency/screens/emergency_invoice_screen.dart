import 'package:flutter/material.dart';
import 'package:motocare/features/cs/home/service/mechanic_emergency_service.dart';
import '../widgets/invoice/invoice_customer_info.dart';
import '../widgets/invoice/invoice_vehicle_details.dart';
import '../widgets/invoice/invoice_service_list.dart';
import '../widgets/invoice/invoice_action_buttons.dart';

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
    setState(() {
      _detail = detail;
      _availableServices = services;
      _total = total;
      _loading = false;
    });
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

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateSB) {
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
                      itemBuilder: (context, i) {
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
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  double? price;
                  if (priceTxt.isNotEmpty) price = double.tryParse(priceTxt.replaceAll(',', ''));
                  setState(() => _actionLoading = true);
                  final ok = await _svc.addService(widget.emergencyId, serviceId: selectedServiceId, additionalService: additional.isNotEmpty ? additional : null, price: price);
                  setState(() => _actionLoading = false);
                  if (ok) {
                    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Service ditambahkan')));
                    await _refreshDetail();
                    final total = await _svc.getTotal(widget.emergencyId);
                    if (mounted) setState(() => _total = total);
                  } else {
                    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal menambahkan service')));
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
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Proses pembayaran dimulai')));
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal melanjutkan pembayaran')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _detail ?? {};
    // data may be nested under 'data' depending on service
    final payload = data['data'] ?? data;
    final client = payload?['client'] ?? {};
    final vehicle = payload?['vehicle'] ?? {};
    final order = payload?['order'] ?? {};

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
                    services: order['services'] as List<dynamic>? ?? [],
                    onAdd: _openAddServiceModal,
                    totalData: _total,
                  ),
                  const SizedBox(height: 32),
                  InvoiceActionButtons(
                    onTowing: _callTowing,
                    onProceedPayment: _proceedPayment,
                    loading: _actionLoading,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}

