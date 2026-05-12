import 'package:flutter/material.dart';

class TerdekatScreen extends StatelessWidget {
  const TerdekatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7F2FF),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFFE7F2FF),
            child: Stack(
              children: [
                _buildGradientMapMarker(top: 75, left: 42, isActive: true),
                _buildGradientMapMarker(top: 71, left: 308, isActive: true),
                _buildGradientMapMarker(top: 229, left: 91, isActive: true),
                Positioned(
                  top: 245,
                  left: MediaQuery.of(context).size.width / 2 - 30,
                  child: const Icon(Icons.my_location, size: 59, color: Colors.black),
                ),
              ],
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
