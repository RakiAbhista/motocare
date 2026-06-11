import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../../features/customer/booking/models/booking_models.dart';

class WorkshopService {
  String get baseUrl => AuthService().baseUrl;

  Map<String, String> _getHeaders() {
    final token = AuthService().accessToken;
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<Workshop>> getAllWorkshops() async {
    try {
      final uri = Uri.parse('$baseUrl/customer/workshops');
      print('🔵 [WorkshopService.getAllWorkshops] GET $uri');
      print('🔵 [WorkshopService.getAllWorkshops] headers: ${_getHeaders()}');
      final response = await http.get(uri, headers: _getHeaders());
      print('🔵 [WorkshopService.getAllWorkshops] status: ${response.statusCode}');
      print('🔵 [WorkshopService.getAllWorkshops] body: ${response.body}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final data = body['data'] as List? ?? [];
        print('🔵 [WorkshopService.getAllWorkshops] items: ${data.length}');
        return data.map((e) => Workshop.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('Error getAllWorkshops: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getNearestWorkshops(double latitude, double longitude) async {
    try {
      final uri = Uri.parse('$baseUrl/customer/workshops/nearest?latitude=$latitude&longitude=$longitude');
      print('🔵 [WorkshopService.getNearestWorkshops] GET $uri');
      print('🔵 [WorkshopService.getNearestWorkshops] headers: ${_getHeaders()}');
      final response = await http.get(uri, headers: _getHeaders());
      print('🔵 [WorkshopService.getNearestWorkshops] status: ${response.statusCode}');
      print('🔵 [WorkshopService.getNearestWorkshops] body: ${response.body}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final data = body['data'] as List? ?? [];
        print('🔵 [WorkshopService.getNearestWorkshops] items: ${data.length}');
        return data.map((e) => Map<String, dynamic>.from(e)).toList();
      }
      return [];
    } catch (e) {
      print('Error getNearestWorkshops: $e');
      return [];
    }
  }
}
