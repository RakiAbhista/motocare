import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_colors.dart';
import 'package:motocare/core/theme/app_theme.dart';

class PromoBannerCarousel extends StatefulWidget {
  final List<dynamic>? banners;
  const PromoBannerCarousel({super.key, this.banners});

  @override
  State<PromoBannerCarousel> createState() => _PromoBannerCarouselState();
}

class _PromoBannerCarouselState extends State<PromoBannerCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_BannerItem> _banners = [
    _BannerItem(
      color: AppColors.primary,
      label: 'Promo Spesial Servis Hemat!',
      subtitle: 'Dapatkan diskon hingga 30%',
      icon: Icons.build_circle_outlined,
    ),
    _BannerItem(
      color: AppColors.warning,
      label: 'Diskon Oli hingga 20%',
      subtitle: 'Periode terbatas, jangan lewatkan!',
      icon: Icons.oil_barrel_rounded,
    ),
    _BannerItem(
      color: AppColors.secondary,
      label: 'Free Checkup Berkala',
      subtitle: 'Cek motor Anda secara gratis',
      icon: Icons.miscellaneous_services_rounded,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banners = widget.banners ?? [];
    
    if (banners.isEmpty) {
      return Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(child: Text('Tidak ada promo saat ini')),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 150,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _banners.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final banner = banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _banners[index].color,
                        _banners[index].color.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    boxShadow: [
                      BoxShadow(
                        color: _banners[index].color.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -10,
                          bottom: -10,
                          child: Icon(
                            _banners[index].icon,
                            size: 80,
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _banners[index].icon,
                                size: 28,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _banners[index].label,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _banners[index].subtitle,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 28 : 8,
              height: 8,
              decoration: BoxDecoration(
                gradient: _currentPage == index
                    ? const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                      )
                    : null,
                color: _currentPage == index ? null : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
                boxShadow: _currentPage == index
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 4,
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BannerItem {
  final Color color;
  final String label;
  final String subtitle;
  final IconData icon;
  const _BannerItem({
    required this.color,
    required this.label,
    required this.subtitle,
    required this.icon,
  });
}
