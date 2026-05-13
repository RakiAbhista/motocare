import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class TerdekatScreen extends StatefulWidget {
  const TerdekatScreen({super.key});

  @override
  State<TerdekatScreen> createState() => _TerdekatScreenState();
}

class _TerdekatScreenState extends State<TerdekatScreen> {
  late MapController mapController;

  @override
  void initState() {
    super.initState();
    const jawgAccessToken = 'wqvsLL2FCdRtoX4DSOBM9T5MEZefn5HlwFMNB4ywlOS3r2M62s6Va1FVPVGVqb64';

    mapController = MapController.customLayer(
      initPosition: GeoPoint(latitude: -6.9932, longitude: 110.4203), // Pusat di Semarang
      areaLimit: const BoundingBox(
        north: 6.5, south: -11.5, west: 94.5, east: 141.5, // Batas Indonesia
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
          // 1. REAL MAP DARI JAWG.IO
          Positioned.fill(
            child: OSMFlutter(
              controller: mapController,
              osmOption: OSMOption(
                zoomOption: const ZoomOption(
                  initZoom: 15,
                ),
                showZoomController: false,
                enableRotationByGesture: false,
                userLocationMarker: UserLocationMaker(
                  personMarker: const MarkerIcon(
                    icon: Icon(Icons.my_location, color: Colors.black, size: 48),
                  ),
                  directionArrowMarker: const MarkerIcon(
                    icon: Icon(Icons.navigation, color: Colors.black, size: 48),
                  ),
                ),
                // Titik-titik Pin Bengkel (Mock Koordinat di sekitar Semarang)
                staticPoints: [
                  StaticPositionGeoPoint(
                    "bengkel_pins",
                    const MarkerIcon(
                      icon: Icon(Icons.location_on, color: Color(0xFF002B80), size: 48),
                    ),
                    [
                      GeoPoint(latitude: -6.9920, longitude: 110.4210), // Bengkel 123
                      GeoPoint(latitude: -6.9950, longitude: 110.4180), // Bengkel 456
                      GeoPoint(latitude: -6.9900, longitude: 110.4250), // Bengkel 789
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 2. SEARCH BAR FLOATING
          Positioned(
            top: 60, // Turun sedikit dari status bar
            left: 20,
            right: 20,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.86),
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: const TextField(
                style: TextStyle(fontFamily: 'Mulish', fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Cari Bengkel Disekitar',
                  hintStyle: TextStyle(fontSize: 12, color: Colors.black54, fontFamily: 'Mulish'),
                  prefixIcon: Icon(Icons.search, color: Colors.black54),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),

          // 3. BOTTOM SHEET BENGKEL LIST
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, -4))],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    // Handle Bar
                    Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        children: [
                          _buildBengkelItem("Bengkel 123", "50m", true),
                          _buildBengkelItem("Bengkel 456", "150m", false),
                          _buildBengkelItem("Bengkel 789", "250m", false),
                          _buildBengkelItem("Bengkel 1234", "425m", false),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Widget Helper List Item
  Widget _buildBengkelItem(String nama, String jarak, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF002B80).withOpacity(0.1) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.build, size: 30, color: isDark ? const Color(0xFF002B80) : const Color(0xFF43474C)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nama, style: const TextStyle(fontFamily: 'Mulish', fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                const SizedBox(height: 4),
                const Text("Lorem ipsum dolor sit amet, consectetur", style: TextStyle(fontFamily: 'Mulish', fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Text(jarak, style: const TextStyle(fontFamily: 'Mulish', fontWeight: FontWeight.w900, fontSize: 18, color: Colors.black)),
        ],
      ),
    );
  }
}