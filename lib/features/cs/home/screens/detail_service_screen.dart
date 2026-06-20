import 'package:flutter/material.dart';
import 'package:motocare/features/cs/home/screens/payment_service_screen.dart';
import 'package:motocare/core/theme/app_colors.dart';

import 'package:motocare/features/cs/shared/enums/service_status.dart';
import 'package:motocare/features/cs/home/widgets/complaint_card.dart';
import 'package:motocare/features/cs/home/widgets/damage_photo_section.dart';
import 'package:motocare/features/cs/home/widgets/wehicle_card.dart';
import 'package:motocare/features/mechanic/emergency/widgets/invoice/invoice_service_list.dart';

import 'package:motocare/features/cs/home/models/order_detail_model.dart';
import 'package:motocare/features/cs/home/service/order_service.dart';

class DetailServiceScreen extends StatefulWidget {
  final int orderId;
  final ServiceStatus status;

  const DetailServiceScreen({
    super.key,
    required this.orderId,
    required this.status,
  });

  @override
  State<DetailServiceScreen> createState() => _DetailServiceScreenState();
}

class _DetailServiceScreenState extends State<DetailServiceScreen> {
  final OrderService _orderService = OrderService();
  OrderDetailModel? _orderDetail;
  bool _isLoading = true;
  String? _errorMessage;

  // State untuk dynamic tambahan servis
  List<dynamic> _availableServices = [];
  List<dynamic> _services = [];
  Map<String, dynamic>? _total;
  bool _actionLoading = false;

  @override
  void initState() {
    super.initState();
    _loadOrderDetail();
  }

  Future<void> _loadOrderDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Load order detail, available services, dan total secara paralel
    final results = await Future.wait([
      _orderService.getOrderDetail(widget.orderId),
      _orderService.getServices(),
    ]);

    final result = results[0] as Map<String, dynamic>;
    final availableServices = results[1] as List<dynamic>;

    Map<String, dynamic>? total;
    try {
      total = await _orderService.getTotal(widget.orderId);
    } catch (_) {}

    if (result['success']) {
      final order = result['data'] as OrderDetailModel;

      // Petakan services dari total (paling akurat) atau dari detail order
      List<dynamic> serviceList = [];
      if (total != null && total['data'] != null && total['data']['services'] != null) {
        serviceList = total['data']['services'] as List<dynamic>;
      } else {
        serviceList = order.services.map((s) => {
          'id': s.id,
          'service_name': s.service?.serviceName ?? s.additionalService ?? 'Service',
          'additional_service': s.additionalService,
          'price': s.price ?? s.service?.basePrice ?? '0',
        }).toList();
      }

      setState(() {
        _orderDetail = order;
        _availableServices = availableServices;
        _services = serviceList;
        _total = total;
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = result['message'];
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshServices() async {
    final total = await _orderService.getTotal(widget.orderId);
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

  Future<void> _openAddServiceModal() async {
    final services = _availableServices;
    int? selectedServiceId;
    String additional = '';
    String priceTxt = '';

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
                  final svcId = selectedServiceId;
                  final addtl = additional.isNotEmpty ? additional : null;
                  double? price;
                  if (priceTxt.isNotEmpty) price = double.tryParse(priceTxt.replaceAll(',', ''));

                  Navigator.pop(dialogCtx);

                  setState(() => _actionLoading = true);
                  final ok = await _orderService.addService(
                    widget.orderId,
                    serviceId: svcId,
                    additionalService: addtl,
                    price: price,
                  );
                  setState(() => _actionLoading = false);

                  if (ok) {
                    if (mounted) scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Service ditambahkan')));
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

  Future<void> _removeService(int serviceId) async {
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
    final ok = await _orderService.removeService(widget.orderId, serviceId);
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: $_errorMessage'),
                      ElevatedButton(
                        onPressed: _loadOrderDetail,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : _buildContent(context, _orderDetail!),
    );
  }

  Widget _buildContent(BuildContext context, OrderDetailModel order) {
    return SingleChildScrollView(
      child: Column(
        children: [
          /// CUSTOM HEADER
          Container(
            height: 160,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            decoration: const BoxDecoration(color: Color(0xFFF0F7FF)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                /// BACK BUTTON
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.blue,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                /// TITLE
                const Text(
                  "Service Detail",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// CONTENT
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Service ID",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[700]),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${order.transactionId ?? order.id}",
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: VehicleCard(
              vehicleName: '${order.vehicle.brand} ${order.vehicle.model}',
              ownerName: order.user.name ?? '-',
              plateNumber: order.vehicle.plateNumber ?? '-',
              imagePath: "lib/features/cs/shared/assets_dummy/motorcycle_1.jpg",
            ),
          ),

          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Keluhan",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                /// USER COMPLAIN SECTION
                ComplaintCard(
                  icon: Icons.warning,
                  title: "Servis Rutin",
                  iconColor: Colors.red,
                  info: order.services.isNotEmpty && order.services.first.additionalService != null 
                        ? order.services.first.additionalService! 
                        : "Tidak ada keluhan spesifik dari user",
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: DamagePhotoSection(
              imagePaths: [
                'lib/features/cs/shared/assets_dummy/damage1.jpeg',
                'lib/features/cs/shared/assets_dummy/damage2.jpg',
              ],
            ),
          ),

          const SizedBox(height: 20),

          // InvoiceServiceList: sama persis dengan tampilan mekanik
          if (_actionLoading)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: LinearProgressIndicator(),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: InvoiceServiceList(
              services: _services,
              onAdd: _openAddServiceModal,
              onRemove: _removeService,
              totalData: _total,
            ),
          ),

          if (widget.status == ServiceStatus.waitingPayment) ...[
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: _actionLoading ? null : () {
                    // Hitung grand total dari _total atau akumulasi _services
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
                        builder: (_) => PaymentServiceScreen(
                          totalAmount: grandTotal,
                          orderId: widget.orderId,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    "Proceed Payment",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 30),

          if (widget.status == ServiceStatus.inProgress)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    print("FINALIZE SERVICE");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    "Finalize Service",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
