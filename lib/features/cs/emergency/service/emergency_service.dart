import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:motocare/core/services/auth_service.dart';
import 'package:motocare/features/cs/emergency/models/emergency_model.dart';

class EmergencyService {
  Future<Map<String, dynamic>> getEmergencies() async {
    try {
      final token = AuthService().accessToken;
      final baseUrl = AuthService().baseUrl;

      final response = await http.get(
        Uri.parse('$baseUrl/customer-service/emergencies'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final rawList = body['data'] as List<dynamic>;
        final emergencies = rawList
            .map((item) => EmergencyModel.fromJson(item as Map<String, dynamic>))
            .toList();

        return {
          'success': true,
          'data': emergencies,
        };
      } else {
        print('Emergency API Error: ${response.statusCode} - ${response.body}');
        return {'success': false, 'message': 'Gagal memuat data darurat'};
      }
    } catch (e) {
      print('Emergency Error: $e');
      return {'success': false, 'message': 'Gagal terhubung ke server'};
    }
  }

  Future<Map<String, dynamic>> getEmergencyDetail(int id) async {
    try {
      final token = AuthService().accessToken;
      final baseUrl = AuthService().baseUrl;

      final response = await http.get(
        Uri.parse('$baseUrl/customer-service/emergencies/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == 'success') {
        final data = body['data'] as Map<String, dynamic>;
        final emergency = EmergencyModel.fromJson(data);

        return {
          'success': true,
          'data': emergency,
        };
      } else {
        print('Emergency API Error: ${response.statusCode} - ${response.body}');
        return {'success': false, 'message': 'Gagal memuat detail darurat'};
      }
    } catch (e) {
      print('Emergency Detail Error: $e');
      return {'success': false, 'message': 'Gagal terhubung ke server'};
    }
  }

  Future<Map<String, dynamic>> getMechanics() async {
    try {
      final token = AuthService().accessToken;
      final baseUrl = AuthService().baseUrl;

      final response = await http.get(
        Uri.parse('$baseUrl/customer-service/mechanics'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['status'] == 'success') {
        return {
          'success': true,
          'data': body['data'] as List<dynamic>,
        };
      } else {
        print('Mechanic API Error: ${response.statusCode} - ${response.body}');
        return {'success': false, 'message': 'Gagal memuat data mekanik'};
      }
    } catch (e) {
      print('Mechanic Error: $e');
      return {'success': false, 'message': 'Gagal terhubung ke server'};
    }
  }

    Future<Map<String, dynamic>> assignMechanic({
    required int emergencyId,
    required int mechanicId,
  }) async {
    try {
      final token = AuthService().accessToken;
      final baseUrl = AuthService().baseUrl;

      final response = await http.put(
        Uri.parse('$baseUrl/customer-service/emergencies/$emergencyId/assign'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'mechanic_id': mechanicId}),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['success'] == true) {
        return {
          'success': true,
          'data': body['data'],
          'message': body['message'] ?? 'Mekanik berhasil di-assign',
        };
      } else {
        print('Assign Mechanic API Error: ${response.statusCode} - ${response.body}');
        return {
          'success': false,
          'message': body['message'] ?? 'Gagal assign mekanik',
        };
      }
    } catch (e) {
      print('Assign Mechanic Error: $e');
      return {'success': false, 'message': 'Gagal terhubung ke server'};
    }
  }

}
