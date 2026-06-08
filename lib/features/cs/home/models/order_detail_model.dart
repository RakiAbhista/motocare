class OrderDetailModel {
  final int id;
  final int? mechanicId;
  final int? voucherId;
  final String status;
  final String paymentStatus;
  final String totalPrice;
  final String? paymentType;
  final String isTowing;
  final String? transactionId;
  final String? paymentUrl;
  final String? scheduledAt;
  final OrderWorkshopModel workshop;
  final OrderVehicleModel vehicle;
  final OrderUserModel user;
  final List<OrderServiceModel> services;

  OrderDetailModel({
    required this.id,
    this.mechanicId,
    this.voucherId,
    required this.status,
    required this.paymentStatus,
    required this.totalPrice,
    this.paymentType,
    required this.isTowing,
    this.transactionId,
    this.paymentUrl,
    this.scheduledAt,
    required this.workshop,
    required this.vehicle,
    required this.user,
    required this.services,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      id: json['id'],
      mechanicId: json['mechanic_id'],
      voucherId: json['voucher_id'],
      status: json['status'],
      paymentStatus: json['payment_status'],
      totalPrice: json['total_price'],
      paymentType: json['payment_type'],
      isTowing: json['is_towing'],
      transactionId: json['transaction_id'],
      paymentUrl: json['payment_url'],
      scheduledAt: json['scheduled_at'],
      workshop: OrderWorkshopModel.fromJson(json['workshop'] ?? {}),
      vehicle: OrderVehicleModel.fromJson(json['vehicle'] ?? {}),
      user: OrderUserModel.fromJson(json['user'] ?? {}),
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => OrderServiceModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class OrderWorkshopModel {
  final int? id;
  final String? name;

  OrderWorkshopModel({this.id, this.name});

  factory OrderWorkshopModel.fromJson(Map<String, dynamic> json) {
    return OrderWorkshopModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

class OrderVehicleModel {
  final int? id;
  final String? vehicleType;
  final String? brand;
  final String? model;
  final String? plateNumber;
  final int? manufacturingYear;

  OrderVehicleModel({
    this.id,
    this.vehicleType,
    this.brand,
    this.model,
    this.plateNumber,
    this.manufacturingYear,
  });

  factory OrderVehicleModel.fromJson(Map<String, dynamic> json) {
    return OrderVehicleModel(
      id: json['id'],
      vehicleType: json['vehicle_type'],
      brand: json['brand'],
      model: json['model'],
      plateNumber: json['plate_number'],
      manufacturingYear: json['manufacturing_year'],
    );
  }
}

class OrderUserModel {
  final int? id;
  final String? name;
  final String? phoneNumber;
  final String? email;

  OrderUserModel({this.id, this.name, this.phoneNumber, this.email});

  factory OrderUserModel.fromJson(Map<String, dynamic> json) {
    return OrderUserModel(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      email: json['email'],
    );
  }
}

class OrderServiceModel {
  final int? id;
  final String? additionalService;
  final String? price;
  final ServiceDetailModel? service;

  OrderServiceModel({this.id, this.additionalService, this.price, this.service});

  factory OrderServiceModel.fromJson(Map<String, dynamic> json) {
    return OrderServiceModel(
      id: json['id'],
      additionalService: json['additional_service'],
      price: json['price'],
      service: json['service'] != null
          ? ServiceDetailModel.fromJson(json['service'])
          : null,
    );
  }
}

class ServiceDetailModel {
  final int? id;
  final String? serviceName;
  final String? basePrice;

  ServiceDetailModel({this.id, this.serviceName, this.basePrice});

  factory ServiceDetailModel.fromJson(Map<String, dynamic> json) {
    return ServiceDetailModel(
      id: json['id'],
      serviceName: json['service_name'],
      basePrice: json['base_price'],
    );
  }
}
