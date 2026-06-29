import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:motocare/core/services/auth_service.dart';
import 'package:motocare/core/utils/globals.dart';

class FcmService {
  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  FcmService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    // 1. Request Permission (Android 13+ & iOS)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('🔵 [FCM] User granted permission: ${settings.authorizationStatus}');

    // 2. Initialize Local Notifications
    const androidInitSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosInitSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    await _localNotificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          _handleNotificationTap(jsonDecode(response.payload!));
        }
      },
    );

    // Create Notification Channel for Android (High Importance)
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
      );

      await _localNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    // 3. Listen to Foreground Messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('🔵 [FCM] Message received in foreground: ${message.messageId}');
      _showLocalNotification(message);
    });

    // 4. Listen to Background/Terminated Tap
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('🔵 [FCM] Message opened from background: ${message.messageId}');
      _handleNotificationTap(message.data);
    });

    // Check if app was opened from terminated state
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print('🔵 [FCM] Message opened from terminated: ${initialMessage.messageId}');
      // Tunda sedikit agar Navigator siap
      Future.delayed(const Duration(seconds: 1), () {
        _handleNotificationTap(initialMessage.data);
      });
    }

    // 5. Listen to Token Refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print('🔵 [FCM] Token refreshed: $newToken');
      _sendTokenToBackend(newToken);
    });

    _isInitialized = true;
  }

  void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification != null && android != null) {
      _localNotificationsPlugin.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription: 'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/launcher_icon',
          ),
          iOS: DarwinNotificationDetails(),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }

  void _handleNotificationTap(Map<String, dynamic> data) {
    if (data.isEmpty) return;

    final type = data['type'] as String?;
    if (type == null) return;

    print('🔵 [FCM] Handling notification tap with type: $type');

    // Menggunakan navigatorKey untuk routing berdasarkan payload
    switch (type) {
      case 'new_emergency':
        if (data['emergency_id'] != null) {
          navigatorKey.currentState?.pushNamed(
            '/detail-emergency-cs',
            arguments: int.tryParse(data['emergency_id'].toString()),
          );
        }
        break;
      case 'emergency_dispatched':
      case 'mechanic_arrived':
      case 'towing_requested':
        if (data['emergency_id'] != null) {
          navigatorKey.currentState?.pushNamed(
            '/detail-emergency',
            arguments: int.tryParse(data['emergency_id'].toString()),
          );
        }
        break;
      case 'payment_required':
        if (data['order_id'] != null) {
          navigatorKey.currentState?.pushNamed(
            '/payment',
            arguments: int.tryParse(data['order_id'].toString()),
          );
        }
        break;
      case 'payment_completed':
        if (data['order_id'] != null) {
          navigatorKey.currentState?.pushNamed(
            '/payment-completed',
            arguments: int.tryParse(data['order_id'].toString()),
          );
        }
        break;
      case 'new_booking':
        if (data['booking_id'] != null) {
          navigatorKey.currentState?.pushNamed(
            '/detail-booking',
            arguments: int.tryParse(data['booking_id'].toString()),
          );
        }
        break;
      default:
        print('🔵 [FCM] Unknown notification type: $type');
    }
  }

  Future<void> uploadFcmToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      if (token != null) {
        print('🔵 [FCM] Current FCM Token: $token');
        await _sendTokenToBackend(token);
      }
    } catch (e) {
      print('❌ [FCM] Error getting FCM Token: $e');
    }
  }

  Future<void> _sendTokenToBackend(String fcmToken) async {
    final authToken = AuthService().accessToken;
    if (authToken == null) return;

    try {
      final response = await http.post(
        Uri.parse('${AuthService().baseUrl}/auth/fcm-token'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: {'fcm_token': fcmToken},
      );

      print('🔵 [FCM] Update token status: ${response.statusCode}');
      if (response.statusCode != 200) {
        print('❌ [FCM] Failed to update token: ${response.body}');
      }
    } catch (e) {
      print('❌ [FCM] Error sending token to backend: $e');
    }
  }
}
