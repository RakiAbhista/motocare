class EmergencyModel {
  final int id;
  final String customerName;
  final String vehicleBrand;
  final String vehicleModel;
  final String plateNumber;
  final String? location;
  final String? description;
  final EmergencyMechanicModel? mechanic;
  final String status;
  final String createdAt;

  EmergencyModel({
    required this.id,
    required this.customerName,
    required this.vehicleBrand,
    required this.vehicleModel,
    required this.plateNumber,
    this.location,
    this.description,
    this.mechanic,
    required this.status,
    required this.createdAt,
  });

  factory EmergencyModel.fromJson(Map<String, dynamic> json) {
    return EmergencyModel(
      id: json['id'] as int,
      customerName: json['customer_name'] ?? '',
      vehicleBrand: json['vehicle_brand'] ?? '',
      vehicleModel: json['vehicle_model'] ?? '',
      plateNumber: json['plate_number'] ?? '',
      location: json['location'],
      description: json['description'],
      mechanic: json['mechanic'] != null ? EmergencyMechanicModel.fromJson(json['mechanic']) : null,
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  bool get isPending => status == 'pending';
}

class EmergencyMechanicModel {
  final int? id;
  final String? name;

  EmergencyMechanicModel({this.id, this.name});

  factory EmergencyMechanicModel.fromJson(Map<String, dynamic> json) {
    return EmergencyMechanicModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

