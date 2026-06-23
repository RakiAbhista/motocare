import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:motocare/core/services/auth_service.dart';
 
class ProfileService {
  static final ProfileService _instance = ProfileService._internal();
  factory ProfileService() => _instance;
  ProfileService._internal();
 
  final AuthService _auth = AuthService();
 
  String get _baseUrl => '${_auth.baseUrl}/mechanic';
 
  Map<String, String> get _headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (_auth.accessToken != null)
          'Authorization': 'Bearer ${_auth.accessToken}',
      };
 
  /// GET /api/v1/mechanic/profile
  /// Ambil data profil mekanik yang sedang login
  Future<Map<String, dynamic>> getProfile() async {
    print('🔵 [MechanicProfileService] getProfile()');
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/profile'),
        headers: _headers,
      );
 
      print('🔵 [getProfile] Status: ${response.statusCode}');
      print('🔵 [getProfile] Response: ${response.body}');
 
      final body = jsonDecode(response.body);
 
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': body['data'],
        };
      }
 
      return {
        'success': false,
        'message': body['message'] ?? 'Gagal mengambil profil',
      };
    } catch (e) {
      print('❌ [getProfile] Error: $e');
      return {'success': false, 'message': 'Gagal terhubung ke server'};
    }
  }
 
  /// PUT /api/v1/mechanic/profile/phone
  /// Update nomor telepon mekanik
  Future<Map<String, dynamic>> updatePhone(String nomorTelepon) async {
    print('🔵 [MechanicProfileService] updatePhone()');
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/profile/phone'),
        headers: _headers,
        body: jsonEncode({'nomor_telepon': nomorTelepon}),
      );
 
      print('🔵 [updatePhone] Status: ${response.statusCode}');
      print('🔵 [updatePhone] Response: ${response.body}');
 
      final body = jsonDecode(response.body);
 
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': body['message'],
          'data': body['data'],
        };
      }
 
      return {
        'success': false,
        'message': body['message'] ?? 'Gagal memperbarui nomor telepon',
        'errors': body['errors'],
      };
    } catch (e) {
      print('❌ [updatePhone] Error: $e');
      return {'success': false, 'message': 'Gagal terhubung ke server'};
    }
  }
 
  /// PUT /api/v1/mechanic/profile/status
  /// Update status kerja mekanik (available / offline)
  Future<Map<String, dynamic>> updateStatus(bool statusKerja) async {
    print('🔵 [MechanicProfileService] updateStatus($statusKerja)');
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/profile/status'),
        headers: _headers,
        body: jsonEncode({'status_kerja': statusKerja}),
      );
 
      print('🔵 [updateStatus] Status: ${response.statusCode}');
      print('🔵 [updateStatus] Response: ${response.body}');
 
      final body = jsonDecode(response.body);
 
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': body['message'],
          'data': body['data'],
        };
      }
 
      return {
        'success': false,
        'message': body['message'] ?? 'Gagal memperbarui status kerja',
      };
    } catch (e) {
      print('❌ [updateStatus] Error: $e');
      return {'success': false, 'message': 'Gagal terhubung ke server'};
    }
  }
 
  /// GET /api/v1/mechanic/profile/work-history
  /// Ambil riwayat servis yang sudah selesai
  Future<Map<String, dynamic>> getWorkHistory() async {
    print('🔵 [MechanicProfileService] getWorkHistory()');
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/profile/work-history'),
        headers: _headers,
      );
 
      print('🔵 [getWorkHistory] Status: ${response.statusCode}');
      print('🔵 [getWorkHistory] Response: ${response.body}');
 
      final body = jsonDecode(response.body);
 
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': body['data'],
        };
      }
 
      return {
        'success': false,
        'message': body['message'] ?? 'Gagal mengambil riwayat kerja',
      };
    } catch (e) {
      print('❌ [getWorkHistory] Error: $e');
      return {'success': false, 'message': 'Gagal terhubung ke server'};
    }
  }
}
 