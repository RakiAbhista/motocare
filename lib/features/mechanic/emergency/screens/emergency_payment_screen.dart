import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/features/cs/home/service/mechanic_emergency_service.dart';

import 'package:motocare/features/mechanic/emergency/screens/emergency_screen.dart';

class EmergencyPaymentScreen extends StatefulWidget {
  final int emergencyId;
  final double totalAmount;

  const EmergencyPaymentScreen({
    super.key,
    required this.emergencyId,
    required this.totalAmount,
  });

  @override
  State<EmergencyPaymentScreen> createState() => _EmergencyPaymentScreenState();
}

class _EmergencyPaymentScreenState extends State<EmergencyPaymentScreen>
    with SingleTickerProviderStateMixin {
  final MechanicEmergencyService _svc = MechanicEmergencyService();
  final ImagePicker _picker = ImagePicker();
  File? _paymentProof;
  bool _uploading = false;
  String _paymentType = 'transfer'; // 'transfer' or 'cash'
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _formatCurrency(double value) {
    final intVal = value.round();
    final str = intVal.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return 'Rp $buffer';
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source, maxWidth: 1200, maxHeight: 1200, imageQuality: 85,
      );
      if (picked != null) setState(() => _paymentProof = File(picked.path));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil gambar: $e'), backgroundColor: AppColors.danger),
        );
      }
    }
  }

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
            ),
            const Text('Pilih Sumber Gambar', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF191C1E))),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildSourceOption(icon: Icons.camera_alt_rounded, label: 'Kamera', color: AppColors.primary, onTap: () { Navigator.pop(ctx); _pickImage(ImageSource.camera); })),
                const SizedBox(width: 16),
                Expanded(child: _buildSourceOption(icon: Icons.photo_library_rounded, label: 'Galeri', color: AppColors.secondary, onTap: () { Navigator.pop(ctx); _pickImage(ImageSource.gallery); })),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.15)),
          ),
          child: Column(
            children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(label, style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 14, fontWeight: FontWeight.w700, color: color)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitPaymentProof() async {
    if (_paymentProof == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan upload bukti pembayaran terlebih dahulu'), backgroundColor: AppColors.warning),
      );
      return;
    }

    setState(() => _uploading = true);
    final ok = await _svc.completePayment(
      widget.emergencyId,
      paymentProof: _paymentProof,
      paymentType: _paymentType,
    );
    setState(() => _uploading = false);

    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bukti pembayaran berhasil dikirim!'), backgroundColor: AppColors.success),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MechanicEmergencyScreen(showCompletionPopup: true)),
        (route) => false,
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengirim bukti pembayaran'), backgroundColor: AppColors.danger),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTransfer = _paymentType == 'transfer';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF181C20)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Pembayaran', style: TextStyle(color: Color(0xFF181C20), fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Plus Jakarta Sans')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Total Amount Card ──
            _buildTotalCard(),
            const SizedBox(height: 24),

            // ── Payment Method Selector ──
            _buildPaymentMethodSelector(),
            const SizedBox(height: 24),

            // ── QR Code (only for transfer) ──
            if (isTransfer) ...[
              _buildQrSection(),
              const SizedBox(height: 24),
            ],

            // ── Cash Info (only for cash) ──
            if (!isTransfer) ...[
              _buildCashInfoSection(),
              const SizedBox(height: 24),
            ],

            // ── Upload Proof ──
            _buildUploadSection(),
            const SizedBox(height: 24),

            // ── Submit Button ──
            _buildSubmitButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // WIDGETS
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildTotalCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.85)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.receipt_long_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Text('TOTAL PEMBAYARAN', style: TextStyle(fontFamily: 'Manrope', fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white.withValues(alpha: 0.85), letterSpacing: 2.0)),
            ],
          ),
          const SizedBox(height: 16),
          Text(_formatCurrency(widget.totalAmount), style: const TextStyle(fontFamily: 'Manrope', fontSize: 34, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -1.5)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
            child: const Text('Menunggu Pembayaran', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 4))],
        border: Border.all(color: const Color(0xFFE6E8EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.payment_rounded, color: AppColors.primary, size: 22),
              SizedBox(width: 8),
              Text('Metode Pembayaran', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
            ],
          ),
          const SizedBox(height: 6),
          Text('Pilih metode pembayaran yang digunakan customer', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade500, height: 1.4)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildMethodCard(
                icon: Icons.qr_code_2_rounded,
                label: 'QRIS',
                subtitle: 'Scan QR',
                value: 'transfer',
                isSelected: _paymentType == 'transfer',
              )),
              const SizedBox(width: 12),
              Expanded(child: _buildMethodCard(
                icon: Icons.payments_rounded,
                label: 'Cash',
                subtitle: 'Tunai',
                value: 'cash',
                isSelected: _paymentType == 'cash',
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMethodCard({
    required IconData icon,
    required String label,
    required String subtitle,
    required String value,
    required bool isSelected,
  }) {
    final color = isSelected ? AppColors.primary : Colors.grey.shade400;
    return GestureDetector(
      onTap: () => setState(() {
        _paymentType = value;
        _paymentProof = null; // reset proof when switching
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade200, width: isSelected ? 2 : 1),
        ),
        child: Column(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 10),
            Text(label, style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 15, fontWeight: FontWeight.w800, color: isSelected ? AppColors.primary : Colors.grey.shade600)),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 11, fontWeight: FontWeight.w500, color: isSelected ? AppColors.primary.withValues(alpha: 0.7) : Colors.grey.shade400)),
            if (isSelected) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
                child: const Text('Dipilih', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQrSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 24, offset: const Offset(0, 6))],
        border: Border.all(color: const Color(0xFFE6E8EA)),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.qr_code_2_rounded, color: AppColors.primary, size: 22),
              SizedBox(width: 8),
              Text('Scan QRIS untuk Bayar', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF191C1E))),
            ],
          ),
          const SizedBox(height: 6),
          Text('Scan kode QR di bawah menggunakan aplikasi e-wallet atau mobile banking', textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade500, height: 1.4)),
          const SizedBox(height: 20),
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) => Transform.scale(scale: _pulseAnimation.value, child: child),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.15), width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/qris_payment.jpeg',
                  width: 280, fit: BoxFit.contain,
                  errorBuilder: (ctx, err, st) => Container(
                    width: 280, height: 280, color: Colors.grey.shade100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.qr_code_2, size: 80, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        Text('QR Code tidak tersedia', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 12, color: Colors.grey.shade500)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_rounded, color: AppColors.primary, size: 16),
                SizedBox(width: 6),
                Text('Didukung semua aplikasi QRIS', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashInfoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 24, offset: const Offset(0, 6))],
        border: Border.all(color: const Color(0xFFE6E8EA)),
      ),
      child: Column(
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.payments_rounded, color: AppColors.success, size: 32),
          ),
          const SizedBox(height: 16),
          const Text('Pembayaran Tunai', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF191C1E))),
          const SizedBox(height: 8),
          Text(
            'Terima uang tunai dari customer sebesar:',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey.shade500, height: 1.4),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
            ),
            child: Text(
              _formatCurrency(widget.totalAmount),
              style: const TextStyle(fontFamily: 'Manrope', fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.success, letterSpacing: -1),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info_outline_rounded, color: AppColors.warning, size: 16),
                SizedBox(width: 6),
                Text('Ambil foto uang tunai sebagai bukti', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.warning)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
    final proofLabel = _paymentType == 'transfer' ? 'Upload Bukti Transfer' : 'Upload Bukti Pembayaran Cash';
    final proofDesc = _paymentType == 'transfer'
        ? 'Ambil screenshot atau foto bukti transfer QRIS'
        : 'Ambil foto uang tunai yang diterima dari customer';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 4))],
        border: Border.all(color: const Color(0xFFE6E8EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.cloud_upload_rounded, color: AppColors.primary, size: 22),
              const SizedBox(width: 8),
              Expanded(child: Text(proofLabel, style: const TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF191C1E)))),
            ],
          ),
          const SizedBox(height: 6),
          Text(proofDesc, style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade500, height: 1.4)),
          const SizedBox(height: 16),
          if (_paymentProof != null) ...[
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(_paymentProof!, width: double.infinity, height: 200, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 10, right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(20)),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text('Foto dipilih', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10, left: 10,
                  child: GestureDetector(
                    onTap: () => setState(() => _paymentProof = null),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.5), shape: BoxShape.circle),
                      child: const Icon(Icons.close, color: Colors.white, size: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _showImageSourcePicker,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Ganti Foto', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ] else ...[
            GestureDetector(
              onTap: _showImageSourcePicker,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1.5),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 64, height: 64,
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.add_a_photo_rounded, color: AppColors.primary, size: 30),
                    ),
                    const SizedBox(height: 14),
                    const Text('Tap untuk mengambil foto', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    const SizedBox(height: 4),
                    Text('Kamera atau Galeri', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade500)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _paymentProof != null
              ? [AppColors.success, const Color(0xFF059669)]
              : [Colors.grey.shade400, Colors.grey.shade500],
        ),
        borderRadius: BorderRadius.circular(9999),
        boxShadow: _paymentProof != null
            ? [BoxShadow(color: AppColors.success.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(9999),
          onTap: _uploading ? null : _submitPaymentProof,
          child: Center(
            child: _uploading
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.send_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 10),
                      Text('Kirim Bukti Pembayaran', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
