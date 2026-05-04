import 'package:flutter/material.dart';
import '../../../../widgets/auth_wrapper.dart';
import '../../../../core/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isObscure1 = true;
  bool _isObscure2 = true;
  bool _isLoading = false;
  String _selectedRole = 'customer';

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  void _prosesRegister() async {
    setState(() => _isLoading = true);
    final result = await AuthService().register({
      'name': _nameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
      'password_confirmation': _confirmController.text,
      'role': _selectedRole,
    });
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'])));
    if (result['success']) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AuthWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Daftar Akun', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          _buildField('Nama Lengkap', _nameController, 'Masukkan nama'),
          _buildField('Email', _emailController, 'email@gmail.com'),
          
          const Padding(
            padding: EdgeInsets.only(top: 16, bottom: 8),
            child: Text('Daftar Sebagai', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          DropdownButtonFormField<String>(
            value: _selectedRole,
            items: const [
              DropdownMenuItem(value: 'customer', child: Text('Customer')),
              DropdownMenuItem(value: 'mechanic', child: Text('Mechanic')),
            ],
            onChanged: (v) => setState(() => _selectedRole = v!),
            decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          ),

          _buildField('Password', _passwordController, '••••••••', isPass: true, obs: _isObscure1, 
              onToggle: () => setState(() => _isObscure1 = !_isObscure1)),
          _buildField('Konfirmasi Password', _confirmController, '••••••••', isPass: true, obs: _isObscure2, 
              onToggle: () => setState(() => _isObscure2 = !_isObscure2)),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _prosesRegister,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF119CFF), padding: const EdgeInsets.symmetric(vertical: 14)),
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Daftar', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController cont, String hint, {bool isPass = false, bool? obs, VoidCallback? onToggle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.only(top: 16, bottom: 8), child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
        TextFormField(
          controller: cont,
          obscureText: isPass ? obs! : false,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: isPass ? IconButton(icon: Icon(obs! ? Icons.visibility_off : Icons.visibility), onPressed: onToggle) : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}