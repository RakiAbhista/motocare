import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:motocare/core/services/auth_service.dart';

class DashboardService {
  final String baseUrl = 'http://10.0.2.2:8000/api/v1';

  Future<Map<String, dynamic>> getDashboard() async {
    try {
      final token = AuthService().accessToken;

      final response = await http.get(
        Uri.parse('$baseUrl/customer-service/dashboard'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'cs_name': data['data']['cs_name'],
          'statistics': data['data']['statistics'],
          'latest_orders': data['data']['latest_orders'],
        };
      } else {
        return {'success': false, 'message': 'Gagal memuat data'};
      }
    } catch (e) {
      print('Dashboard Error: $e');
      return {'success': false, 'message': 'Gagal terhubung ke server'};
    }
  }
}