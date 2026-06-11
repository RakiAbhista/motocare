import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/core/theme/app_theme.dart';
import 'package:motocare/core/services/workshop_service.dart';
import 'package:motocare/features/customer/booking/models/booking_models.dart';

class TerdekatScreen extends StatefulWidget {
  const TerdekatScreen({super.key});

  @override
  State<TerdekatScreen> createState() => _TerdekatScreenState();
}

class _TerdekatScreenState extends State<TerdekatScreen> {
  late MapController mapController;
  final WorkshopService _workshopService = WorkshopService();
  List<Workshop> _workshops = [];
  List<Map<String, dynamic>> _nearest = [];
  bool _loadingWorkshops = true;
  bool _loadingNearest = false;
  bool _mapReady = false;
  final Set<int> _addedWorkshopIds = {};
  

  @override
  void initState() {
    super.initState();
    const jawgAccessToken =
        'wqvsLL2FCdRtoX4DSOBM9T5MEZefn5HlwFMNB4ywlOS3r2M62s6Va1FVPVGVqb64';

    mapController = MapController.customLayer(
      // Mulai di Semarang, nanti dipindah ke lokasi user setelah GPS ready
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

    // Load workshops di background, marker akan ditambah setelah map ready
    _loadWorkshops();
  }

  Future<void> _loadWorkshops() async {
    setState(() => _loadingWorkshops = true);
    final workshops = await _workshopService.getAllWorkshops();
    setState(() {
      _workshops = workshops;
      _loadingWorkshops = false;
    });
    print('🔵 [TerdekatScreen] loaded workshops: ${_workshops.length}');

    // Pastikan mapReady baru dipanggil. Nanti onMapIsReady jg manggil ini kok sbg backup.
    if (_mapReady) {
      await Future.delayed(const Duration(milliseconds: 300));
      await _addWorkshopMarkers();
    }
  }

  Future<void> _determinePositionAndNearest() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await _loadNearest(pos.latitude, pos.longitude);
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _centerAndZoomToCity() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) return;

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await mapController.goToLocation(
        GeoPoint(latitude: pos.latitude, longitude: pos.longitude),
      );
      await mapController.setZoom(zoomLevel: 13);

