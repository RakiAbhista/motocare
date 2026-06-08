import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<String?> showManualPlateDialog(BuildContext context) async {
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  final controller3 = TextEditingController();

  return await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text("Input License Plate"),
        content: Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: controller1,
                textCapitalization: TextCapitalization.characters,
                textAlign: TextAlign.center,
                maxLength: 2,
                decoration: const InputDecoration(
                  hintText: "B",
                  counterText: "",
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) {
                  if (val.length >= 2) FocusScope.of(context).nextFocus();
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: TextField(
                controller: controller2,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 4,
                decoration: const InputDecoration(
                  hintText: "1234",
                  counterText: "",
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) {
                  if (val.length >= 4) FocusScope.of(context).nextFocus();
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: TextField(
                controller: controller3,
                textCapitalization: TextCapitalization.characters,
                textAlign: TextAlign.center,
                maxLength: 3,
                decoration: const InputDecoration(
                  hintText: "XYZ",
                  counterText: "",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final part1 = controller1.text.trim().toUpperCase();
              final part2 = controller2.text.trim();
              final part3 = controller3.text.trim().toUpperCase();

              if (part1.isEmpty || part2.isEmpty) {
                Fluttertoast.showToast(msg: "City code and number are required");
                return;
              }

              final plate = part3.isEmpty ? "$part1 $part2" : "$part1 $part2 $part3";
              final regex = RegExp(r'^[A-Z]{1,2}\s\d{1,4}(\s[A-Z]{1,3})?$');

              if (!regex.hasMatch(plate)) {
                Fluttertoast.showToast(msg: "Invalid plate format");
                return;
              }

              Navigator.pop(context, plate);
            },
            child: const Text("Save"),
          ),
        ],
      );
    },
  );
}
