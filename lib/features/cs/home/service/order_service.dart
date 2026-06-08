import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:motocare/core/services/auth_service.dart';
import 'package:motocare/features/cs/home/models/order_detail_model.dart';

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

  Future<Map<String, dynamic>> createOrder({
    required int userId,
    required int vehicleId,
    required int workshopId,
    required int serviceId,
    required String complaint,
    String? damagePhoto,
  }) async {
    try {
      final token = AuthService().accessToken;
      final baseUrl = AuthService().baseUrl;

      final Map<String, dynamic> requestBody = {
        'user_id': userId,
        'vehicle_id': vehicleId,
        'workshop_id': workshopId,
        'service_id': serviceId,
        'complaint': complaint,
        'damage_photo': damagePhoto,
      };

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