import 'package:flutter/material.dart';

class BackgroundMap extends StatelessWidget {
  const BackgroundMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: const Color(0xFFF8F9FF),
        child: Stack(
          children: [
            // Simulasi Peta dengan Grid/Pattern (Bisa diganti Image.asset)
            Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child: Image.network(
                  'https://www.transparenttextures.com/patterns/cubes.png',
                  repeat: ImageRepeat.repeat,
                ),
              ),
            ),
            // Simulasi Marker Lokasi
            const Positioned(
              top: 250,
              left: 180,
              child: Icon(
                Icons.my_location,
                size: 50,
                color: Color(0xFFF56523),
              ),
            ),
            const Positioned(
              top: 200,
              left: 100,
              child: Icon(
                Icons.location_on,
                size: 42,
                color: Color(0xFFF56523),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
