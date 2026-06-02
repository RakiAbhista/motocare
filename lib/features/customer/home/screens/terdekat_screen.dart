import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/core/theme/app_theme.dart';

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
      initPosition: GeoPoint(latitude: -6.9932, longitude: 110.4203),
      areaLimit: const BoundingBox(
        north: 6.5, south: -11.5, west: 94.5, east: 141.5,
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
      body: Stack(
        children: [
          Positioned.fill(
            child: OSMFlutter(
              controller: mapController,
              osmOption: OSMOption(
                zoomOption: const ZoomOption(initZoom: 15),
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
                staticPoints: [
                  StaticPositionGeoPoint(
                    "bengkel_pins",
                    const MarkerIcon(
                      icon: Icon(Icons.location_on, color: AppColors.primary, size: 48),
                    ),
                    [
                      GeoPoint(latitude: -6.9920, longitude: 110.4210),
                      GeoPoint(latitude: -6.9950, longitude: 110.4180),
                      GeoPoint(latitude: -6.9900, longitude: 110.4250),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const TextField(
                style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Cari Bengkel Disekitar',
                  hintStyle: TextStyle(fontSize: 12, color: Colors.black54, fontFamily: 'Poppins'),
                  prefixIcon: Icon(Icons.search, color: Colors.black54),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: DraggableScrollableSheet(
              initialChildSize: 0.35,
              minChildSize: 0.35,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 6,
                        offset: const Offset(0, -4),
                      ),
                    ],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildBengkelItem(String nama, String jarak, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.primaryLight : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Icon(
              Icons.build_rounded,
              size: 30,
              color: isDark ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nama,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black)),
                const SizedBox(height: 4),
                const Text("Lorem ipsum dolor sit amet, consectetur",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(jarak,
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: Colors.black)),
        ],
      ),
    );
  }
}
