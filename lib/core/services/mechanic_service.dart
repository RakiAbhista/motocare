import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class MechanicService {
  static final MechanicService _instance = MechanicService._internal();
  factory MechanicService() => _instance;
  MechanicService._internal();

  String get baseUrl => AuthService().baseUrl;

  Map<String, String> _getHeaders() {
    final token = AuthService().accessToken;
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Fetch mechanic dashboard data
  Future<Map<String, dynamic>?> getDashboardData() async {
    try {
      print('🔵 [MechanicService] Fetching dashboard from: $baseUrl/mechanic/dashboard');
      final response = await http.get(
        Uri.parse('$baseUrl/mechanic/dashboard'),
        headers: _getHeaders(),
      );

      print('🔵 [MechanicService] Status: ${response.statusCode}');
      print('🔵 [MechanicService] Response: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('❌ [MechanicService] Failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e, stack) {
      print('❌ [MechanicService] Error fetching dashboard: $e');
      print(stack);
      return null;
    }
  }

  /// Update order status (Mulai / Selesai)
  /// We define this to allow the mechanic to update the order status
  Future<bool> updateOrderStatus(int orderId, String status) async {
    try {
      print('🔵 [MechanicService] Updating order $orderId status to: $status');
      final response = await http.post(
        Uri.parse('$baseUrl/mechanic/orders/$orderId/status'),
        headers: _getHeaders(),
        body: jsonEncode({'status': status}),
      );

      print('🔵 [MechanicService] Update status: ${response.statusCode}');
      print('🔵 [MechanicService] Update response: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print('❌ [MechanicService] Error updating order status: $e');
      return false;
    }
  }
}
