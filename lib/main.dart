import 'package:flutter/material.dart';
// Import file LoginScreen
import 'package:motocare/features/auth/login/screens/login_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan pita "Debug"
      title: 'MotoCare',
      
      // Pengaturan Tema Global
      theme: ThemeData(
        // Menyesuaikan warna utama aplikasi dengan tombol biru MotoCare
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF119CFF)),
        useMaterial3: true,
        fontFamily: 'Poppins', // Opsional: jika kamu memakai font Poppins
      ),

      // PINTU MASUK: Diarahkan ke LoginScreen
      home: const LoginScreen(), 
    );
  }
}