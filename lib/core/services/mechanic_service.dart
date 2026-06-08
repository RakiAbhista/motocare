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

  /// Accept order (Mulai Kerja) — POST /mechanic/orders/{id}/accept
  Future<bool> acceptOrder(dynamic orderId) async {
    try {
      print('🔵 [MechanicService] Accepting order $orderId');
      final response = await http.post(
        Uri.parse('$baseUrl/mechanic/orders/$orderId/accept'),
        headers: _getHeaders(),
      );

      print('🔵 [MechanicService] Accept status: ${response.statusCode}');
      print('🔵 [MechanicService] Accept response: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('❌ [MechanicService] Error accepting order: $e');
      return false;
    }
  }

  /// Complete order (Selesaikan Pekerjaan) — POST /mechanic/orders/{id}/complete
  Future<bool> completeOrder(dynamic orderId) async {
    try {
      print('🔵 [MechanicService] Completing order $orderId');
      final response = await http.post(
        Uri.parse('$baseUrl/mechanic/orders/$orderId/complete'),
        headers: _getHeaders(),
      );

      print('🔵 [MechanicService] Complete status: ${response.statusCode}');
      print('🔵 [MechanicService] Complete response: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('❌ [MechanicService] Error completing order: $e');
      return false;
    }
  }
}
