import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class EmergencyMapSection extends StatelessWidget {
  final MapController mapController;

  const EmergencyMapSection({super.key, required this.mapController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// LOCATION HEADER
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "LIVE LOCATION",
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            const Row(
              children: [
                Icon(Icons.location_searching, size: 14, color: Colors.blue),
                SizedBox(width: 4),
                Text(
                  "TRACKING LIVE",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 14),

        /// OSM MAP
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 220,
            child: Stack(
              children: [
                /// MAP
                OSMFlutter(
                  controller: mapController,
                  osmOption: OSMOption(
                    zoomOption: const ZoomOption(
                      initZoom: 15,
                      minZoomLevel: 3,
                      maxZoomLevel: 19,
                    ),
                    userTrackingOption: const UserTrackingOption(
                      enableTracking: false,
                      unFollowUser: true,
                    ),
                  ),
                  onMapIsReady: (isReady) async {
                    if (isReady) {
                      await mapController.addMarker(
                        GeoPoint(latitude: -6.200000, longitude: 106.816666),
                        markerIcon: const MarkerIcon(
                          icon: Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 50,
                          ),
                        ),
                      );
                    }
                  },
                ),

                /// ADDRESS OVERLAY CARD
                Positioned(
                  top: 14,
                  left: 14,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blue, size: 18),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            "Jalan Raya Menteng, No. 42, Central Jakarta",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
