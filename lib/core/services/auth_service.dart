import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'http://localhost:8000/api/v1';

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password},
      );
      
      final data = jsonDecode(response.body);
      
      return {
        'success': response.statusCode == 200,
        'role': data['user']?['role'], // AMBIL ROLE DARI SINI
        'message': data['message']
      };
    } catch (e) {
      return {'success': false, 'message': 'Gagal terhubung ke server'};
    }
  }

  Future<Map<String, dynamic>> register(Map<String, String> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Accept': 'application/json'},
        body: data,
      );
      final body = jsonDecode(response.body);
      return {'success': response.statusCode == 201, 'message': body['message'] ?? 'Berhasil'};
    } catch (e) {
      return {'success': false, 'message': 'Koneksi ke server gagal'};
    }
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/forgot-password'),
        headers: {'Accept': 'application/json'},
        body: {'email': email},
      );
      final body = jsonDecode(response.body);
      return {'success': response.statusCode == 200, 'message': body['message']};
    } catch (e) {
      return {'success': false, 'message': 'Koneksi ke server gagal'};
    }
  }

  Future<Map<String, dynamic>> resetPassword(Map<String, String> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/reset-password'),
        headers: {'Accept': 'application/json'},
        body: data,
      );
      final body = jsonDecode(response.body);
      return {'success': response.statusCode == 200, 'message': body['message']};
    } catch (e) {
      return {'success': false, 'message': 'Koneksi ke server gagal'};
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-otp'),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'token': otp},
      );
      final body = jsonDecode(response.body);
      return {'success': response.statusCode == 200, 'message': body['message']};
    } catch (e) {
      return {'success': false, 'message': 'Koneksi gagal'};
    }
  }
}