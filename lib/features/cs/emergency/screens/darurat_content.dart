import 'package:flutter/material.dart';
import 'package:motocare/features/cs/emergency/models/emergency_model.dart';
import 'package:motocare/features/cs/emergency/service/emergency_service.dart';

import '../../emergency/widgets/emergency_card.dart';
import '../../shared/widgets/header_section.dart';

class DaruratContent extends StatefulWidget {
  const DaruratContent({super.key});

  @override
  State<DaruratContent> createState() => _DaruratContentState();
}

class _DaruratContentState extends State<DaruratContent> {
  final EmergencyService _emergencyService = EmergencyService();

  List<EmergencyModel> _pendingEmergencies = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadEmergencies();
  }

  Future<void> _loadEmergencies() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _emergencyService.getEmergencies();

    if (!mounted) return;

    if (result['success'] == true) {
      final List<EmergencyModel> all = result['data'] as List<EmergencyModel>;
      setState(() {
        _pendingEmergencies = all.where((e) => e.isPending).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = result['message'] ?? 'Terjadi kesalahan';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderSection(title: "Emergency Dashboard"),
              const SizedBox(height: 20),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Laporan darurat terbaru",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// CONTENT AREA
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                      TextButton(
                        onPressed: _loadEmergencies,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              else if (_pendingEmergencies.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Text(
                      "Tidak ada panggilan darurat saat ini",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _pendingEmergencies.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return EmergencyCard(
                      emergency: _pendingEmergencies[index],
                    );
                  },
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
