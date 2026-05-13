import 'package:flutter/material.dart';
import '../../../../widgets/auth_wrapper.dart';
import '../../../../core/services/auth_service.dart';
import 'new_password_screen.dart'; // Import screen selanjutnya

class VerifyOtpScreen extends StatefulWidget {
  final String email;
  const VerifyOtpScreen({super.key, required this.email});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;

  void _verifikasiOtp() async {
    if (_otpController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan 6 digit kode OTP')),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    // Kita panggil fungsi verifyOtp di AuthService
    final result = await AuthService().verifyOtp(widget.email, _otpController.text);
    
    setState(() => _isLoading = false);

    if (result['success']) {
      // Jika sukses, pindah ke halaman New Password
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewPasswordScreen(
            email: widget.email,
            otp: _otpController.text,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Verifikasi OTP', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Masukkan 6 digit kode yang dikirim ke ${widget.email}', style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 32),
          
          const Text('Kode OTP', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: InputDecoration(
              hintText: '123456',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _verifikasiOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF119CFF),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text('Verifikasi Kode', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}