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
      final response = await http.get(
        Uri.parse('$baseUrl/booking/vehicles'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final data = body['data'] as List? ?? [];
        return data.map((e) => Vehicle.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('Error getVehicles: $e');
      return [];
    }
  }

  Future<List<ServiceModel>> getServices() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/booking/services'),
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
        Uri.parse('$baseUrl/booking/workshops'),
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
      final response = await http.post(
        Uri.parse('$baseUrl/booking/summary'),
        headers: _getHeaders(),
        body: jsonEncode({
          'vehicle_id': vehicleId,
          'workshop_id': workshopId,
          'services': serviceIds,
          'is_towing': isTowing,
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true) {
          return BookingSummary.fromJson(body['data']);
        }
      }
      print('Error getSummary: ${response.statusCode} - ${response.body}');
      return null;
    } catch (e) {
      print('Error getSummary: $e');
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
      if (damagePhoto != null) {
        // Multipart request if photo exists
        var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/booking'));
        
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
        
        // Add array of services
        for (int i = 0; i < serviceIds.length; i++) {
          request.fields['services[$i]'] = serviceIds[i].toString();
        }
        
        request.files.add(
          await http.MultipartFile.fromPath('damage_photo', damagePhoto.path),
        );
        
        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);
        
        return jsonDecode(response.body);
      } else {
        // Normal JSON post
        final response = await http.post(
          Uri.parse('$baseUrl/booking'),
          headers: _getHeaders(),
          body: jsonEncode({
            'vehicle_id': vehicleId,
            'workshop_id': workshopId,
            'services': serviceIds,
            'complaint': complaint,
            'total_price': totalPrice,
            'is_towing': isTowing,
          }),
        );
        
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error createBooking: $e');
      return {'success': false, 'message': 'Terjadi kesalahan sistem: $e'};
    }
  }
}
