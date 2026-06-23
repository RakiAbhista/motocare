import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';

import 'package:motocare/features/cs/shared/enums/service_status.dart';
import 'package:motocare/features/cs/home/widgets/complaint_card.dart';
import 'package:motocare/features/cs/home/widgets/damage_photo_section.dart';
import 'package:motocare/features/cs/home/widgets/wehicle_card.dart';
import 'package:motocare/features/mechanic/emergency/widgets/invoice/invoice_service_list.dart';

import 'package:motocare/features/cs/home/models/order_detail_model.dart';
import 'package:motocare/features/cs/home/service/order_service.dart';

class DetailOrderScreen extends StatefulWidget {
  final int orderId;
  final ServiceStatus status;

  const DetailOrderScreen({
    super.key,
    required this.orderId,
    required this.status,
  });

  @override
  State<DetailOrderScreen> createState() => _DetailOrderScreenState();
}

class _DetailOrderScreenState extends State<DetailOrderScreen> {
  final OrderService _orderService = OrderService();
  OrderDetailModel? _orderDetail;
  bool _isLoading = true;
  String? _errorMessage;

  List<dynamic> _services = [];
  Map<String, dynamic>? _total;

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

    final result = await _orderService.getOrderDetail(widget.orderId);

    Map<String, dynamic>? total;
    try {
      total = await _orderService.getTotal(widget.orderId);
    } catch (_) {}

    if (result['success']) {
      final order = result['data'] as OrderDetailModel;

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
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.blue, size: 32),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Order Detail",
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
                ComplaintCard(
                  icon: Icons.warning,
                  title: "Servis",
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: InvoiceServiceList(
              services: _services,
              onAdd: null, // Disabled
              onRemove: null, // Disabled
              totalData: _total,
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
