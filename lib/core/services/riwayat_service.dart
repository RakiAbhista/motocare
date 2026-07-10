import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class RiwayatService {
  String get baseUrl => AuthService().baseUrl;

  /// POST /customer/vehicles — Tambah kendaraan baru (multipart form-data)
  Future<Map<String, dynamic>> addVehicle({
    required String vehicleType,
    required String brand,
    required String model,
    required String plateNumber,
    required String manufacturingYear,
    required File registrationDoc,
  }) async {
    try {
      print('🔵 [RiwayatService] Adding vehicle...');
      final token = AuthService().accessToken;

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/customer/vehicles'),
      );

      // Headers
      request.headers.addAll({
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      });

      // Fields
      request.fields['vehicle_type'] = vehicleType;
      request.fields['brand'] = brand;
      request.fields['model'] = model;
      request.fields['plate_number'] = plateNumber;
      request.fields['manufacturing_year'] = manufacturingYear;

      // File
      request.files.add(
        await http.MultipartFile.fromPath(
          'registration_doc',
          registrationDoc.path,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('🔵 [RiwayatService] Add vehicle status: ${response.statusCode}');
      print('🔵 [RiwayatService] Add vehicle body: ${response.body}');

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': body['message'] ?? 'Kendaraan berhasil ditambahkan',
          'data': body['data'],
        };
      } else {
        // Extract validation errors if any
        String errorMsg = body['message'] ?? 'Gagal menambahkan kendaraan';
        if (body['errors'] != null) {
          final errors = body['errors'] as Map<String, dynamic>;
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            errorMsg = firstError.first.toString();
          }
        }
        return {'success': false, 'message': errorMsg};
      }
    } catch (e) {
      print('❌ [RiwayatService] addVehicle error: $e');
      return {'success': false, 'message': 'Gagal terhubung ke server: $e'};
    }
  }

  Map<String, String> _getHeaders() {
    final token = AuthService().accessToken;
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// GET /riwayat/vehicles — Daftar kendaraan customer
  Future<List<Map<String, dynamic>>> getVehicles() async {
    try {
      print('🔵 [RiwayatService] Fetching vehicles...');
      final response = await http.get(
        Uri.parse('$baseUrl/customer/riwayat/vehicles'),
        headers: _getHeaders(),
      );

      print('🔵 [RiwayatService] Vehicles status: ${response.statusCode}');
      print('🔵 [RiwayatService] Vehicles body: ${response.body}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true) {
          return List<Map<String, dynamic>>.from(body['data'] ?? []);
        }
      }
      return [];
    } catch (e) {
      print('❌ [RiwayatService] getVehicles error: $e');
      return [];
    }
  }

  /// GET /riwayat/vehicles/{vehicleId} — Detail kendaraan
  Future<Map<String, dynamic>?> getVehicleDetail(int vehicleId) async {
    try {
      print('🔵 [RiwayatService] Fetching vehicle detail for ID: $vehicleId');
      // Coba path dengan /detail sesuai format output backend
      var response = await http.get(
        Uri.parse('$baseUrl/customer/riwayat/vehicles/$vehicleId/detail'),
        headers: _getHeaders(),
      );

      print('🔵 [RiwayatService] Vehicle detail status (with /detail): ${response.statusCode}');

      if (response.statusCode == 404) {
        print('🔵 [RiwayatService] Retrying without /detail...');
        response = await http.get(
          Uri.parse('$baseUrl/customer/riwayat/vehicles/$vehicleId'),
          headers: _getHeaders(),
        );
        print('🔵 [RiwayatService] Vehicle detail status (fallback): ${response.statusCode}');
      }

      print('🔵 [RiwayatService] Vehicle detail body: ${response.body}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true) {
          return Map<String, dynamic>.from(body['data']);
        }
      }
      return null;
    } catch (e) {
      print('❌ [RiwayatService] getVehicleDetail error: $e');
      return null;
    }
  }

  /// GET /riwayat/vehicles/{vehicleId}/service-history — Riwayat service kendaraan
  Future<Map<String, dynamic>?> getServiceHistory(int vehicleId) async {
    try {
      print('🔵 [RiwayatService] Fetching service history for vehicle: $vehicleId');
      final response = await http.get(
        Uri.parse('$baseUrl/customer/riwayat/vehicles/$vehicleId/service-history'),
        headers: _getHeaders(),
      );

      print('🔵 [RiwayatService] Service history status: ${response.statusCode}');
      print('🔵 [RiwayatService] Service history body: ${response.body}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true) {
          return Map<String, dynamic>.from(body['data']);
        }
      }
      return null;
    } catch (e) {
      print('❌ [RiwayatService] getServiceHistory error: $e');
      return null;
    }
  }
}