      await _loadNearest(pos.latitude, pos.longitude);
    } catch (e) {
      print('Error centerAndZoomToCity: $e');
    }
  }

  Future<void> _loadNearest(double lat, double lon) async {
    setState(() => _loadingNearest = true);
    final list = await _workshopService.getNearestWorkshops(lat, lon);
    setState(() {
      _nearest = list;
      _loadingNearest = false;
    });
    print('🔵 [TerdekatScreen] loaded nearest: ${_nearest.length}');
  }

  Future<void> _addWorkshopMarkers() async {
    if (!_mapReady || _workshops.isEmpty) return;

    // Wait a short moment and let the Flutter frame complete paint before
    // converting widget markers to PNGs inside the plugin. This avoids
    // '!debugNeedsPaint' crashes originating from _capturePng.
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      for (final w in _workshops) {
        if (_addedWorkshopIds.contains(w.id)) continue;

        final lat = double.tryParse(w.latitude) ?? 0.0;
        final lon = double.tryParse(w.longitude) ?? 0.0;

        await mapController.addMarker(
          GeoPoint(latitude: lat, longitude: lon),
          markerIcon: MarkerIcon(
            // Use a simpler, robust icon to avoid render issues on some plugin versions
            iconWidget: const Icon(
              Icons.build_circle,
              color: Color(0xFF104BAA),
              size: 48,
            ),
          ),
        );
        _addedWorkshopIds.add(w.id);
      }
      print('🔵 [TerdekatScreen] markers added: ${_addedWorkshopIds.length}');
    } catch (e) {
      print('Error adding workshop markers: $e');
    }
  }

  Future<void> refresh() async {
    _addedWorkshopIds.clear();
    await _loadWorkshops();
    await _determinePositionAndNearest();
    // If map already ready, ensure we show user location and adjust zoom
    if (_mapReady) {
      try {
        await mapController.currentLocation();
      } catch (_) {}
      try {
        await mapController.setZoom(zoomLevel: 11);
      } catch (_) {
        try {
          final dynamic ctrl = mapController;
          await ctrl.setZoom(11);
        } catch (_) {}
      }
    }

    setState(() {});
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
          // ── MAP ──────────────────────────────────────────────
          Positioned.fill(
            child: OSMFlutter(
              controller: mapController,
              osmOption: OSMOption(
                zoomOption: const ZoomOption(
                  initZoom: 11,
                  minZoomLevel: 3,
                  maxZoomLevel: 19,
                ),
                showZoomController: false,
                enableRotationByGesture: false,
                // Do not provide a custom `userLocationMarker` widget here.
                // Some versions of `flutter_osm_plugin` convert marker widgets
                // to images too early (before paint), causing '!debugNeedsPaint' crashes.
                // Let the plugin use its default user marker.
              ),
              onMapIsReady: (isReady) async {
                if (!isReady) return;
                _mapReady = true;

                // Kasih napas dikit biar engine OSM beneran stabil sebelum di-bombardir command
                await Future.delayed(const Duration(milliseconds: 500));

                try {
                  LocationPermission permission = await Geolocator.checkPermission();
                  if (permission == LocationPermission.denied) {
                    permission = await Geolocator.requestPermission();
                  }

                  if (permission != LocationPermission.denied &&
                      permission != LocationPermission.deniedForever) {

                    final pos = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high,
                    );

                    // FIX ICON USER: Cukup panggil currentLocation(), JANGAN pakai goToLocation lagi di sini.
                    // currentLocation() otomatis pindah map ke posisi user & nampilin icon biru.
                    try {
                      await mapController.currentLocation();
                      await Future.delayed(const Duration(milliseconds: 300)); // jeda sebelum zoom
                      await mapController.setZoom(zoomLevel: 13);
                    } catch (_) {}

                    // Load nearest workshops
                    await _loadNearest(pos.latitude, pos.longitude);
                  }
                } catch (e) {
                  print('Error on map ready: $e');
                }

                // Panggil marker bengkel di akhir setelah urusan kamera & GPS selesai
                await _addWorkshopMarkers();
              },
            ),
          ),

          // ── SEARCH BAR ───────────────────────────────────────
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
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Cari Bengkel Disekitar',
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          fontFamily: 'Poppins',
                        ),
                        prefixIcon:
                            Icon(Icons.search, color: Colors.black54),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _centerAndZoomToCity,
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.black54,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── BOTTOM SHEET BENGKEL ─────────────────────────────
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
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(28)),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Bengkel Terdekat',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              _loadingNearest
                                  ? 'Mencari...'
                                  : '${_nearest.isNotEmpty ? _nearest.length : _workshops.length} ditemukan',
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: _loadingWorkshops
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                controller: scrollController,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18),
                                itemCount: _nearest.isNotEmpty
                                    ? _nearest.length
                                    : _workshops.length,
                                itemBuilder: (context, index) {
                                  if (_nearest.isNotEmpty) {
                                    final item = _nearest[index];
                                    final name = item['name'] ?? '-';
                                    final lat = double.tryParse(
                                            item['latitude']?.toString() ??
                                                '') ??
                                        0.0;
                                    final lon = double.tryParse(
                                            item['longitude']?.toString() ??
                                                '') ??
                                        0.0;
                                    final distance =
                                        item['distance_meters'] != null
                                            ? '${item['distance_meters']}m'
                                            : '-';
                                    return _buildBengkelItem(
                                        name, distance, lat, lon);
                                  } else {
                                    final w = _workshops[index];
                                    final lat =
                                        double.tryParse(w.latitude) ?? 0.0;
                                    final lon =
                                        double.tryParse(w.longitude) ?? 0.0;
                                    return _buildBengkelItem(
                                        w.name, '-', lat, lon);
                                  }
                                },
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

  Widget _buildBengkelItem(
      String nama, String jarak, double lat, double lon) {
    return InkWell(
      onTap: () async {
        try {
          await mapController.goToLocation(
            GeoPoint(latitude: lat, longitude: lon),
          );
          await mapController.setZoom(zoomLevel: 15);
        } catch (e) {
          print('Error moving to workshop: $e');
        }
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Pilih: $nama')));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
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
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Icon(
                  Icons.build_rounded,
                  size: 28,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 12, color: Colors.grey.shade400),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Lat: ${lat.toStringAsFixed(5)}, Lon: ${lon.toStringAsFixed(5)}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  jarak,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}