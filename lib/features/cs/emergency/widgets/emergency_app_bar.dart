import 'package:flutter/material.dart';

class EmergencyAppBar extends StatelessWidget {
  const EmergencyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
        ),
        const Expanded(
          child: Text(
            "Emergency Assignment",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none, color: Colors.blue),
        ),
      ],
    );
  }
}
