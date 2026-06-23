import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/core/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:motocare/core/services/customer_home_service.dart';

class DetailEmergencyScreen extends StatefulWidget {
  final String emergencyType; // 'mekanik' or 'towing'
  final int emergencyId;
  const DetailEmergencyScreen({super.key, required this.emergencyType, required this.emergencyId});

  @override
  State<DetailEmergencyScreen> createState() => _DetailEmergencyScreenState();
}

class _DetailEmergencyScreenState extends State<DetailEmergencyScreen> {
  late MapController mapController;
  Timer? _timer;
  
  // Dynamic data from API
  double? customerLat;
  double? customerLon;
  double? mechanicLat;
  double? mechanicLon;

  String mechanicName = 'Menunggu...';
  String mechanicPhone = '-';
  String status = 'pending'; // pending, process, payment

  bool _isLoading = true;

  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    const jawgAccessToken = 'wqvsLL2FCdRtoX4DSOBM9T5MEZefn5HlwFMNB4ywlOS3r2M62s6Va1FVPVGVqb64';
    mapController = MapController.customLayer(
      initMapWithUserPosition: const UserTrackingOption(
        enableTracking: true,
        unFollowUser: false,
      ),
      customTile: CustomTile(
        sourceName: 'jawg-terrain',
        tileExtension: '.png?access-token=$jawgAccessToken',
        tileSize: 256,
        urlsServers: [
          TileURLs(url: 'https://tile.jawg.io/jawg-terrain/', subdomains: []),
        ],
      ),
    );
    _initLocation();
    _fetchEmergencyDetail(isInitial: true);
    
    _timer = Timer.periodic(const Duration(seconds: 11), (timer) {
      _fetchEmergencyDetail(isInitial: false);
    });
  }

  Future<void> _fetchEmergencyDetail({bool isInitial = false}) async {
    if (isInitial) {
      setState(() => _isLoading = true);
    }
    
    final result = await CustomerHomeService().getEmergencyDetail(widget.emergencyId);
    if (result['success'] == true && result['data'] != null) {
      final data = result['data'];
      if (mounted) {
        setState(() {
          status = data['emergency_status'] ?? 'pending';
          mechanicName = data['mechanic_name'] ?? 'Mekanik Belum Ditemukan';
          mechanicPhone = data['mechanic_phone'] ?? '-';
          
          if (data['mechanic_location'] != null) {
            mechanicLat = double.tryParse(data['mechanic_location']['latitude'].toString());
            mechanicLon = double.tryParse(data['mechanic_location']['longitude'].toString());
          }
          if (data['customer_location'] != null) {
            customerLat = double.tryParse(data['customer_location']['latitude'].toString());
            customerLon = double.tryParse(data['customer_location']['longitude'].toString());
          }
          if (isInitial) {
            _isLoading = false;
          }
        });
        
        // Perbarui marker statis secara dinamis tanpa merefresh seluruh peta
        if (_isMapReady && mechanicLat != null && mechanicLon != null) {
          try {
            await mapController.setStaticPosition(
              [GeoPoint(latitude: mechanicLat!, longitude: mechanicLon!)],
              "mechanic",
            );
          } catch (_) {}
        }
        
        _drawRouteIfReady(zoomInto: isInitial);
      }
    } else {
      if (mounted && isInitial) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Gagal mengambil data')),
        );
      }
    }
  }

  Future<void> _initLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (mounted) {
      setState(() {
        customerLat = pos.latitude;
        customerLon = pos.longitude;
      });
      _drawRouteIfReady(zoomInto: true);
    }
  }

  void _drawRouteIfReady({bool zoomInto = false}) async {
    if (_isMapReady && customerLat != null && customerLon != null && mechanicLat != null && mechanicLon != null) {
      try {
        await mapController.clearAllRoads();
        await mapController.drawRoad(
          GeoPoint(latitude: mechanicLat!, longitude: mechanicLon!),
          GeoPoint(latitude: customerLat!, longitude: customerLon!),
          roadType: RoadType.car,
          roadOption: RoadOption(
            roadWidth: 10,
            roadColor: AppColors.primary,
            zoomInto: zoomInto,
          ),
        );
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : Stack(
              children: [
                // 1. Map
          Positioned.fill(
            child: OSMFlutter(
              controller: mapController,
              osmOption: OSMOption(
                zoomOption: const ZoomOption(initZoom: 15),
                showZoomController: false,
                enableRotationByGesture: false,
                staticPoints: [
                  if (customerLat != null && customerLon != null)
                    StaticPositionGeoPoint(
                      "customer",
                      const MarkerIcon(
                        icon: Icon(Icons.location_on, color: AppColors.danger, size: 48),
                      ),
                      [GeoPoint(latitude: customerLat!, longitude: customerLon!)],
                    ),
                  if (mechanicLat != null && mechanicLon != null)
                    StaticPositionGeoPoint(
                      "mechanic",
                      const MarkerIcon(
                        icon: Icon(Icons.build_circle, color: AppColors.primary, size: 48),
                      ),
                      [GeoPoint(latitude: mechanicLat!, longitude: mechanicLon!)],
                    ),
                ],
              ),
              onMapIsReady: (isReady) async {
                if (isReady) {
                  _isMapReady = true;
                  _drawRouteIfReady();
                }
              },
            ),
          ),

          // 2. Header Full Width
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                bottom: 20,
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.background,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      widget.emergencyType == 'towing' ? 'Detail Towing' : 'Detail Mekanik',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. Detail Bottom Sheet (Fixed for Customer)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32.0)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5)),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text('Informasi Mekanik', style: AppTheme.titleMedium),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                          ),
                          child: const Icon(Icons.person, color: AppColors.primary, size: 30),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(mechanicName, style: AppTheme.titleMedium),
                              const SizedBox(height: 4),
                              const Text('Bengkel MotoCare', style: AppTheme.bodySmall),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            final Uri phoneUri = Uri(scheme: 'tel', path: mechanicPhone);
                            launchUrl(phoneUri);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                            ),
                            child: const Icon(Icons.phone, color: AppColors.success, size: 24),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text('Status Panggilan', style: AppTheme.titleMedium),
                    const SizedBox(height: 16),
                    _buildProgressBar(status),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(String currentStatus) {
    int currentStep = 0;
    if (currentStatus == 'process') currentStep = 1;
    if (currentStatus == 'payment' || currentStatus == 'completed') currentStep = 2;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStep('Ditinjau', currentStep >= 0),
        _buildLine(currentStep >= 1),
        _buildStep('Menuju Lokasi', currentStep >= 1),
        _buildLine(currentStep >= 2),
        _buildStep('Selesai', currentStep >= 2),
      ],
    );
  }

  Widget _buildStep(String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.primary : Colors.grey[200],
          ),
          child: Icon(
            Icons.check,
            color: isActive ? Colors.white : Colors.grey[400],
            size: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? AppColors.textPrimary : Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 3,
        margin: const EdgeInsets.only(bottom: 24), // Center vertically aligned with circle
        color: isActive ? AppColors.primary : Colors.grey[200],
      ),
    );
  }
}
