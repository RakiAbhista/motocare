import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Untuk Android Emulator gunakan 10.0.2.2, untuk device gunakan IP mesin development
  // Contoh: 'http://192.168.1.X:8000/api/v1' atau 'http://10.0.2.2:8000/api/v1'
  final String baseUrl = 'http://localhost:8000/api/v1';
  String? _accessToken;

  String? get accessToken => _accessToken;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password},
      );
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        _accessToken = data['access_token'];
      }
      
      return {
        'success': response.statusCode == 200,
        'role': data['user']?['role'],
        'access_token': data['access_token'],
        'user': data['user'],
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
      
      if (response.statusCode == 201) {
        _accessToken = body['access_token'];
      }
      
      return {
        'success': response.statusCode == 201,
        'access_token': body['access_token'],
        'user': body['user'],
        'message': body['message'] ?? 'Berhasil'
      };
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
      
      if (response.statusCode == 200) {
        _accessToken = body['access_token'];
      }
      
      return {
        'success': response.statusCode == 200,
        'message': body['message']
      };
    } catch (e) {
      return {'success': false, 'message': 'Koneksi ke server gagal'};
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-otp'),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'otp': otp},
      );
      final body = jsonDecode(response.body);
      return {'success': response.statusCode == 200, 'message': body['message']};
    } catch (e) {
      return {'success': false, 'message': 'Koneksi gagal'};
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: {
          'Accept': 'application/json',
          if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
        },
      );
      
      if (response.statusCode == 200) {
        _accessToken = null;
      }
      
      final body = jsonDecode(response.body);
      return {
        'success': response.statusCode == 200,
        'message': body['message'] ?? 'Logout berhasil'
      };
    } catch (e) {
      return {'success': false, 'message': 'Koneksi ke server gagal'};
    }
  }
}