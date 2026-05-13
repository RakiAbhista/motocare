import 'package:flutter/material.dart';
import '../../../../widgets/auth_wrapper.dart';
import '../../../../core/services/auth_service.dart';

class NewPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;
  const NewPasswordScreen({super.key, required this.email, required this.otp});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _passController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isObscure1 = true;
  bool _isObscure2 = true;
  bool _isLoading = false;

  void _updatePassword() async {
    if (_passController.text != _confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Konfirmasi password tidak cocok')));
      return;
    }

    setState(() => _isLoading = true);
    
    final result = await AuthService().resetPassword({
      'email': widget.email,
      'token': widget.otp,
      'password': _passController.text,
      'password_confirmation': _confirmController.text,
    });

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'])));

    if (result['success']) {
      // Kembali ke halaman Login (paling awal)
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Password Baru', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Silakan buat password baru yang aman.', style: TextStyle(color: Colors.grey)),
          
          const SizedBox(height: 32),
          _buildField('Password Baru', _passController, _isObscure1, () => setState(() => _isObscure1 = !_isObscure1)),
          _buildField('Konfirmasi Password', _confirmController, _isObscure2, () => setState(() => _isObscure2 = !_isObscure2)),
          
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _updatePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF119CFF),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading 
                ? const CircularProgressIndicator(color: Colors.white) 
                : const Text('Simpan Password', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController cont, bool obs, VoidCallback onToggle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.only(top: 16, bottom: 8), child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
        TextFormField(
          controller: cont,
          obscureText: obs,
          decoration: InputDecoration(
            hintText: '••••••••',
            suffixIcon: IconButton(icon: Icon(obs ? Icons.visibility_off : Icons.visibility), onPressed: onToggle),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}