import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/core/theme/app_theme.dart';
import 'package:motocare/core/theme/app_background.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:motocare/widgets/main_wrapper.dart';
import 'package:motocare/widgets/custom_text_field.dart';
import 'package:motocare/widgets/custom_card.dart';
import 'package:motocare/core/services/emergency_service.dart';
import 'package:motocare/features/customer/booking/models/booking_models.dart';
import 'package:motocare/features/customer/booking/widgets/pilih_kendaraan_bottom_sheet.dart';

class PanggilanDaruratScreen extends StatefulWidget {
  const PanggilanDaruratScreen({super.key});

  @override
  State<PanggilanDaruratScreen> createState() => _PanggilanDaruratScreenState();
}

class _PanggilanDaruratScreenState extends State<PanggilanDaruratScreen> {
  bool isUploaded = false;
  File? _damagePhoto;
  final TextEditingController _keluhanController = TextEditingController();
  final TextEditingController _merkController = TextEditingController();
  final TextEditingController _tipeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _platController = TextEditingController();
  final _service = EmergencyService();
  String? _submittingType;
  Vehicle? _selectedVehicle;
  Map<String, dynamic>? _nearestWorkshop;
  bool _loadingNearest = true;
  Position? _currentPosition;
  String? _currentAddress;
  late MapController mapController;
  Timer? _debounce;
  bool _isMapInteracting = false;

