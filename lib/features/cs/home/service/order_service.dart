import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:motocare/core/services/auth_service.dart';
import 'package:motocare/features/cs/home/models/order_detail_model.dart';
import 'package:motocare/features/customer/booking/models/booking_models.dart';

class OrderService {
  Future<Map<String, dynamic>> getOrderDetail(int orderId) async {
    try {
      final token = AuthService().accessToken;
      final baseUrl = AuthService().baseUrl;

      final response = await http.get(
        Uri.parse('$baseUrl/customer-service/orders/$orderId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['success'] == true) {
        final data = body['data'] as Map<String, dynamic>;
        final orderDetail = OrderDetailModel.fromJson(data);

        return {
          'success': true,
          'data': orderDetail,
        };
      } else {
        print('Order API Error: ${response.statusCode} - ${response.body}');
        return {
          'success': false,
          'message': body['message'] ?? 'Gagal memuat detail pesanan'
        };
      }
    } catch (e) {
      print('Order Error: $e');
      return {'success': false, 'message': 'Gagal terhubung ke server'};
    }
  }

  Future<Map<String, dynamic>> getOrders() async {
    try {
      final token = AuthService().accessToken;
      final baseUrl = AuthService().baseUrl;

      final response = await http.get(
        Uri.parse('$baseUrl/customer-service/orders'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          (body['success'] == true || body['status'] == 'success')) {
        return {
          'success': true,
          'data': body['data'] as List<dynamic>,
        };
      } else {
        print('Orders API Error: ${response.statusCode} - ${response.body}');
        return {
          'success': false,
          'message': body['message'] ?? 'Gagal memuat daftar pesanan'
        };
      }
    } catch (e) {
      print('Orders Error: $e');
      return {'success': false, 'message': 'Gagal terhubung ke server'};
    }
  }

  Future<List<ServiceModel>> getServices() async {
    try {
      final token = AuthService().accessToken;
      final baseUrl = AuthService().baseUrl;

      final response = await http.get(
        Uri.parse('$baseUrl/customer-service/orders/services'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final data = body['data'] as List? ?? [];
        return data.map((e) => ServiceModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> getTotal(int orderId) async {
    try {
      final token = AuthService().accessToken;
      final baseUrl = AuthService().baseUrl;

      final response = await http.get(
        Uri.parse('$baseUrl/customer-service/orders/$orderId/total'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> addService(
    int orderId, {
    int? serviceId,
    String? additionalService,
    double? price,
  }) async {
    try {
      final token = AuthService().accessToken;
      final baseUrl = AuthService().baseUrl;

      final Map<String, dynamic> requestBody = {};
      if (serviceId != null) requestBody['service_id'] = serviceId;
      if (additionalService != null) requestBody['additional_service'] = additionalService;
      if (price != null) requestBody['price'] = price;

      final response = await http.post(
        Uri.parse('$baseUrl/customer-service/orders/$orderId/add-service'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeService(int orderId, int serviceId) async {
    try {
      final token = AuthService().accessToken;
      final baseUrl = AuthService().baseUrl;

      final response = await http.delete(
        Uri.parse('$baseUrl/customer-service/orders/$orderId/service/$serviceId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  Future<String?> completePayment(int orderId, {File? paymentProof, String paymentType = 'transfer'}) async {
    final token = AuthService().accessToken;
    final baseUrl = AuthService().baseUrl;
    final uri = Uri.parse('$baseUrl/customer-service/orders/$orderId/complete-payment');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Accept'] = 'application/json';
    if (token != null && token.isNotEmpty) request.headers['Authorization'] = 'Bearer $token';
    request.fields['payment_type'] = paymentType;
    if (paymentProof != null && await paymentProof.exists()) {
      request.files.add(await http.MultipartFile.fromPath('payment_proof', paymentProof.path));
    }
    try {
      final streamed = await request.send();
      final res = await http.Response.fromStream(streamed);
      print('🔵 [OrderService] completePayment -> ${res.statusCode} ${res.body}');
      if (res.statusCode == 200 || res.statusCode == 201) return null; // success
      try {
        final data = jsonDecode(res.body);
        return data['message'] ?? 'Gagal memproses (Code: ${res.statusCode})';
      } catch (_) {
        return 'Error ${res.statusCode}';
      }
    } catch (e) {
      print('🔴 [OrderService] completePayment Error: $e');
      return e.toString();
    }
  }

  Future<Map<String, dynamic>> createOrder({
    int? userId,
    int? vehicleId,
    String? guestName,
    String? guestPhone,
    String? vehicleBrand,
    String? vehicleModel,
    String? vehicleType,
    String? plateNumber,
    String? manufacturingYear,
    required int workshopId,
    required List<int> serviceIds,
    required String complaint,
    String? damagePhoto,
  }) async {
    try {
      final token = AuthService().accessToken;
      final baseUrl = AuthService().baseUrl;

      final Map<String, dynamic> requestBody = {
        'workshop_id': workshopId,
        'service_ids': serviceIds,
        'complaint': complaint,
        if (damagePhoto != null) 'damage_photo': damagePhoto,
      };

      if (userId != null && userId > 0) {
        requestBody['user_id'] = userId;
      } else {
        if (guestName != null) requestBody['guest_name'] = guestName;
        if (guestPhone != null) requestBody['guest_phone'] = guestPhone;
      }

      if (vehicleId != null && vehicleId > 0) {
        requestBody['vehicle_id'] = vehicleId;
      } else {
        if (vehicleBrand != null) requestBody['vehicle_brand'] = vehicleBrand;
        if (vehicleModel != null) requestBody['vehicle_model'] = vehicleModel;
        if (vehicleType != null) requestBody['vehicle_type'] = vehicleType;
        if (plateNumber != null) requestBody['plate_number'] = plateNumber;
        if (manufacturingYear != null) requestBody['manufacturing_year'] = manufacturingYear;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/customer-service/orders'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 201 && body['success'] == true) {
        return {
          'success': true,
          'data': body['data'],
          'message': body['message'] ?? 'Order berhasil dibuat',
        };
      } else {
        print('Create Order API Error: ${response.statusCode} - ${response.body}');
        return {
          'success': false,
          'message': body['message'] ?? 'Gagal membuat order',
        };
      }
    } catch (e) {
      print('Create Order Error: $e');
      return {'success': false, 'message': 'Gagal terhubung ke server'};
    }
  }
}