import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../../features/customer/booking/models/booking_models.dart';
import 'dart:io';

class BookingService {
  String get baseUrl => AuthService().baseUrl;

  Map<String, String> _getHeaders() {
    final token = AuthService().accessToken;
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<Vehicle>> getVehicles() async {
    try {
      print('🔵 [getVehicles] Fetching: $baseUrl/customer/booking/vehicles');
      print('🔵 [getVehicles] Headers: ${_getHeaders()}');
      
      final response = await http.get(
        Uri.parse('$baseUrl/customer/booking/vehicles'),
        headers: _getHeaders(),
      );

      print('🔵 [getVehicles] Status: ${response.statusCode}');
      print('🔵 [getVehicles] Response: ${response.body}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print('🔵 [getVehicles] Decoded body: $body');
        final data = body['data'] as List? ?? [];
        print('🔵 [getVehicles] Data list: $data');
        final result = data.map((e) => Vehicle.fromJson(e)).toList();
        print('🔵 [getVehicles] Mapped result: ${result.length} vehicles');
        return result;
      }
      print('❌ [getVehicles] Failed with status ${response.statusCode}');
      return [];
    } catch (e) {
      print('❌ [getVehicles] Error: $e');
      return [];
    }
  }

  Future<List<ServiceModel>> getServices() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/customer/booking/services'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final data = body['data'] as List? ?? [];
        return data.map((e) => ServiceModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('Error getServices: $e');
      return [];
    }
  }

  Future<List<Workshop>> getWorkshops() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/customer/booking/workshops'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final data = body['data'] as List? ?? [];
        return data.map((e) => Workshop.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('Error getWorkshops: $e');
      return [];
    }
  }

  Future<BookingSummary?> getSummary({
    required int vehicleId,
    required int workshopId,
    required List<int> serviceIds,
    bool isTowing = false,
  }) async {
    try {
      final payload = {
        'vehicle_id': vehicleId,
        'workshop_id': workshopId,
        'service_ids': serviceIds,
        'is_towing': isTowing,
        'booking_date': DateTime.now().add(const Duration(days: 1)).toIso8601String().split('T')[0],
      };
      
      print('🔵 [getSummary] Payload: $payload');
      
      final response = await http.post(
        Uri.parse('$baseUrl/customer/booking/summary'),
        headers: _getHeaders(),
        body: jsonEncode(payload),
      );

      print('🔵 [getSummary] Status: ${response.statusCode}');
      print('🔵 [getSummary] Response: ${response.body}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true) {
          return BookingSummary.fromJson(body['data']);
        }
      }
      print('❌ [getSummary] Failed: ${response.statusCode} - ${response.body}');
      return null;
    } catch (e) {
      print('❌ [getSummary] Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> createBooking({
    required int vehicleId,
    required int workshopId,
    required List<int> serviceIds,
    required String complaint,
    File? damagePhoto,
    required double totalPrice,
    bool isTowing = false,
  }) async {
    try {
      print('🔵 [createBooking] Starting with photo: ${damagePhoto != null}');
      
      if (damagePhoto != null) {
        // Multipart request if photo exists
        var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/customer/booking'));
        
        final token = AuthService().accessToken;
        request.headers.addAll({
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        });
        
        request.fields['vehicle_id'] = vehicleId.toString();
        request.fields['workshop_id'] = workshopId.toString();
        request.fields['complaint'] = complaint;
        request.fields['total_price'] = totalPrice.toString();
        request.fields['is_towing'] = isTowing ? '1' : '0';
        request.fields['booking_date'] = DateTime.now().add(const Duration(days: 1)).toIso8601String().split('T')[0];
        
        
        // Add array of services with correct field name
        for (int i = 0; i < serviceIds.length; i++) {
          request.fields['service_ids[$i]'] = serviceIds[i].toString();
        }
        
        request.files.add(
          await http.MultipartFile.fromPath('damage_photo', damagePhoto.path),
        );
        
        print('🔵 [createBooking] Multipart fields: ${request.fields}');
        
        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);
        
        print('🔵 [createBooking] Status: ${response.statusCode}');
        print('🔵 [createBooking] Response: ${response.body}');
        
        return jsonDecode(response.body);
      } else {
        // Normal JSON post
        final payload = {
          'vehicle_id': vehicleId,
          'workshop_id': workshopId,
          'service_ids': serviceIds,
          'complaint': complaint,
          'total_price': totalPrice,
          'is_towing': isTowing,
          'booking_date': DateTime.now().add(const Duration(days: 1)).toIso8601String().split('T')[0],
        };
        
        print('🔵 [createBooking] JSON Payload: $payload');
        
        final response = await http.post(
          Uri.parse('$baseUrl/customer/booking'),
          headers: _getHeaders(),
          body: jsonEncode(payload),
        );
        
        print('🔵 [createBooking] Status: ${response.statusCode}');
        print('🔵 [createBooking] Response: ${response.body}');
        
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error createBooking: $e');
      return {'success': false, 'message': 'Terjadi kesalahan sistem: $e'};
    }
  }
}
