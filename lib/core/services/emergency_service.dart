import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:motocare/core/services/auth_service.dart';

class EmergencyService {
  String get baseUrl => AuthService().baseUrl;

  Map<String, String> _getHeaders() {
    final token = AuthService().accessToken;
    return {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> createEmergency({
    required double latitude,
    required double longitude,
    int? vehicleId,
    String? vehicleBrand,
    String? vehicleType,
    String? vehicleModel,
    String? plateNumber,
    String? complaint,
    File? damagePhoto,
    required String emergencyType, // 'mechanic' or 'towing'
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/customer/emergency');

      if (damagePhoto != null) {
        final request = http.MultipartRequest('POST', uri);
        request.headers.addAll(_getHeaders());

        request.fields['latitude'] = latitude.toString();
        request.fields['longitude'] = longitude.toString();
        if (vehicleId != null) request.fields['vehicle_id'] = vehicleId.toString();
        if (vehicleBrand != null) request.fields['vehicle_brand'] = vehicleBrand;
        if (vehicleType != null) request.fields['vehicle_type'] = vehicleType;
        if (vehicleModel != null) request.fields['vehicle_model'] = vehicleModel;
        if (plateNumber != null) request.fields['plate_number'] = plateNumber;
        if (complaint != null) request.fields['complaint'] = complaint;
        request.fields['emergency_type'] = emergencyType;

        request.files.add(await http.MultipartFile.fromPath('damage_photo', damagePhoto.path));

        final streamed = await request.send();
        final response = await http.Response.fromStream(streamed);
        return jsonDecode(response.body);
      }

      final payload = {
        'latitude': latitude,
        'longitude': longitude,
        if (vehicleId != null) 'vehicle_id': vehicleId,
        if (vehicleBrand != null) 'vehicle_brand': vehicleBrand,
        if (vehicleType != null) 'vehicle_type': vehicleType,
        if (vehicleModel != null) 'vehicle_model': vehicleModel,
        if (plateNumber != null) 'plate_number': plateNumber,
        if (complaint != null) 'complaint': complaint,
        'emergency_type': emergencyType,
      };

      final response = await http.post(
        uri,
        headers: {
          ..._getHeaders(),
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );
      return jsonDecode(response.body);
    } catch (e) {
      print('EmergencyService.createEmergency Error: $e');
      return {'success': false, 'message': 'Gagal mengirim permintaan emergency: $e'};
    }
  }

  Future<List<dynamic>> getVehicles() async {
    try {
      final uri = Uri.parse('$baseUrl/customer/emergency/vehicles');
      final response = await http.get(uri, headers: _getHeaders());
      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['success'] == true) {
        return body['data'] as List<dynamic>;
      }
      return [];
    } catch (e) {
      print('EmergencyService.getVehicles Error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getNearestWorkshop({required double latitude, required double longitude}) async {
    try {
      final uri = Uri.parse('$baseUrl/customer/emergency/nearest-workshop?latitude=$latitude&longitude=$longitude');
      final response = await http.get(uri, headers: _getHeaders());
      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['success'] == true) {
        return body['data'] as Map<String, dynamic>;
      }
      print('EmergencyService.getNearestWorkshop failed: ${response.statusCode} ${response.body}');
      return null;
    } catch (e) {
      print('EmergencyService.getNearestWorkshop Error: $e');
      return null;
    }
  }
}
