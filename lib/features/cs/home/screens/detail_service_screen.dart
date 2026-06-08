import 'package:flutter/material.dart';
import 'package:motocare/features/cs/home/screens/payment_service_screen.dart';
import 'package:motocare/core/theme/app_colors.dart';

import 'package:motocare/features/cs/shared/enums/service_status.dart';
import 'package:motocare/features/cs/home/widgets/complaint_card.dart';
import 'package:motocare/features/cs/home/widgets/add_item_bottom_sheet.dart';
import 'package:motocare/features/cs/home/widgets/additional_service_chip.dart';
import 'package:motocare/features/cs/home/widgets/damage_photo_section.dart';
import 'package:motocare/features/cs/home/widgets/line_item_card.dart';
import 'package:motocare/features/cs/home/widgets/service_summary_section.dart';
import 'package:motocare/features/cs/home/widgets/wehicle_card.dart';

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

    if (result['success']) {
      setState(() {
        _orderDetail = result['data'] as OrderDetailModel;
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Service ID",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w200),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Job ID #${order.transactionId ?? order.id}",
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
              imagePath: "lib/features/cs/assets_dummy/motorcycle_1.jpg",
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
                'lib/features/cs/assets_dummy/damage1.jpeg',
                'lib/features/cs/assets_dummy/damage2.jpg',
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Tambahan Service",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 12,
                runSpacing: 12,
                children: order.services.map((service) {
                  return AdditionalServiceChip(
                    title: service.service?.serviceName ?? service.additionalService ?? 'Service',
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Line Items",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                if (widget.status == ServiceStatus.inProgress)
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const AddItemBottomSheet(),
                      );
                    },
                    icon: const Icon(Icons.add, color: Colors.black, size: 28),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          ///Items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: order.services.map((svc) {
                final price = double.tryParse(svc.price ?? svc.service?.basePrice ?? '0') ?? 0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: LineItemCard(
                    itemName: svc.service?.serviceName ?? svc.additionalService ?? 'Item',
                    quantity: 1,
                    price: price.toInt(),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 30),

          ServiceSummarySection(
            subtotal: double.tryParse(order.totalPrice)?.toInt() ?? 0,
            taxPercent: 11, // Or whatever logic needed
          ),

          if (widget.status == ServiceStatus.waitingPayment)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PaymentServiceScreen(),
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
