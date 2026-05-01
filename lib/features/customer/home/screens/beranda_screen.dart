import 'package:flutter/material.dart';

import '../../../../widgets/custom_top_bar.dart';
import '../widgets/promo_banner_carousel.dart';

class BerandaScreen extends StatelessWidget {
  const BerandaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomTopBar(),
          const SizedBox(height: 16),
          const PromoBannerCarousel(),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Konten Beranda Lainnya...'),
          ),
        ],
      ),
    );
  }
}
