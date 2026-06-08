import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import '../widgets/detail/floating_map_ui.dart';
import '../widgets/detail/detail_bottom_sheet.dart';

class DetailEmergencyScreen extends StatefulWidget {
  const DetailEmergencyScreen({super.key});

  @override
  State<DetailEmergencyScreen> createState() => _DetailEmergencyScreenState();
}

class _DetailEmergencyScreenState extends State<DetailEmergencyScreen> {
  // 1. Inisialisasi MapController
  late MapController mapController;

  // Mock customer coordinates: Tembalang, Semarang
  final double customerLatitude = -7.050186;
  final double customerLongitude = 110.438925;

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
            customerLatitude: customerLatitude,
            customerLongitude: customerLongitude,
          ),
        ],
      ),
    );
  }
}
