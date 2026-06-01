import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class CustomerHomeService {
  final String baseUrl = 'http://10.0.2.2:8000/api/v1';

  Future<Map<String, dynamic>> getHomeData() async {
    try {
      final token = AuthService().accessToken;
      print('Fetching home data from: $baseUrl/customer/home');
      final response = await http.get(
        Uri.parse('$baseUrl/customer/home'),
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      
      print('Home data response status: ${response.statusCode}');
      print('Home data response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body;
      } else {
        return {'success': false, 'message': 'Gagal mengambil data beranda: ${response.statusCode}'};
      }
    } catch (e) {
      print('Home data error: $e');
      return {'success': false, 'message': 'Koneksi ke server gagal: $e'};
    }
  }
}
