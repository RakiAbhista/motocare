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
    const jawgAccessToken =
        'wqvsLL2FCdRtoX4DSOBM9T5MEZefn5HlwFMNB4ywlOS3r2M62s6Va1FVPVGVqb64';

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
          Positioned.fill(
            child: OSMFlutter(
              controller: mapController,
              osmOption: OSMOption(
                zoomOption: const ZoomOption(initZoom: 15),
                showZoomController: false,
                enableRotationByGesture: false,
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
          
          Positioned(
            top: 50,
            right: 20,
            child: InkWell(
              onTap: () async {
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

          Positioned(
            top: 348,
            left: 40,
            right: 40,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.86),
                borderRadius: BorderRadius.circular(35),
              ),
              child: TextField(
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 14,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'Cari Bengkel Disekitar',
                  hintStyle: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.black54, size: 22),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
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
        ],
      ),
    );
  }

  Widget _buildGradientMapMarker({required double top, required double left, bool isActive = false}) {
    return Positioned(
      top: top,
      left: left,
      child: isActive
          ? ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (Rect bounds) => const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xB8002B80),
                  Color(0xFF002B80),
                ],
              ).createShader(bounds),
              child: const Icon(
                Icons.location_on,
                size: 42,
                color: Colors.white,
              ),
            )
          : Icon(
              Icons.location_on,
              size: 42,
              color: Colors.grey.shade400,
            ),
    );
  }

  Widget _buildGradientLocationIcon(bool isDark) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? const [
                Color(0xB8002B80),
                Color(0xFF002B80),
              ]
            : [
                const Color(0xFF43474C),
                const Color(0xFF43474C),
              ],
      ).createShader(bounds),
      child: const Icon(
        Icons.location_on,
        size: 65,
        color: Colors.white,
      ),
    );
  }

  Widget _buildBengkelItem(String nama, String jarak, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          _buildGradientLocationIcon(isDark),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "Lorem ipsum dolor sit amet, consectetur",
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            jarak,
            style: const TextStyle(
              fontFamily: 'Mulish',
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
