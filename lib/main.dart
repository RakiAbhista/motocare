import 'package:flutter/material.dart';
import 'package:motocare/features/auth/login/screens/login_screen.dart';
import 'package:motocare/core/services/auth_service.dart';
import 'package:motocare/widgets/main_wrapper.dart';
import 'package:flutter/services.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/features/mechanic/home/screens/beranda_screen.dart' as mechanic;
import 'package:motocare/features/cs/home/screens/beranda_screen.dart' as cs;
import 'package:motocare/core/services/background_location_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:motocare/firebase_options.dart';
import 'package:motocare/core/services/fcm_service.dart';
import 'package:motocare/core/utils/globals.dart';

import 'package:motocare/features/cs/emergency/screens/emergency_assignment_screen.dart';
import 'package:motocare/features/customer/emergency/screens/detail_emergency_screen.dart' as customer_emergency;
import 'package:motocare/features/cs/home/screens/payment_service_screen.dart';
import 'package:motocare/features/cs/home/screens/detail_order_screen.dart';
import 'package:motocare/features/cs/shared/enums/service_status.dart';

/// Top-level background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('🔵 [FCM] Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Set status bar to match primary color with light icons for consistency across screens
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColors.primary,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  ));
  await AuthService().loadTokenFromStorage();
  await initializeBackgroundService();

  // Inisialisasi Firebase & FCM
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FcmService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget _getHomeWidget() {
    final token = AuthService().accessToken;
    if (token == null) {
      return const LoginScreen();
    }
    
    final role = AuthService().role;
    if (role == 'mechanic') {
      return const mechanic.MechanicDashboard();
    } else if (role == 'customer_service') {
      return const cs.BerandaScreen();
    } else {
      return const MainWrapper();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MotoCare',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF119CFF)),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      navigatorKey: navigatorKey,
      home: _getHomeWidget(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => _getHomeWidget(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail-emergency-cs') {
          final id = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => EmergencyAssignmentScreen(emergencyId: id),
          );
        } else if (settings.name == '/detail-emergency') {
          final id = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => customer_emergency.DetailEmergencyScreen(
              emergencyType: 'mekanik', // Default type
              emergencyId: id,
            ),
          );
        } else if (settings.name == '/payment') {
          final id = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => PaymentServiceScreen(
              orderId: id,
              totalAmount: 0.0, // Default if not in payload
            ),
          );
        } else if (settings.name == '/payment-completed') {
          return MaterialPageRoute(
            builder: (context) => const MainWrapper(initialIndex: 1), // History tab
          );
        } else if (settings.name == '/detail-booking') {
          final id = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => DetailOrderScreen(
              orderId: id,
              status: ServiceStatus.pending, // Default fallback
            ),
          );
        }
        return null;
      },
    );
  }
}