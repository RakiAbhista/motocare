// lib/features/cs/home/models/latest_order_model.dart

class LatestOrderModel {
  final int id;
  final String customerName;
  final String vehicleBrand;
  final String vehicleModel;
  final String plateNumber;
  final String status;
  final DateTime createdAt;

  const LatestOrderModel({
    required this.id,
    required this.customerName,
    required this.vehicleBrand,
    required this.vehicleModel,
    required this.plateNumber,
    required this.status,
    required this.createdAt,
  });

  factory LatestOrderModel.fromJson(Map<String, dynamic> json) {
    return LatestOrderModel(
      id: json['id'] ?? 0,
      customerName: json['customer_name'] ?? json['user']?['name'] ?? 'Unknown',
      vehicleBrand: json['vehicle_brand'] ?? json['vehicle']?['brand'] ?? 'Unknown',
      vehicleModel: json['vehicle_model'] ?? json['vehicle']?['model'] ?? 'Unknown',
      plateNumber: json['plate_number'] ?? json['vehicle']?['plate_number'] ?? 'Unknown',
      status: json['status'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
    );
  }
}