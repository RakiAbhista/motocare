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
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 12,
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
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 10,
                        offset: const Offset(0, -6),
                      ),
                    ],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Bengkel Terdekat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('4 ditemukan', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          children: [
                            _buildBengkelItem("Bengkel 123", "50m", "Jl. Banjarsari No. 212", 4.8, true),
                            _buildBengkelItem("Bengkel 456", "150m", "Jl. Tembalang Raya No. 45", 4.6, false),
                            _buildBengkelItem("Bengkel 789", "250m", "Jl. Bukit Permai No. 78", 4.5, false),
                            _buildBengkelItem("Bengkel 1234", "425m", "Jl. Diponegoro No. 112", 4.3, false),
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

  Widget _buildBengkelItem(String nama, String jarak, String alamat, double rating, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primary.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: isDark
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.2))
            : Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.04 : 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.primaryLight : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                boxShadow: isDark
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          blurRadius: 4,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                Icons.build_rounded,
                size: 28,
                color: isDark ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(nama,
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black)),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber.shade600, size: 14),
                          const SizedBox(width: 2),
                          Text(rating.toString(), style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 12, color: Colors.grey.shade400),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(alamat,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 11,
                                color: AppColors.textSecondary)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(jarak,
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
