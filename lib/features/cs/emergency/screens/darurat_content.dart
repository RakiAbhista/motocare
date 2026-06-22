import 'package:flutter/material.dart';
import 'package:motocare/features/cs/emergency/models/emergency_model.dart';
import 'package:motocare/features/cs/emergency/service/emergency_service.dart';

import '../../emergency/widgets/emergency_card.dart';
import '../../emergency/widgets/emergency_empty_state.dart';
import '../../shared/widgets/header_section.dart';

class DaruratContent extends StatefulWidget {
  const DaruratContent({super.key});

  @override
  State<DaruratContent> createState() => _DaruratContentState();
}

class _DaruratContentState extends State<DaruratContent> {
  final EmergencyService _emergencyService = EmergencyService();

  List<EmergencyModel> _newEmergencies = [];
  List<EmergencyModel> _ongoingEmergencies = [];
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
      final List<EmergencyModel> allRaw = result['data'] as List<EmergencyModel>;
      final List<EmergencyModel> all = allRaw.where((e) {
        final statusLower = e.status.toLowerCase();
        return statusLower == 'pending' || statusLower == 'dispatched';
      }).toList();

      setState(() {
        // New: mechanic is not assigned
        _newEmergencies = all.where((e) => e.mechanic == null || e.mechanic?.id == null).toList();
        
        // Ongoing: mechanic is assigned
        _ongoingEmergencies = all.where((e) => e.mechanic != null && e.mechanic?.id != null).toList();
        
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
        RefreshIndicator(
          onRefresh: _loadEmergencies,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderSection(title: "Emergency Dashboard"),
                const SizedBox(height: 20),

                /// CONTENT AREA
                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(80),
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
                else ...[
                  // SECTION 1: BARU DATANG / BELUM DIASSIGN
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Panggilan Darurat Baru",
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_newEmergencies.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: EmergencyEmptyState(
                        title: "Tidak ada panggilan darurat baru saat ini",
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _newEmergencies.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return EmergencyCard(
                          emergency: _newEmergencies[index],
                        );
                      },
                    ),

                  const SizedBox(height: 32),

                  // SECTION 2: SEDANG BERJALAN / AKTIF
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Panggilan Sedang Berjalan",
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_ongoingEmergencies.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: EmergencyEmptyState(
                        title: "Tidak ada panggilan darurat sedang berjalan",
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _ongoingEmergencies.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return EmergencyCard(
                          emergency: _ongoingEmergencies[index],
                        );
                      },
                    ),
                ],

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
