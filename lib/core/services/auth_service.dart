import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Untuk Android Emulator gunakan 10.0.2.2, untuk device gunakan IP mesin development
  // Contoh: 'http://192.168.1.X:8000/api/v1' atau 'http://10.0.2.2:8000/api/v1'
  final String baseUrl = 'http://192.168.0.110:8000/api/v1';
  // final String baseUrl = 'http://172.16.162.206:8000/api/v1';
  // final String baseUrl = 'http://192.168.1.7:8000/api/v1';
  // final String baseUrl = 'http://192.168.1.12:8000/api/v1';

  String? _accessToken;
  String? _role;
  int? _userId;
  int? _mechanicId;

  String? get accessToken => _accessToken;
  String? get role => _role;
  int? get userId => _userId;
  int? get mechanicId => _mechanicId;

  /// Load token dan role dari SharedPreferences saat app dimulai
  Future<void> loadTokenFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _accessToken = prefs.getString('access_token');
      _role = prefs.getString('user_role');
      _userId = prefs.getInt('user_id');
      _mechanicId = prefs.getInt('mechanic_id');
      print(
        '🔵 [AuthService] Loaded token from storage: ${_accessToken != null ? 'SUCCESS' : 'EMPTY'}',
      );
      print(
        '🔵 [AuthService] Loaded role from storage: $_role, userId: $_userId, mechanicId: $_mechanicId',
      );
    } catch (e) {
      print('❌ [AuthService] Error loading auth data: $e');
    }
  }

  Future<void> _saveAuthToStorage(
    String token,
    String role,
    int userId, {
    int? mechanicId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', token);
      await prefs.setString('user_role', role);
      await prefs.setInt('user_id', userId);
      if (mechanicId != null) {
        await prefs.setInt('mechanic_id', mechanicId);
      }
      print('🔵 [AuthService] Auth data saved to storage');
    } catch (e) {
      print('❌ [AuthService] Error saving auth data: $e');
    }
  }

  /// Clear semua data dari storage
  Future<void> _clearStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      await prefs.remove('user_role');
      await prefs.remove('user_id');
      await prefs.remove('mechanic_id');
      print('🔵 [AuthService] Storage cleared');
    } catch (e) {
      print('❌ [AuthService] Error clearing storage: $e');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    print('🔵 [Login] Attempting login for: $email');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password},
      );

      final data = jsonDecode(response.body);
      print('🔵 [Login] Status: ${response.statusCode}');
      print('🔵 [Login] Response: ${response.body}');

      if (response.statusCode == 200) {
        _accessToken = data['access_token'];
        _role = data['user']?['role'] ?? 'customer';
        _userId = data['user']?['id'];
        _mechanicId = data['user']?['mechanic_id'];
        if (_userId != null) {
          await _saveAuthToStorage(
            _accessToken!,
            _role!,
            _userId!,
            mechanicId: _mechanicId,
          );
        }
      }

      return {
        'success': response.statusCode == 200,
        'role': data['user']?['role'],
        'access_token': data['access_token'],
        'user': data['user'],
        'message': data['message'],
      };
    } catch (e, stackTrace) {
      print('❌ [Login] ERROR: $e');
      print(stackTrace);
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
        'message': body['message'] ?? 'Berhasil',
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
      return {
        'success': response.statusCode == 200,
        'message': body['message'],
      };
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
        _role = body['user']?['role'] ?? _role ?? 'customer';
        _userId = body['user']?['id'] ?? _userId;
        _mechanicId = body['user']?['mechanic_id'] ?? _mechanicId;
        if (_userId != null) {
          await _saveAuthToStorage(
            _accessToken!,
            _role!,
            _userId!,
            mechanicId: _mechanicId,
          );
        }
      }

      return {
        'success': response.statusCode == 200,
        'message': body['message'],
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
      return {
        'success': response.statusCode == 200,
        'message': body['message'],
      };
    } catch (e) {
      return {'success': false, 'message': 'Koneksi gagal'};
    }
  }

  Future<Map<String, dynamic>> logout() async {
    print('🔵 [Logout] Starting logout...');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: {
          'Accept': 'application/json',
          if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
        },
      );

      print('🔵 [Logout] Status: ${response.statusCode}');
      print('🔵 [Logout] Response: ${response.body}');

      // Clear token, role, dan storage regardless of response
      _accessToken = null;
      _role = null;
      _userId = null;
      _mechanicId = null;
      await _clearStorage();

      final body = jsonDecode(response.body);
      return {
        'success': response.statusCode == 200,
        'message': body['message'] ?? 'Logout berhasil',
      };
    } catch (e) {
      print('❌ [Logout] Error: $e');
      // Still clear token and role even if request fails
      _accessToken = null;
      _role = null;
      _userId = null;
      _mechanicId = null;
      await _clearStorage();
      return {'success': false, 'message': 'Logout berhasil (offline mode)'};
    }
  }
}
