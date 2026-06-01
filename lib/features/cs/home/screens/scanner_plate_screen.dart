import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motocare/features/cs/home/screens/service_registration_screen.dart';

import '../../services/plate_ocr_service.dart';

class ScannerPlateScreen extends StatefulWidget {
  const ScannerPlateScreen({super.key});

  @override
  State<ScannerPlateScreen> createState() => _ScannerPlateScreenState();
}

class _ScannerPlateScreenState extends State<ScannerPlateScreen> {
  File? selectedImage;

  CameraController? controller;

  List<CameraDescription>? cameras;

  String detectedPlate = "";

  bool isCameraReady = false;

  bool isScanning = false;

  @override
  void initState() {
    super.initState();

    initializeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          /// =========================
          /// HEADER
          /// =========================
          Container(
            width: double.infinity,

            padding: const EdgeInsets.only(
              top: 55,
              left: 20,
              right: 20,
              bottom: 20,
            ),

            decoration: const BoxDecoration(color: Color(0xFFF3F8FF)),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                /// TOP ROW
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },

                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.blue,
                      ),
                    ),

                    const Expanded(
                      child: Text(
                        "Offline Registration",
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 40),
                  ],
                ),

                const SizedBox(height: 20),

                /// STEP TEXT
                const Text(
                  "STEP 1 OF 2",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                /// PROGRESS BAR
                Stack(
                  children: [
                    Container(
                      height: 6,

                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    Container(
                      height: 6,
                      width: MediaQuery.of(context).size.width * 0.45,

                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// TITLE
                const Text(
                  "Identify Vehicle",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                /// DESCRIPTION
                Text(
                  "Point camera at license plate to retrieve digital history.",
                  style: TextStyle(color: Colors.grey[700], fontSize: 15),
                ),
              ],
            ),
          ),

          /// =========================
          /// SCANNER AREA
          /// =========================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [
                  /// CAMERA PREVIEW
                  Expanded(
                    child: Container(
                      width: double.infinity,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),

                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,

                          colors: [Colors.black, Color(0xFF111111)],
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),

                      child: Stack(
                        alignment: Alignment.center,

                        children: [
                          /// CAMERA PREVIEW
                          if (isCameraReady && selectedImage == null)
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: SizedBox(
                                    width: 100,
                                    height: 100 * controller!.value.aspectRatio,
                                    child: CameraPreview(controller!),
                                  ),
                                ),
                              ),
                            ),

                          /// IMAGE RESULT
                          if (selectedImage != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),

                              child: Image.file(
                                selectedImage!,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),

                          /// SCAN FRAME
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(30),

                              child: CustomPaint(
                                painter: ScannerFramePainter(),
                              ),
                            ),
                          ),

                          /// TEXT
                          const Positioned(
                            bottom: 30,

                            child: Text(
                              "Point camera at license plate",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// BOTTOM ACTIONS
                  /// BOTTOM ACTIONS
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 20,
                    ),

                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F8),
                      borderRadius: BorderRadius.circular(30),
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        /// MANUAL
                        Column(
                          children: [
                            IconButton(
                              onPressed: showManualPlateDialog,
                              icon: const Icon(Icons.keyboard_alt_outlined),
                            ),

                            const Text(
                              "MANUAL",
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),

                        /// SCAN BUTTON
                        GestureDetector(
                          onTap: handleScan,

                          child: Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,

                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue,

                                  border: Border.all(
                                    color: Colors.blue.shade100,
                                    width: 8,
                                  ),
                                ),

                                child: Icon(
                                  isScanning
                                      ? Icons.hourglass_top
                                      : Icons.camera_alt,
                                  color: Colors.white,
                                  size: 34,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                isScanning ? "SCANNING..." : "SCAN",
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// GALLERY
                        Column(
                          children: [
                            IconButton(
                              onPressed: pickFromGallery,
                              icon: const Icon(Icons.photo_library_outlined),
                            ),

                            const Text(
                              "GALERI",
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// CONTINUE BUTTON
                  /// CONTINUE BUTTON
                  if (detectedPlate.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),

                      child: SizedBox(
                        width: double.infinity,
                        height: 58,

                        child: ElevatedButton(
                          onPressed: () {

                            Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (context) =>
                                    ServiceRegistrationScreen(

                                      plateNumber: detectedPlate,

                                      isVehicleRegistered: false,
                                    ),
                              ),
                            );
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,

                            elevation: 0,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [

                              const Text(
                                "Continue",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),

                              const SizedBox(width: 10),

                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();

    controller = CameraController(cameras![0], ResolutionPreset.high);

    await controller!.initialize();

    setState(() {
      isCameraReady = true;
    });
  }

  Future<void> showManualPlateDialog() async {
    final controller1 = TextEditingController();
    final controller2 = TextEditingController();
    final controller3 = TextEditingController();

    await showDialog(
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

                // e.g. "B 1234 XYZ" or "B 1234" (if no suffix)
                final plate = part3.isEmpty ? "$part1 $part2" : "$part1 $part2 $part3";

                final regex = RegExp(r'^[A-Z]{1,2}\s\d{1,4}(\s[A-Z]{1,3})?$');

                if (!regex.hasMatch(plate)) {
                  Fluttertoast.showToast(msg: "Invalid plate format");
                  return;
                }

                setState(() {
                  detectedPlate = plate;
                });

                Navigator.pop(context);

                Fluttertoast.showToast(msg: "Plate: $plate");
              },

              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> pickFromGallery() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final imageFile = File(pickedFile.path);

    setState(() {
      selectedImage = imageFile;
    });

    final result = await PlateOCRService.scanPlateFromFile(imageFile);

    if (result != null && result.trim().isNotEmpty) {
      setState(() {
        detectedPlate = result;
      });

      Fluttertoast.showToast(msg: "Plate Detected: $result");
    }
  }

  Future<void> handleScan() async {
    if (isScanning) return;

    setState(() {
      isScanning = true;
    });

    try {
      final result = await PlateOCRService.scanPlate();

      if (result == null) {
        setState(() {
          isScanning = false;
        });

        return;
      }

      final text = result["text"];
      final image = result["image"];

      setState(() {
        selectedImage = image;
      });

      print(text);

      if (text.trim().isNotEmpty) {
        setState(() {
          detectedPlate = text;
        });

        Fluttertoast.showToast(msg: "Plate Detected: $text");

        print("OCR SUCCESS");
      } else {
        print("OCR FAILED");
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      isScanning = false;
    });
  }
}

/// =========================
/// CUSTOM SCANNER FRAME
/// =========================
class ScannerFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    const cornerLength = 40.0;

    /// TOP LEFT
    canvas.drawLine(const Offset(0, cornerLength), const Offset(0, 0), paint);

    canvas.drawLine(const Offset(0, 0), const Offset(cornerLength, 0), paint);

    /// TOP RIGHT
    canvas.drawLine(
      Offset(size.width - cornerLength, 0),
      Offset(size.width, 0),
      paint,
    );

    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, cornerLength),
      paint,
    );

    /// BOTTOM LEFT
    canvas.drawLine(
      Offset(0, size.height - cornerLength),
      Offset(0, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(0, size.height),
      Offset(cornerLength, size.height),
      paint,
    );

    /// BOTTOM RIGHT
    canvas.drawLine(
      Offset(size.width - cornerLength, size.height),
      Offset(size.width, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(size.width, size.height - cornerLength),
      Offset(size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
