import 'package:flutter/material.dart';

class PromoBannerCarousel extends StatefulWidget {
  final List<dynamic>? banners;
  const PromoBannerCarousel({super.key, this.banners});

  @override
  State<PromoBannerCarousel> createState() => _PromoBannerCarouselState();
}

class _PromoBannerCarouselState extends State<PromoBannerCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

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
            itemCount: banners.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final banner = banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: banner['image_url'] != null
                        ? DecorationImage(
                            image: NetworkImage(banner['image_url']),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: Colors.lightBlue,
                  ),
                  child: banner['image_url'] == null 
                      ? Center(
                          child: Text(
                            banner['title'] ?? 'Promo Banner',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ) 
                      : null,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 12 : 8,
              height: _currentPage == index ? 12 : 8,
              decoration: BoxDecoration(
                color: _currentPage == index ? Colors.blue : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
