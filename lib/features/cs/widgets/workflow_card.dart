import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkflowCard extends
StatelessWidget {
  final String title;
  final String count;
  final bool urgent;

  const WorkflowCard({
    super.key,
    required this.title,
    required this.count,
    this.urgent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: urgent ? 150 : 80,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: urgent ? Colors.grey[200] : Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            /// ICON
            if (urgent)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.build,
                color: Colors.blue,
                size: 22,
              ),
            ),

          if (urgent)
            const SizedBox(height: 10),

            /// TITLE
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),

            /// BOTTOM ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  count,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                if (urgent)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "URGENT",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  )
              ],
            )
          ]      ),
    );
  }
}