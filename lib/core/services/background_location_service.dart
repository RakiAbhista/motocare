import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'motocare_tracking', 
    'Lokasi Mekanik',
    description: 'Notifikasi ini digunakan untuk melacak lokasi Anda saat menuju ke pelanggan.',
    importance: Importance.high, 
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
      notificationChannelId: 'motocare_tracking',
      initialNotificationTitle: 'MotoCare Mechanic',
      initialNotificationContent: 'Membagikan lokasi ke pelanggan...',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // Gunakan stream untuk menghindari Binder transaction failure / DeadSystemException
  // karena buka-tutup koneksi GPS (getCurrentPosition) secara berulang.
  Position? latestPosition;
  StreamSubscription<Position>? positionStream;

  try {
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // Update jika bergerak minimal 5 meter
      ),
    ).listen((Position position) {
      latestPosition = position;
    });
  } catch (e) {
    print('Failed to start position stream: $e');
  }

  service.on('stopService').listen((event) {
    positionStream?.cancel();
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 10), (timer) async {
    final prefs = await SharedPreferences.getInstance();
    final mechanicId = prefs.getInt('bg_mechanic_id');
    final token = prefs.getString('bg_token');
    final baseUrl = prefs.getString('bg_base_url');

    if (mechanicId == null || token == null || baseUrl == null) return;
    
    if (latestPosition == null) return;
    
    try {
      final url = Uri.parse('$baseUrl/customer-mechanic/update-location/$mechanicId');
      final payload = jsonEncode({
        'latitude': latestPosition!.latitude.toString(),
        'longitude': latestPosition!.longitude.toString(),
      });

      print('🔵 [BackgroundService] Mengirim lokasi ke: $url');
      print('🔵 [BackgroundService] Payload: $payload');

      final response = await http.put(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: payload,
      );

      print('🔵 [BackgroundService] Status Response: ${response.statusCode}');
      print('🔵 [BackgroundService] Body Response: ${response.body}');

      if (response.statusCode == 401) {
        // Token expired
        print('❌ [BackgroundService] Token kadaluarsa (401), menghentikan service.');
        positionStream?.cancel();
        service.stopSelf();
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == false) {
          // Explicit failure, maybe cancelled or not dispatched anymore
          print('❌ [BackgroundService] Respon gagal dari server: ${data['message']}');
          positionStream?.cancel();
          service.stopSelf();
        }
      } else {
        // Other unexpected status, maybe stop if it's 404 (Not Found)
        if (response.statusCode == 404) {
          print('❌ [BackgroundService] Endpoint tidak ditemukan (404), menghentikan service.');
          positionStream?.cancel();
          service.stopSelf();
        }
      }
    } catch (e) {
      print('❌ [BackgroundService] Error pengiriman lokasi: $e');
    }
  });
}
