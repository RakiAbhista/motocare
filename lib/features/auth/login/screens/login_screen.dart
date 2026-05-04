import 'package:flutter/material.dart';
import '../../../../widgets/auth_wrapper.dart';
import '../../../../core/services/auth_service.dart';
import '../../register/screens/register_screen.dart';
import '../../forgot-password/screens/forgot_password_screen.dart';
// Import halaman tujuan setelah login
import '../../../admin/dashboard/screens/dashboard_screen.dart'; 
// import '../../home/screens/home_screen.dart'; // Aktifkan jika sudah ada file HomeScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true;
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    // 1. Validasi Input
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password wajib diisi!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // 2. Panggil API Login
    final result = await AuthService().login(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    // 3. Logika Navigasi Berdasarkan Role
    if (result['success']) {
      final String role = result['role'] ?? 'customer';

      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardAdminScreen()),
        );
      } else {
        // Arahkan ke HomeScreen untuk role customer atau lainnya
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const HomeScreen()),
        // );
        
        // Sementara kasih pesan sukses jika HomeScreen belum dibuat
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Berhasil (Customer)!')),
        );
      }
    } else {
      // Tampilkan pesan error dari backend
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Login Gagal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Login',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Masuk untuk melanjutkan ke MotoCare',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 32),
          
          // Field Email
          const Text('Email', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'email@gmail.com',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Field Password
          const Text('Password', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordController,
            obscureText: _isObscure,
            decoration: InputDecoration(
              hintText: '••••••••',
              suffixIcon: IconButton(
                icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _isObscure = !_isObscure),
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                );
              },
              child: const Text('Lupa Password?', style: TextStyle(color: Color(0xFF119CFF))),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Tombol Login
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF119CFF),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20, 
                      width: 20, 
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Masuk', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Link ke Register
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Belum punya akun? ', style: TextStyle(color: Colors.grey)),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text(
                  'Daftar di sini',
                  style: TextStyle(color: Color(0xFF119CFF), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}