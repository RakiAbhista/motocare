import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:motocare/features/cs/home/service/mechanic_emergency_service.dart';
import '../widgets/detail/floating_map_ui.dart';
import '../widgets/detail/detail_bottom_sheet.dart';

class DetailEmergencyScreen extends StatefulWidget {
  final int? emergencyId;
  const DetailEmergencyScreen({super.key, this.emergencyId});

  @override
  State<DetailEmergencyScreen> createState() => _DetailEmergencyScreenState();
}

class _DetailEmergencyScreenState extends State<DetailEmergencyScreen> {
  // 1. Inisialisasi MapController
  late MapController mapController;
  // customer coordinates (updated from backend)
  double customerLatitude = -7.050186;
  double customerLongitude = 110.438925;

  // dynamic detail fields
  String clientName = '';
  String clientPhone = '';
  String vehicleBrand = '';
  String vehicleModel = '';
  String plateNumber = '';
  String? damagePhoto;
  bool highPriority = false;

  // ── State Variables Baru untuk Order & Vehicle Type ──
  int orderId = 0;
  String orderStatus = '';
  String isTowing = 'no';
  String totalPrice = '0';
  String vehicleType = '';

  bool _loadingDetail = false;

  @override
  void initState() {
    super.initState();
    const jawgAccessToken =
        'wqvsLL2FCdRtoX4DSOBM9T5MEZefn5HlwFMNB4ywlOS3r2M62s6Va1FVPVGVqb64';

    mapController = MapController.customLayer(
      initMapWithUserPosition: const UserTrackingOption(
        enableTracking: true,
        unFollowUser: false, // Tetap ikuti pergerakan mekanik
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

    // If an emergencyId was provided, fetch details and center map
    if (widget.emergencyId != null) {
      _loadDetail(widget.emergencyId!);
    }
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7F2FF),
      body: Stack(
        children: [
          // 2. Real Map dari CartoDB Positron (bersih, hanya jalan & nama)
          Positioned.fill(
            child: OSMFlutter(
              controller: mapController,
              osmOption: OSMOption(
                zoomOption: const ZoomOption(initZoom: 15),
                showZoomController: false,
                enableRotationByGesture: false, // Nonaktifkan rotasi peta
                userLocationMarker: UserLocationMaker(
                  personMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.my_location,
                      color: Color(0xFF104BAA),
                      size: 48,
                    ),
                  ),
                  directionArrowMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.navigation,
                      color: Color(0xFF104BAA),
                      size: 48,
                    ),
                  ),
                ),
                staticPoints: [
                  StaticPositionGeoPoint(
                    "customer_location",
                    const MarkerIcon(
                      icon: Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 48,
                      ),
                    ),
                    [
                      GeoPoint(
                        latitude: customerLatitude,
                        longitude: customerLongitude,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 3. Tombol Back / Header Overlay
          Positioned(
            top: 50,
            left: 20,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back, color: Color(0xFF181C20)),
              ),
            ),
          ),

          // 4. Glassmorphism Floating Map UI (Jarak & Waktu)
          const FloatingMapUI(),

          // Tombol Recenter Lokasi Mekanik
          Positioned(
            top: 210, // Sesuaikan jaraknya biar nggak nabrak UI Glassmorphism
            right: 24,
            child: InkWell(
              onTap: () async {
                // Perintah untuk memusatkan kembali peta ke lokasi GPS saat ini
                await mapController.currentLocation();
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.my_location,
                  color: Color(0xFF104BAA),
                  size: 24,
                ),
              ),
            ),
          ),

          // 5. Draggable Bottom Sheet (Bisa di-slide)
          DetailBottomSheet(
            emergencyId: widget.emergencyId ?? 0,
            orderId: orderId,                 // <-- Diperbarui dari state dinamis
            orderStatus: orderStatus,         // <-- Diperbarui dari state dinamis
            isTowing: isTowing,               // <-- Diperbarui dari state dinamis
            totalPrice: totalPrice,           // <-- Diperbarui dari state dinamis
            vehicleType: vehicleType,         // <-- Diperbarui dari state dinamis
            customerLatitude: customerLatitude,
            customerLongitude: customerLongitude,
            clientName: clientName,
            clientPhone: clientPhone,
            vehicleBrand: vehicleBrand,
            vehicleModel: vehicleModel,
            plateNumber: plateNumber,
            damagePhoto: damagePhoto,
            highPriority: highPriority,
          ),

          // 6. Indikator Loading di atas screen jika data sedang diambil (Bebas error const)
          if (_loadingDetail)
            Positioned.fill(
              child: Container(
                color: Colors.black26,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _loadDetail(int id) async {
    setState(() => _loadingDetail = true);
    try {
      final svc = MechanicEmergencyService();
      final detail = await svc.showEmergency(id);
      if (detail != null) {
        // detail may be nested under 'data'
        final data = detail['data'] ?? detail;
        final loc = data['location'] ?? data['location_data'] ?? data;
        final latS = loc['latitude']?.toString() ?? loc['lat']?.toString();
        final lonS = loc['longitude']?.toString() ?? loc['lng']?.toString() ?? loc['lon']?.toString();
        final lat = double.tryParse(latS ?? '');
        final lon = double.tryParse(lonS ?? '');

        // parse client & vehicle
        clientName = (data['client'] != null) ? (data['client']['name'] ?? '') : (data['client_name'] ?? '');
        clientPhone = (data['client'] != null) ? (data['client']['phone'] ?? data['client']['phone_number'] ?? '') : (data['client_phone'] ?? '');
        vehicleBrand = (data['vehicle'] != null) ? (data['vehicle']['brand'] ?? '') : (data['vehicle_brand'] ?? '');
        vehicleModel = (data['vehicle'] != null) ? (data['vehicle']['model'] ?? '') : '';
        plateNumber = (data['vehicle'] != null) ? (data['vehicle']['plate_number'] ?? '') : (data['plate_number'] ?? '');
        
        // Parsing vehicle_type dari JSON terbarumu
        vehicleType = (data['vehicle'] != null) ? (data['vehicle']['vehicle_type'] ?? '') : '';
        
        damagePhoto = data['damage_photo'] ?? (data['vehicle'] != null ? data['vehicle']['damage_photo'] : null);
        // conservative high priority detection
        highPriority = (data['priority'] != null && data['priority'].toString().toLowerCase() == 'high') || (data['status'] != null && data['status'].toString().toLowerCase().contains('priority'));

        // Parsing objek 'order' dari JSON terbarumu
        if (data['order'] != null) {
          orderId = data['order']['order_id'] ?? 0;
          orderStatus = data['order']['status'] ?? '';
          isTowing = data['order']['is_towing'] ?? 'no';
          
          // Mengubah format harga ("0.00" menjadi "0") agar tampilan lebih bersih
          final rawPrice = data['order']['total_price']?.toString() ?? '0';
          double? parsedPrice = double.tryParse(rawPrice);
          totalPrice = parsedPrice != null ? parsedPrice.toStringAsFixed(0) : rawPrice;
        }

        if (lat != null && lon != null) {
          customerLatitude = lat;
          customerLongitude = lon;
          // center map and add marker
          await mapController.goToLocation(GeoPoint(latitude: lat, longitude: lon));
          await mapController.setZoom(zoomLevel: 15);
          try {
            await mapController.addMarker(GeoPoint(latitude: lat, longitude: lon));
          } catch (_) {}
        }

        if (mounted) setState(() {});
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal memuat detail: $e')));
    }
    if (mounted) setState(() => _loadingDetail = false);
  }
}