import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/features/mechanic/profile/services/profile_service.dart';

class MechanicWorkHistoryScreen extends StatefulWidget {
  const MechanicWorkHistoryScreen({super.key});

  @override
  State<MechanicWorkHistoryScreen> createState() => _MechanicWorkHistoryScreenState();
}

class _MechanicWorkHistoryScreenState extends State<MechanicWorkHistoryScreen> {
  final ProfileService _profileService = ProfileService();

  bool _isLoading = true;
  List<Map<String, dynamic>> _historyJobs = [];

  @override
  void initState() {
    super.initState();
    _loadWorkHistory();
  }

  Future<void> _loadWorkHistory() async {
    setState(() => _isLoading = true);
    final result = await _profileService.getWorkHistory();
    if (!mounted) return;
    if (result['success']) {
      final data = result['data'];
      List<dynamic> rawList = [];
      if (data is List) {
        rawList = data;
      } else if (data is Map) {
        rawList = (data['work_history'] ?? []) as List;
      }
      _historyJobs = rawList.map((item) {
        final map = item as Map<String, dynamic>;
        return {
          'date': map['completed_at'] ?? '',
          'vehicle': '${map['vehicle_brand'] ?? ''} ${map['vehicle_model'] ?? ''}'.trim(),
          'customer': map['customer_name'] ?? '',
          'plate': map['plate_number'] ?? '',
          'price': map['total_price']?.toString() ?? '',
          'service': map['service'] ?? '',
          'type': map['type'] ?? 'REGULAR',
        };
      }).toList();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Gagal mengambil riwayat kerja'),
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Riwayat Pekerjaan',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _historyJobs.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history_toggle_off_rounded,
                        size: 64,
                        color: Color(0xFF1E293B).withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada riwayat pekerjaan',
                        style: TextStyle(
                          color: Color(0xFF1E293B).withOpacity(0.5),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  itemCount: _historyJobs.length,
                  itemBuilder: (context, index) {
                    final job = _historyJobs[index];
                    final isEmergency = job['type'] == 'EMERGENCY';
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1E293B).withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: const Color(0xFF1E293B).withOpacity(0.05),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  job['date'] ?? '',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF1E293B).withOpacity(0.5),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isEmergency ? AppColors.danger.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    isEmergency ? 'DARURAT' : 'REGULER',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: isEmergency ? AppColors.danger : AppColors.primary,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.motorcycle_rounded,
                                    color: AppColors.primary,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        job['vehicle'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E293B),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${job['customer'] ?? ''} • ${job['plate'] ?? ''}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF1E293B).withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24, thickness: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Tindakan:',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: const Color(0xFF1E293B).withOpacity(0.4),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        job['service'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1E293B),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Pendapatan:',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: const Color(0xFF1E293B).withOpacity(0.4),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      job['price'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.success,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
