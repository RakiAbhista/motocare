import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets/main_wrapper.dart';

/// IMPORT DENGAN ALIAS
import 'package:motocare/features/customer/home/screens/beranda_screen.dart'
as customer;

import 'package:motocare/features/cs/home/screens/beranda_screen.dart'
as cs;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motocare',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: GoogleFonts.mulish().fontFamily,
      ),
      home: const HomeEntryScreen(),
    );
  }
}

class HomeEntryScreen extends StatelessWidget {
  const HomeEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Motocare'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// CUSTOMER
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const customer.BerandaScreen(),
                  ),
                );
              },
              child: const Text('Masuk Customer'),
            ),

            const SizedBox(height: 20),

            /// CS
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const cs.BerandaScreen(),
                  ),
                );
              },
              child: const Text('Masuk CS'),
            ),
          ],
        ),
      ),
    );
  }
}