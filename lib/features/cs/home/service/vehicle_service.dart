import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:motocare/core/services/auth_service.dart';

class VehicleService {
  Future<Map<String, dynamic>> findByPlate(String plateNumber) async {
    try {
      final token = AuthService().accessToken;
      final baseUrl = AuthService().baseUrl;

      final response = await http.post(
        Uri.parse('$baseUrl/customer-service/vehicles/find-by-plate'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'plate_number': plateNumber,
        }),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': body['data'],
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Kendaraan tidak ditemukan',
        };
      }
    } catch (e) {
      print('VehicleService Error: $e');
      return {'success': false, 'message': 'Gagal terhubung ke server'};
    }
  }
}
