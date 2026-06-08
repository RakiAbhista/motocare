import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:motocare/features/cs/home/screens/service_registration_screen.dart';
import '../../shared/services/plate_ocr_service.dart';
import '../widgets/scanner_frame_painter.dart';
import '../widgets/manual_plate_dialog.dart';
import '../service/vehicle_service.dart' as motovehicle;

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

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras![0], ResolutionPreset.high);
    await controller!.initialize();
    if (mounted) {
      setState(() {
        isCameraReady = true;
      });
    }
  }

  Future<void> _handleManualInput() async {
    final plate = await showManualPlateDialog(context);
    if (plate != null) {
      setState(() {
        detectedPlate = plate;
      });
      Fluttertoast.showToast(msg: "Plate: $plate");
    }
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

      if (text.trim().isNotEmpty) {
        setState(() {
          detectedPlate = text;
        });
        Fluttertoast.showToast(msg: "Plate Detected: $text");
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      isScanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildCameraPreview(),
                  const SizedBox(height: 20),
                  _buildBottomActions(),
                  if (detectedPlate.isNotEmpty) _buildContinueButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 55, left: 20, right: 20, bottom: 20),
      decoration: const BoxDecoration(color: Color(0xFFF3F8FF)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
              ),
              const Expanded(
                child: Text(
                  "Offline Registration",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "STEP 1 OF 2",
            style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
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
          const Text(
            "Identify Vehicle",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            "Point camera at license plate to retrieve digital history.",
            style: TextStyle(color: Colors.grey[700], fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Expanded(
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
            if (isCameraReady && selectedImage == null && controller != null)
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
            if (selectedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.file(
                  selectedImage!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: CustomPaint(
                  painter: ScannerFramePainter(),
                ),
              ),
            ),
            const Positioned(
              bottom: 30,
              child: Text(
                "Point camera at license plate",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F8),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              IconButton(
                onPressed: _handleManualInput,
                icon: const Icon(Icons.keyboard_alt_outlined),
              ),
              const Text("MANUAL", style: TextStyle(fontSize: 10)),
            ],
          ),
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
                    border: Border.all(color: Colors.blue.shade100, width: 8),
                  ),
                  child: Icon(
                    isScanning ? Icons.hourglass_top : Icons.camera_alt,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isScanning ? "SCANNING..." : "SCAN",
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: pickFromGallery,
                icon: const Icon(Icons.photo_library_outlined),
              ),
              const Text("GALERI", style: TextStyle(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton(
          onPressed: () async {
            // Tampilkan loading dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );

            // Import service secara dinamis jika tidak ada di atas, atau pastikan import ada
            // Lebih baik pakai import di atas file, tapi karena kita cuma replace sebagian, kita panggil class jika sudah terimport.
            // Wait, I should add the import at the top of the file! Let's do it in the next step.
            
            // Actually, I can just write the logic here and import it at the top later.
            try {
              final service = motovehicle.VehicleService(); // using alias if I add it
              final result = await service.findByPlate(detectedPlate);
              
              if (context.mounted) Navigator.pop(context); // Tutup loading

              if (result['success']) {
                // Vehicle found!
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServiceRegistrationScreen(
                        plateNumber: detectedPlate,
                        isVehicleRegistered: true,
                        vehicleData: result['data'], // Passing data
                      ),
                    ),
                  );
                }
              } else {
                // Vehicle not found
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServiceRegistrationScreen(
                        plateNumber: detectedPlate,
                        isVehicleRegistered: false,
                      ),
                    ),
                  );
                }
              }
            } catch (e) {
              if (context.mounted) Navigator.pop(context);
              Fluttertoast.showToast(msg: "Error: $e");
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Continue",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.arrow_forward, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
