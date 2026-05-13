import 'package:flutter/material.dart';

// Import untuk halaman Customer
import 'widgets/main_wrapper.dart';

// Import untuk halaman Mechanic (Sesuaikan path ini jika ada error)
import 'package:motocare/features/mechanic/home/screens/beranda_screen.dart';
import 'package:motocare/core/theme/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motocare',
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
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
        title: const Text('Pilih Role - Motocare'),
        centerTitle: true,
      ),
      body: Center(
        // Menggunakan Column agar tombol berjejer ke bawah
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tombol 1: Masuk ke Customer
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(250, 50), // Menyamakan ukuran tombol
              ),
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const MainWrapper()));
              },
              child: const Text(
                'Masuk ke Customer Home',
                style: TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 20), // Memberikan jarak antar tombol
            // Tombol 2: Masuk ke Mechanic
            // Tombol 2: Masuk ke Mechanic
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(250, 50),
                backgroundColor: AppColors.primaryLight,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MechanicDashboard()),
                );
              },
              child: Text(
                // <-- Hapus tulisan 'const' di sini
                'Masuk ke Mechanic Home',
                style: const TextStyle(fontSize: 16, color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
