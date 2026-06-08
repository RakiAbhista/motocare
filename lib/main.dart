import 'package:flutter/material.dart';
import 'package:motocare/features/auth/login/screens/login_screen.dart';
import 'package:motocare/core/services/auth_service.dart';
import 'package:motocare/widgets/main_wrapper.dart';
import 'package:motocare/features/mechanic/home/screens/beranda_screen.dart' as mechanic;
import 'package:motocare/features/cs/home/screens/beranda_screen.dart' as cs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService().loadTokenFromStorage();
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
      home: _getHomeWidget(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => _getHomeWidget(),
      },
    );
  }
}