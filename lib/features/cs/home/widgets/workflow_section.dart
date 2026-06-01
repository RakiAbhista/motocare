import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motocare/features/cs/home/widgets/workflow_card.dart';

class WorkflowSection extends StatelessWidget {
  const WorkflowSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Active Workflows",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            //Text("View Analytics", style: TextStyle(color: Colors.blue)),
          ],
        ),
        const SizedBox(height: 10),

        /// Grid
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: WorkflowCard(
                title: "Complex Repairs",
                count: "04",
                urgent: true,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                children: [
                  WorkflowCard(
                    title: "Standard Checkup",
                    count: "08",
                  ),

                  const SizedBox(height: 10),

                  WorkflowCard(
                    title: "Parts Order",
                    count: "02",
                  ),
                ],
              ),
            ),
          ],
        ),      ],
    );
  }
}