  void _onRegionChanged() {
    final region = mapController.listenerRegionIsChanging.value;
    if (region != null) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 1000), () {
        if (region.center != null) {
          _updateLocationData(region.center!.latitude, region.center!.longitude);
        }
      });
    }
  }

  Future<void> _updateLocationData(double lat, double lon) async {
    setState(() { _loadingNearest = true; });
    try {
      final nearest = await _service.getNearestWorkshop(latitude: lat, longitude: lon);
      
      String? address;
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon).timeout(const Duration(seconds: 6));
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          List<String> parts = [];
          if (place.street != null && place.street!.isNotEmpty) parts.add(place.street!);
          if (place.subLocality != null && place.subLocality!.isNotEmpty) parts.add(place.subLocality!);
          if (place.locality != null && place.locality!.isNotEmpty) parts.add(place.locality!);
          
          if (parts.isNotEmpty) {
            address = parts.join(', ');
          }
        }
      } catch (e) {
        print('Native Geocoding error, falling back to Nominatim: $e');
        try {
          final url = Uri.parse('https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon');
          final response = await http.get(url, headers: {'User-Agent': 'MotoCareApp'}).timeout(const Duration(seconds: 10));
          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            if (data != null && data['address'] != null) {
              final addr = data['address'];
              List<String> parts = [];
              if (addr['road'] != null) parts.add(addr['road']);
              if (addr['suburb'] != null || addr['village'] != null) parts.add(addr['suburb'] ?? addr['village']);
              if (addr['city'] != null || addr['town'] != null || addr['county'] != null) parts.add(addr['city'] ?? addr['town'] ?? addr['county']);
              if (parts.isNotEmpty) {
                address = parts.join(', ');
              } else if (data['display_name'] != null) {
                address = data['display_name'];
              }
            }
          }
        } catch (fallbackError) {
          print('Nominatim fallback error: $fallbackError');
        }
      }

      if (mounted) setState(() {
        _currentPosition = Position(
          latitude: lat,
          longitude: lon,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
        _currentAddress = address;
        _nearestWorkshop = nearest;
        _loadingNearest = false;
      });
    } catch (e) {
      if (mounted) setState(() { _loadingNearest = false; });
      print('Update location error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panggilan Darurat'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BengkelBackground(
        child: SingleChildScrollView(
          physics: _isMapInteracting ? const NeverScrollableScrollPhysics() : const ScrollPhysics(),
          padding: AppTheme.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.danger.withValues(alpha: 0.08),
                      AppColors.danger.withValues(alpha: 0.02),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  border: Border.all(color: AppColors.danger.withValues(alpha: 0.15)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.danger.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      ),
                      child: const Icon(Icons.warning_amber_rounded, color: AppColors.danger, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Isi data dengan benar agar kami dapat membantu Anda',
                        style: TextStyle(color: AppColors.danger, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildLocationSection(),
              const SizedBox(height: 24),
              _buildNearbyWorkshop(),
              const SizedBox(height: 28),
              const Row(
                children: [
                  Icon(Icons.motorcycle, color: AppColors.danger, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Detail Kendaraan',
                    style: TextStyle(
                      color: AppColors.danger,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Vehicle selector: choose existing vehicle or fill manually
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final vehicle = await PilihKendaraanBottomSheet.show(context);
                        if (vehicle != null && mounted) {
                          setState(() => _selectedVehicle = vehicle);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.motorcycle, color: AppColors.primary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _selectedVehicle != null
                                    ? '${_selectedVehicle!.brand} ${_selectedVehicle!.model} • ${_selectedVehicle!.plateNumber}'
                                    : 'Pilih kendaraan yang terdaftar',
                                style: AppTheme.bodyMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_drop_up),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_selectedVehicle != null)
                    IconButton(
                      onPressed: () => setState(() => _selectedVehicle = null),
                      icon: const Icon(Icons.close, color: Colors.red),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // If no vehicle selected, show manual input fields
              if (_selectedVehicle == null) ...[
                CustomTextField(
                  label: 'Merk Kendaraan',
                  hint: 'Masukkan merk kendaraan',
                  controller: _merkController,
                  isRequired: true,
                ),
                CustomTextField(
                  label: 'Tipe Kendaraan',
                  hint: 'Masukkan tipe kendaraan',
                  controller: _tipeController,
                  isRequired: true,
                ),
                CustomTextField(
                  label: 'Tahun / Model',
                  hint: 'Masukkan tahun atau model kendaraan',
                  controller: _modelController,
                  isRequired: true,
                ),
                CustomTextField(
                  label: 'Nomor Plat',
                  hint: 'Masukkan nomor plat',
                  controller: _platController,
                  isRequired: true,
                ),
              ],
              CustomTextField(
                label: 'Keluhan / Complaint',
                hint: 'Jelaskan keluhan atau kerusakan',
                controller: _keluhanController,
                isRequired: true,
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Icon(Icons.camera_alt_outlined, color: AppColors.textBody, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Foto Kerusakan Fisik',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Pastikan gambar terlihat jelas.',
                style: AppTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              _buildPhotoUpload(),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submittingType != null ? null : () => _submitEmergency('mechanic'),
                  icon: _submittingType == 'mechanic' ? const SizedBox(width:18,height:18,child:CircularProgressIndicator(strokeWidth:2, color:Colors.white)) : const Icon(Icons.build_rounded, size: 18),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dangerDark,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                    disabledBackgroundColor: AppColors.dangerDark.withValues(alpha: 0.5),
                  ),
                  label: Text('Panggil Mekanik', style: TextStyle(color: _submittingType != null ? Colors.white70 : Colors.white)),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    const jawgAccessToken = 'wqvsLL2FCdRtoX4DSOBM9T5MEZefn5HlwFMNB4ywlOS3r2M62s6Va1FVPVGVqb64';
    mapController = MapController.customLayer(
      initPosition: GeoPoint(latitude: -7.005145, longitude: 110.438126),
      customTile: CustomTile(
        sourceName: 'jawg-terrain',
        tileExtension: '.png?access-token=$jawgAccessToken',
        tileSize: 256,
        urlsServers: [
          TileURLs(url: 'https://tile.jawg.io/jawg-terrain/', subdomains: []),
        ],
      ),
    );
    mapController.listenerRegionIsChanging.addListener(_onRegionChanged);

    _initNearestWorkshop();
  }

  Future<void> _initNearestWorkshop() async {
    setState(() { _loadingNearest = true; });
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() { _loadingNearest = false; });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() { _loadingNearest = false; });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() { _loadingNearest = false; });
        return;
      }

      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      
      await _updateLocationData(pos.latitude, pos.longitude);
      
      try {
        await mapController.goToLocation(GeoPoint(latitude: pos.latitude, longitude: pos.longitude));
        await mapController.setZoom(zoomLevel: 16);
      } catch (_) {}

    } catch (e) {
      if (mounted) setState(() { _loadingNearest = false; });
      print('Init nearest error: $e');
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    mapController.listenerRegionIsChanging.removeListener(_onRegionChanged);
    mapController.dispose();
    _keluhanController.dispose();
    _merkController.dispose();
    _tipeController.dispose();
    _modelController.dispose();
    _platController.dispose();
    super.dispose();
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomCard(
          accentColor: AppColors.danger,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: const Icon(Icons.location_on, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentAddress != null 
                          ? 'Lokasi: $_currentAddress'
                          : _currentPosition != null
                              ? 'Lokasi: ${_currentPosition!.latitude.toStringAsFixed(6)}, ${_currentPosition!.longitude.toStringAsFixed(6)}'
                              : 'Menunggu lokasi perangkat...',
                      style: AppTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Geser peta di bawah jika lokasi kurang tepat',
                      style: TextStyle(fontSize: 11, color: AppColors.danger, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Listener(
          onPointerDown: (_) => setState(() => _isMapInteracting = true),
          onPointerUp: (_) => setState(() => _isMapInteracting = false),
          onPointerCancel: (_) => setState(() => _isMapInteracting = false),
          child: Container(
            height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(color: AppColors.danger.withValues(alpha: 0.15)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            child: Stack(
              children: [
                OSMFlutter(
                  controller: mapController,
                  osmOption: const OSMOption(
                    zoomOption: ZoomOption(
                      initZoom: 16,
                      minZoomLevel: 3,
                      maxZoomLevel: 19,
                    ),
                    showZoomController: false,
                    enableRotationByGesture: false,
                  ),
                ),
                Positioned(
                  top: 8, right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.touch_app, size: 14, color: AppColors.danger),
                        SizedBox(width: 4),
                        Text('Geser peta untuk mengubah lokasi', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.danger)),
                      ],
                    ),
                  ),
                ),
                const IgnorePointer(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 24.0),
                      child: Icon(Icons.location_pin, color: Colors.red, size: 48),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ),
      ],
    );
  }

  Widget _buildNearbyWorkshop() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.15)),
        color: AppColors.secondary.withValues(alpha: 0.04),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: _loadingNearest
            ? Row(
                children: [
                  const SizedBox(width: 12),
                  const Expanded(child: Center(child: CircularProgressIndicator())),
                ],
              )
            : (_nearestWorkshop != null)
                ? Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                        ),
                        child: const Icon(Icons.build_rounded, color: AppColors.primary, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_nearestWorkshop!['name'] ?? '-', style: AppTheme.titleMedium),
                            const SizedBox(height: 4),
                            Text('${(_nearestWorkshop!['distance_meters'] ?? 0).toString()} m', style: AppTheme.bodySmall),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('${(_nearestWorkshop!['distance_meters'] ?? 0).toString()} m',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.white,
                            )),
                      ),
                    ],
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text('Tidak ada bengkel yang tersedia saat ini.', style: AppTheme.bodySmall),
                    ),
                  ),
      ),
    );
  }

  Widget _buildPhotoUpload() {
    return Row(
      children: [
        if (_damagePhoto != null)
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  child: Image.file(_damagePhoto!, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: -8,
                right: 4,
                child: GestureDetector(
                  onTap: () => setState(() { _damagePhoto = null; isUploaded = false; }),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.cancel, color: AppColors.danger, size: 22),
                  ),
                ),
              ),
            ],
          ),
        GestureDetector(
          onTap: _showImageSourcePicker,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              border: Border.all(color: AppColors.border, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_upload_outlined, color: Colors.grey.shade400, size: 32),
                const SizedBox(height: 4),
                const Text('Tambah', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
            ),
            const Text('Pilih Sumber Gambar', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF191C1E))),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildSourceOption(icon: Icons.camera_alt_rounded, label: 'Kamera', color: AppColors.primary, onTap: () { Navigator.pop(ctx); _pickImage(ImageSource.camera); })),
                const SizedBox(width: 16),
                Expanded(child: _buildSourceOption(icon: Icons.photo_library_rounded, label: 'Galeri', color: AppColors.secondary, onTap: () { Navigator.pop(ctx); _pickImage(ImageSource.gallery); })),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.15)),
          ),
          child: Column(
            children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(label, style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 14, fontWeight: FontWeight.w700, color: color)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final picked = await picker.pickImage(source: source, maxWidth: 2048, maxHeight: 2048, imageQuality: 80);
      if (picked != null) {
        setState(() {
          _damagePhoto = File(picked.path);
          isUploaded = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil gambar: $e'), backgroundColor: AppColors.danger),
        );
      }
    }
  }

  Future<void> _submitEmergency(String type) async {
    // Validasi input kendaraan manual
    if (_selectedVehicle == null) {
      if (_merkController.text.trim().isEmpty ||
          _tipeController.text.trim().isEmpty ||
          _modelController.text.trim().isEmpty ||
          _platController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Semua detail kendaraan wajib diisi jika tidak memilih dari daftar.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    // Validasi input keluhan
    if (_keluhanController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Keluhan / kerusakan wajib diisi.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _submittingType = type);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location services are disabled')));
        setState(() => _submittingType = null);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permission denied')));
          setState(() => _submittingType = null);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permission permanently denied')));
        setState(() => _submittingType = null);
        return;
      }

      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      final resp = await _service.createEmergency(
        latitude: pos.latitude,
        longitude: pos.longitude,
        vehicleId: _selectedVehicle?.id,
        vehicleBrand: _selectedVehicle == null ? (_merkController.text.trim().isEmpty ? null : _merkController.text.trim()) : null,
        vehicleType: _selectedVehicle == null ? (_tipeController.text.trim().isEmpty ? null : _tipeController.text.trim()) : null,
        vehicleModel: _selectedVehicle == null ? (_modelController.text.trim().isEmpty ? null : _modelController.text.trim()) : null,
        plateNumber: _selectedVehicle == null ? (_platController.text.trim().isEmpty ? null : _platController.text.trim()) : null,
        complaint: _keluhanController.text.trim().isEmpty ? null : _keluhanController.text.trim(),
        damagePhoto: _damagePhoto,
        emergencyType: type,
      );

      if (resp['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resp['message'] ?? 'Permintaan emergency berhasil')));
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainWrapper(daruratType: type == 'towing' ? 'towing' : 'mekanik')),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resp['message'] ?? 'Gagal membuat permintaan')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    } finally {
      if (mounted) setState(() => _submittingType = null);
    }
  }
}
