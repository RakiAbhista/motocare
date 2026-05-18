import 'package:flutter/material.dart';
import '../widgets/queue_item.dart';
import 'package:motocare/core/theme/app_colors.dart';

class ViewAllQueueScreen extends StatelessWidget {
  const ViewAllQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context), // Fungsi untuk kembali
        ),
        title: const Text(
          'Daftar Semua Antrian',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'Mulish',
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          // Item 1
          QueueItem(
            name: 'Ahmad Subagyo',
            vehicle: 'Honda Beat (2022)',
            plate: 'B 1234 XYZ',
            status: 'WAITING',
            statusBg: AppColors.primaryLight,
            statusText: Color(0xFF1E293B),
            buttonType: 'gradient',
            buttonLabel: 'Mulai',
            fontFamily: 'Mulish',
          ),
          // Item 2
          QueueItem(
            name: 'Siti Aminah',
            vehicle: 'Vespa Sprint S',
            plate: 'AD 5678 JK',
            status: 'IN PROGRESS',
            statusBg: AppColors.primaryLight,
            statusText: Color(0xFF1E293B),
            buttonType: 'grey',
            buttonLabel: 'Detail',
            fontFamily: 'Mulish',
          ),
          // Item 3
          QueueItem(
            name: 'Budi Santoso',
            vehicle: 'Yamaha NMAX',
            plate: 'H 9999 AA',
            status: 'QUEUED',
            statusBg: AppColors.primaryLight,
            statusText: Color(0xFF1E293B),
            buttonType: 'more',
            buttonLabel: '...',
            fontFamily: 'Plus Jakarta Sans',
          ),
          // Item 4
          QueueItem(
            name: 'Cakra Khan',
            vehicle: 'Kawasaki Ninja 250',
            plate: 'B 1 BOS',
            status: 'QUEUED',
            statusBg: AppColors.primaryLight,
            statusText: Color(0xFF1E293B),
            buttonType: 'more',
            buttonLabel: '...',
            fontFamily: 'Plus Jakarta Sans',
          ),
          // Item 5
          QueueItem(
            name: 'Dewi Lestari',
            vehicle: 'Honda Vario 150',
            plate: 'AB 1234 CD',
            status: 'QUEUED',
            statusBg: AppColors.primaryLight,
            statusText: Color(0xFF1E293B),
            buttonType: 'more',
            buttonLabel: '...',
            fontFamily: 'Plus Jakarta Sans',
          ),
        ],
      ),
    );
  }
}
