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

  @override
  void initState() {
    super.initState();
    const jawgAccessToken =
        'wqvsLL2FCdRtoX4DSOBM9T5MEZefn5HlwFMNB4ywlOS3r2M62s6Va1FVPVGVqb64';

    mapController = MapController.customLayer(
      initPosition: GeoPoint(latitude: -6.9932, longitude: 110.4203),
      // Batasi area peta hanya di sekitar Indonesia
      areaLimit: const BoundingBox(
        north: 6.5,    // Sabang (ujung utara)
        south: -11.5,  // Rote (ujung selatan)
        west: 94.5,    // Sabang (ujung barat)
        east: 141.5,   // Merauke (ujung timur)
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
                zoomOption: const ZoomOption(
                  initZoom: 15,
                ),
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

          // 5. Draggable Bottom Sheet (Bisa di-slide)
          const DetailBottomSheet(),
        ],
      ),
    );
  }
}
