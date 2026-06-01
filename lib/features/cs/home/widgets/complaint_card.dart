import 'package:flutter/material.dart';

class ComplaintCard extends StatelessWidget {

  final IconData icon;
  final String title;
  final Color iconColor;
  final String info;

  const ComplaintCard({
    super.key,
    required this.icon,
    required this.title,
    required this.iconColor,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(

      borderRadius: BorderRadius.circular(18),

      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          children: [

            /// ICON BOX
            Container(
              padding: const EdgeInsets.all(12),

              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),

              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            /// TITLE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// TITLE
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// INFO
                  Text(
                    info,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}