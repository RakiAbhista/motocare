import 'package:flutter/material.dart';

class ProfileMenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final String info;
  final VoidCallback onTap;

  const ProfileMenuCard({
    super.key,
    required this.icon,
    required this.title,
    required this.iconColor,
    required this.info,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                // Text Area
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        info,
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFF1E293B).withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                // Right Chevron
                Icon(
                  Icons.chevron_right_rounded,
                  color: const Color(0xFF1E293B).withOpacity(0.4),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
