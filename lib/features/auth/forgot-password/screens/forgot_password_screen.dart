import 'package:flutter/material.dart';
import '../../../../widgets/auth_wrapper.dart';
import '../../../../core/services/auth_service.dart';
// 1. INI IMPORT YANG KURANG UNTUK MENGATASI ERROR KEDUA:
import '../../reset-password/screens/verify_otp_screen.dart'; 

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  void _kirimLink() async {
    // Validasi email kosong
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email tidak boleh kosong')),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    // Pastikan auth_service.dart sudah disave agar fungsi ini terbaca
    final result = await AuthService().forgotPassword(_emailController.text);
    
    setState(() => _isLoading = false);

    if (!mounted) return; // Mencegah error jika widget sudah di-dispose

    if (result['success']) {
      // Pindah ke halaman reset sambil membawa data email
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyOtpScreen(email: _emailController.text),
        ),
      );
    }
    
    // Tampilkan pesan berhasil/gagal dari Laravel
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Lupa Password?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Masukkan email terdaftar untuk menerima tautan reset.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 32),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'email@gmail.com', 
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _kirimLink,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF119CFF), 
                padding: const EdgeInsets.symmetric(vertical: 16)
              ),
              child: _isLoading 
                  ? const SizedBox(
                      height: 20, width: 20, 
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    ) 
                  : const Text('Kirim Tautan', style: TextStyle(color: Colors.white)),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context), 
              child: const Text('Kembali ke Login', style: TextStyle(color: Colors.grey))
            )
          ),
        ],
      ),
    );
  }
}