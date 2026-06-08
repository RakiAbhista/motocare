import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:motocare/core/services/auth_service.dart';

class ProfileService {
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = AuthService().accessToken;
      final baseUrl = AuthService().baseUrl;

      final response = await http.get(
        Uri.parse('$baseUrl/customer-service/profile'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = body['data'] as Map<String, dynamic>;
        return {
          'success': true,
          'name': data['name'] ?? '',
          'role': data['role'] ?? '',
          'email': data['email'] ?? '',
          'phone_number': data['phone_number'] ?? '',
        };
      } else {
        return {'success': false, 'message': 'Gagal memuat profil'};
      }
    } catch (e) {
      print('Profile Error: $e');
      return {'success': false, 'message': 'Gagal terhubung ke server'};
    }
  }

  Future<Map<String, dynamic>> updateProfile(String name, String phoneNumber) async {
    try {
      final token = AuthService().accessToken;
      final baseUrl = AuthService().baseUrl;

      final response = await http.put(
        Uri.parse('$baseUrl/customer-service/profile'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'phone_number': phoneNumber,
        }),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Profil berhasil diperbarui'};
      } else {
        return {'success': false, 'message': body['message'] ?? 'Gagal memperbarui profil'};
      }
    } catch (e) {
      print('Profile Update Error: $e');
      return {'success': false, 'message': 'Gagal terhubung ke server'};
    }
  }
}
