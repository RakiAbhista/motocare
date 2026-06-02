import 'package:flutter/material.dart';
import 'package:motocare/features/auth/login/screens/login_screen.dart';
import 'package:motocare/core/services/auth_service.dart';
import 'package:motocare/widgets/main_wrapper.dart'; // sesuaikan import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService().loadTokenFromStorage();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: AuthService().accessToken != null
          ? const MainWrapper()
          : const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainWrapper(),
      },
    );
  }
}