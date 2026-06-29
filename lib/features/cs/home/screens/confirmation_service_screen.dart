import 'package:flutter/material.dart';
import '../../home/widgets/wehicle_card.dart';
import 'package:motocare/features/cs/home/service/order_service.dart';
import 'package:motocare/features/customer/booking/models/booking_models.dart';

class ConfirmationServiceScreen extends StatefulWidget {
  final String plateNumber;
  final String vehicleName;
  final String ownerName;
  final String complaint;
  final int userId;
  final int vehicleId;
  final int workshopId;
  final String? guestName;
  final String? guestPhone;
  final String? vehicleBrand;
  final String? vehicleModel;
  final String? vehicleType;
  final String? manufacturingYear;
  final List<ServiceModel> selectedServices;

  const ConfirmationServiceScreen({
    super.key,
    required this.plateNumber,
    required this.vehicleName,
    required this.ownerName,
    required this.complaint,
    required this.userId,
    required this.vehicleId,
    required this.workshopId,
    this.guestName,
    this.guestPhone,
    this.vehicleBrand,
    this.vehicleModel,
    this.vehicleType,
    this.manufacturingYear,
    required this.selectedServices,
  });

  @override
  State<ConfirmationServiceScreen> createState() =>
      _ConfirmationServiceScreenState();
}

class _ConfirmationServiceScreenState
    extends State<ConfirmationServiceScreen> {
  bool _isLoading = false;

  String _formatPrice(double price) {
    final formatted = price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return 'Rp $formatted';
  }

  double get _totalServicePrice => widget.selectedServices.fold(
      0, (sum, s) => sum + (double.tryParse(s.basePrice) ?? 0));

  Future<void> _submitOrder() async {
    setState(() => _isLoading = true);

    final result = await OrderService().createOrder(
      userId: widget.userId,
      vehicleId: widget.vehicleId,
      guestName: widget.guestName,
      guestPhone: widget.guestPhone,
      vehicleBrand: widget.vehicleBrand,
      vehicleModel: widget.vehicleModel,
      vehicleType: widget.vehicleType,
      plateNumber: widget.plateNumber,
      manufacturingYear: widget.manufacturingYear,
      workshopId: widget.workshopId,
      serviceIds: widget.selectedServices.map((e) => e.id).toList(),
      complaint: widget.complaint,
      damagePhoto: null,
    );

    if (!mounted) return;

    if (result['success'] == true) {
      setState(() => _isLoading = false);
      _showSuccessDialog();
    } else {
      setState(() => _isLoading = false);
      _showErrorSnackbar(result['message'] ?? 'Gagal membuat order');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle,
                color: Colors.blue, size: 64),
            const SizedBox(height: 16),
            const Text(
              "Registrasi Berhasil!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Kendaraan ${widget.vehicleName} berhasil didaftarkan untuk servis.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Tutup dialog lalu kembali ke home CS
                  Navigator.of(context).pop();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Kembali ke Home",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER (tidak berubah)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFF3F8FF),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.blue,
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          "Offline Registration",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "STEP 3 OF 3",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Stack(
                    children: [
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      Container(
                        height: 6,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Confirm Registration",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Review all registration details before submitting.",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),

            /// CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    VehicleCard(
                      vehicleName: widget.vehicleName,
                      ownerName: widget.ownerName,
                      plateNumber: widget.plateNumber,
                      imagePath: "assets/images/motor.png",
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FB),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.build_circle, color: Colors.blue),
                              SizedBox(width: 10),
                              Text(
                                "Service Summary",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          buildInfoRow(
                            "Service Type",
                            widget.selectedServices.map((s) => s.serviceName).join(', '),
                          ),
                          const SizedBox(height: 18),
                          buildInfoRow("Estimated Duration", "Menunggu Pemeriksaan"),
                          const SizedBox(height: 18),
                          buildInfoRow("Estimated Cost", _formatPrice(_totalServicePrice)),
                          const SizedBox(height: 25),
                          const Text(
                            "CUSTOMER COMPLAINT",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              widget.complaint,
                              style: const TextStyle(
                                fontSize: 15,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    /// BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed:
                                _isLoading ? null : () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 58),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Text(
                              "Edit",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submitOrder,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              minimumSize: const Size(0, 58),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Text(
                                    "Register Service",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.grey[700], fontSize: 15),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      ],
    );
  }
}