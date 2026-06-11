import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:motocare/core/services/auth_service.dart';

class MechanicEmergencyService {
  static final MechanicEmergencyService _instance = MechanicEmergencyService._internal();
  factory MechanicEmergencyService() => _instance;
  MechanicEmergencyService._internal();

  String get _baseUrl => AuthService().baseUrl;

  Map<String, String> _headers() {
    final token = AuthService().accessToken;
    final headers = {'Accept': 'application/json'};
    if (token != null && token.isNotEmpty) headers['Authorization'] = 'Bearer $token';
    return headers;
  }

  Future<List<dynamic>> getEmergencies() async {
    final uri = Uri.parse('$_baseUrl/mechanic/emergencies');
    try {
      print('🔵 [MechanicEmergencyService] GET $uri');
      final res = await http.get(uri, headers: _headers());
      print('🔵 [MechanicEmergencyService] GET $uri -> ${res.statusCode}');
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        print('🟢 [MechanicEmergencyService] getEmergencies success: ${body}');
        return body['data'] as List<dynamic>? ?? [];
      }
      print('🔴 [MechanicEmergencyService] getEmergencies failed: ${res.statusCode} ${res.body}');
      return [];
    } catch (e) {
      print('🔴 [MechanicEmergencyService] getEmergencies exception: $e');
      return [];
    }
  }

  Future<List<dynamic>> getServices() async {
    final uri = Uri.parse('$_baseUrl/mechanic/emergencies/services');
    try {
      print('🔵 [MechanicEmergencyService] GET $uri');
      final res = await http.get(uri, headers: _headers());
      print('🔵 [MechanicEmergencyService] GET $uri -> ${res.statusCode}');
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        print('🟢 [MechanicEmergencyService] getServices success: ${body}');
        return body['data'] as List<dynamic>? ?? [];
      }
      print('🔴 [MechanicEmergencyService] getServices failed: ${res.statusCode} ${res.body}');
      return [];
    } catch (e) {
      print('🔴 [MechanicEmergencyService] getServices exception: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> showEmergency(int id) async {
    final uri = Uri.parse('$_baseUrl/mechanic/emergencies/$id');
    try {
      print('🔵 [MechanicEmergencyService] GET $uri');
      final res = await http.get(uri, headers: _headers());
      print('🔵 [MechanicEmergencyService] GET $uri -> ${res.statusCode}');
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        print('🟢 [MechanicEmergencyService] showEmergency success: ${body}');
        return body['data'] as Map<String, dynamic>?;
      }
      print('🔴 [MechanicEmergencyService] showEmergency failed: ${res.statusCode} ${res.body}');
      return null;
    } catch (e) {
      print('🔴 [MechanicEmergencyService] showEmergency exception: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getTotal(int id) async {
    final uri = Uri.parse('$_baseUrl/mechanic/emergencies/$id/total');
    try {
      print('🔵 [MechanicEmergencyService] GET $uri');
      final res = await http.get(uri, headers: _headers());
      print('🔵 [MechanicEmergencyService] GET $uri -> ${res.statusCode}');
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        print('🟢 [MechanicEmergencyService] getTotal success: ${body}');
        return body as Map<String, dynamic>;
      }
      print('🔴 [MechanicEmergencyService] getTotal failed: ${res.statusCode} ${res.body}');
      return null;
    } catch (e) {
      print('🔴 [MechanicEmergencyService] getTotal exception: $e');
      return null;
    }
  }

  Future<bool> acceptEmergency(int id) async {
    final uri = Uri.parse('$_baseUrl/mechanic/emergencies/$id/accept');
    try {
      print('🔵 [MechanicEmergencyService] POST $uri');
      final res = await http.post(uri, headers: _headers());
      print('🔵 [MechanicEmergencyService] POST $uri -> ${res.statusCode}');
      if (res.statusCode == 200) {
        print('🟢 [MechanicEmergencyService] acceptEmergency success: ${res.body}');
        return true;
      }
      print('🔴 [MechanicEmergencyService] acceptEmergency failed: ${res.statusCode} ${res.body}');
      return false;
    } catch (e) {
      print('🔴 [MechanicEmergencyService] acceptEmergency exception: $e');
      return false;
    }
  }

  Future<bool> arrived(int id) async {
    final uri = Uri.parse('$_baseUrl/mechanic/emergencies/$id/arrived');
    try {
      print('🔵 [MechanicEmergencyService] POST $uri');
      final res = await http.post(uri, headers: _headers());
      print('🔵 [MechanicEmergencyService] POST $uri -> ${res.statusCode}');
      if (res.statusCode == 200) {
        print('🟢 [MechanicEmergencyService] arrived success: ${res.body}');
        return true;
      }
      print('🔴 [MechanicEmergencyService] arrived failed: ${res.statusCode} ${res.body}');
      return false;
    } catch (e) {
      print('🔴 [MechanicEmergencyService] arrived exception: $e');
      return false;
    }
  }

  Future<bool> requestTowing(int id) async {
    final uri = Uri.parse('$_baseUrl/mechanic/emergencies/$id/towing');
    try {
      print('🔵 [MechanicEmergencyService] POST $uri');
      final res = await http.post(uri, headers: _headers());
      print('🔵 [MechanicEmergencyService] POST $uri -> ${res.statusCode}');
      if (res.statusCode == 200) {
        print('🟢 [MechanicEmergencyService] requestTowing success: ${res.body}');
        return true;
      }
      print('🔴 [MechanicEmergencyService] requestTowing failed: ${res.statusCode} ${res.body}');
      return false;
    } catch (e) {
      print('🔴 [MechanicEmergencyService] requestTowing exception: $e');
      return false;
    }
  }

  Future<bool> addService(int id, {int? serviceId, String? additionalService, double? price}) async {
    final uri = Uri.parse('$_baseUrl/mechanic/emergencies/$id/add-service');
    final Map<String, dynamic> body = {};
    if (serviceId != null) body['service_id'] = serviceId;
    if (additionalService != null) body['additional_service'] = additionalService;
    if (price != null) body['price'] = price;
    try {
      print('🔵 [MechanicEmergencyService] POST $uri body: $body');
      final res = await http.post(uri, headers: {..._headers(), 'Content-Type': 'application/json'}, body: jsonEncode(body));
      print('🔵 [MechanicEmergencyService] POST $uri -> ${res.statusCode}');
      if (res.statusCode == 200) {
        print('🟢 [MechanicEmergencyService] addService success: ${res.body}');
        return true;
      }
      print('🔴 [MechanicEmergencyService] addService failed: ${res.statusCode} ${res.body}');
      return false;
    } catch (e) {
      print('🔴 [MechanicEmergencyService] addService exception: $e');
      return false;
    }
  }

  Future<bool> proceedToPayment(int id) async {
    final uri = Uri.parse('$_baseUrl/mechanic/emergencies/$id/proceed-payment');
    try {
      print('🔵 [MechanicEmergencyService] POST $uri');
      final res = await http.post(uri, headers: _headers());
      print('🔵 [MechanicEmergencyService] POST $uri -> ${res.statusCode}');
      if (res.statusCode == 200) {
        print('🟢 [MechanicEmergencyService] proceedToPayment success: ${res.body}');
        return true;
      }
      print('🔴 [MechanicEmergencyService] proceedToPayment failed: ${res.statusCode} ${res.body}');
      return false;
    } catch (e) {
      print('🔴 [MechanicEmergencyService] proceedToPayment exception: $e');
      return false;
    }
  }

  Future<bool> completePayment(int id, {File? paymentProof}) async {
    final uri = Uri.parse('$_baseUrl/mechanic/emergencies/$id/complete-payment');
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(_headers());
    if (paymentProof != null && await paymentProof.exists()) {
      request.files.add(await http.MultipartFile.fromPath('payment_proof', paymentProof.path));
    }

    try {
      print('🔵 [MechanicEmergencyService] POST multipart $uri');
      final streamed = await request.send();
      final res = await http.Response.fromStream(streamed);
      print('🔵 [MechanicEmergencyService] POST multipart $uri -> ${res.statusCode}');
      if (res.statusCode == 200) {
        print('🟢 [MechanicEmergencyService] completePayment success: ${res.body}');
        return true;
      }
      print('🔴 [MechanicEmergencyService] completePayment failed: ${res.statusCode} ${res.body}');
      return false;
    } catch (e) {
      print('🔴 [MechanicEmergencyService] completePayment exception: $e');
      return false;
    }
  }
}
