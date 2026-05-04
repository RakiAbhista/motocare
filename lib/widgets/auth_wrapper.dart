// lib/widgets/auth_wrapper.dart
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  final Widget child;

  const AuthWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.02, 1.0], // 2% sampai 100%
            colors: [
              Color(0xFF3564C4),
              Color(0xFF119CFF),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const SizedBox(height: 60), // Ruang untuk area biru di atas
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                    child: child, // Isi form akan masuk ke sini
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}