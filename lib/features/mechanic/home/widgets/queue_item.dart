import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';

class QueueItem extends StatelessWidget {
  final String name,
      vehicle,
      plate,
      status,
      buttonLabel,
      buttonType,
      fontFamily;
  final Color statusBg, statusText;
  final VoidCallback? onTap;

  const QueueItem({
    super.key,
    required this.name,
    required this.vehicle,
    required this.plate,
    required this.status,
    required this.statusBg,
    required this.statusText,
    required this.buttonLabel,
    required this.buttonType,
    required this.fontFamily,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isQueued = status == 'QUEUED' || status.toUpperCase() == 'PENDING';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration:
            BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ).copyWith(
              color: AppColors.primaryLight.withOpacity(isQueued ? 0.8 : 1.0),
            ),
      child: Row(
        children: [
          // Thumbnail Kendaraan (Placeholder Icon)
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.motorcycle,
              color: AppColors.primary,
              size: 36,
            ),
          ),
          const SizedBox(width: 16),
          // Info Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: statusText,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  vehicle,
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: 12,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Plate Number
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFFC3C6D4).withOpacity(0.2),
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        plate,
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    // Dynamic Button
                    _buildActionButton(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildActionButton() {
    if (buttonType == 'gradient') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primary],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          buttonLabel,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else if (buttonType == 'more') {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: AppColors.primaryLight,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.more_horiz, size: 16, color: Color(0xFF1E293B)),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          buttonLabel,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }
}
