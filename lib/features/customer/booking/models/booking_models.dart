class Vehicle {
  final int id;
  final String brand;
  final String model;
  final int manufacturingYear;
  final String plateNumber;
  final String vehicleType;

  Vehicle({
    required this.id,
    required this.brand,
    required this.model,
    required this.manufacturingYear,
    required this.plateNumber,
    required this.vehicleType,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      manufacturingYear: json['manufacturing_year'] ?? 0,
      plateNumber: json['plate_number'] ?? '',
      vehicleType: json['vehicle_type'] ?? '',
    );
  }
}

class ServiceModel {
  final int id;
  final String serviceName;
  final String basePrice;

  ServiceModel({
    required this.id,
    required this.serviceName,
    required this.basePrice,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      serviceName: json['service_name'] ?? '',
      basePrice: json['base_price']?.toString() ?? '0',
    );
  }
}

class Workshop {
  final int id;
  final String name;
  final String latitude;
  final String longitude;

  Workshop({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory Workshop.fromJson(Map<String, dynamic> json) {
    return Workshop(
      id: json['id'],
      name: json['name'] ?? '',
      latitude: json['latitude']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '',
    );
  }
}

class BookingSummary {
  final Vehicle? vehicle;
  final Workshop? workshop;
  final List<ServiceModel> services;
  final double totalPrice;
  final bool isTowing;
  final int serviceCount;

  BookingSummary({
    this.vehicle,
    this.workshop,
    required this.services,
    required this.totalPrice,
    required this.isTowing,
    required this.serviceCount,
  });

  factory BookingSummary.fromJson(Map<String, dynamic> json) {
    var serviceList = json['services'] as List? ?? [];
    return BookingSummary(
      vehicle: json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null,
      workshop: json['workshop'] != null ? Workshop.fromJson(json['workshop']) : null,
      services: serviceList.map((e) => ServiceModel.fromJson(e)).toList(),
      totalPrice: double.tryParse(json['total_price']?.toString() ?? '0') ?? 0.0,
      isTowing: json['is_towing'] == true || json['is_towing'] == 'yes',
      serviceCount: json['service_count'] ?? 0,
    );
  }
}
