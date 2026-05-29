import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class BajuAdatView extends StatelessWidget {
  const BajuAdatView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> bajuList = [
      {
        'title':       'Baju Adat Jawa',
        'description': 'Jelajahi keunikan Baju Adat Jawa yang mencerminkan budaya dan tradisi lokal.',
        'image':       'assets/images/bajuadatjawa.png',
      },
      {
        'title':       'Baju Adat Sumatera',
        'description': 'Kenali ciri khas Baju Adat Sumatera dan maknanya dalam konteks budaya.',
        'image':       'assets/images/bajuadatsumatera.png',
      },
      {
        'title':       'Baju Adat Kalimantan',
        'description': 'Jelajahi keunikan Baju Adat Kalimantan yang mencerminkan budaya Dayak.',
        'image':       'assets/images/bajuadatkalimantan.png',
      },
      {
        'title':       'Baju Adat Papua',
        'description': 'Kenali ciri khas Baju Adat Papua dan maknanya dalam konteks budaya.',
        'image':       'assets/images/bajuadatpapua.png',
      },
      {
        'title':       'Rumah Kebaya',
        'description': 'Jelajahi keunikan Rumah Kebaya yang menjadi ciri khas masyarakat Betawi.',
        'image':       'assets/images/kebayak.png',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF583410)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Baju Adat',
          style: TextStyle(
            color: Color(0xFF583410),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF583410)),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bajuList.length,
        itemBuilder: (context, index) {
          final item = bajuList[index];
          return _BajuAdatItem(
            title:       item['title']!,
            description: item['description']!,
            image:       item['image']!,
            // Hanya Baju Adat Jawa yang sudah punya detail page
            onTap: index == 0 ? () => Get.toNamed(Routes.DETAIL) : () {},
          );
        },
      ),
    );
  }
}

// ── Widget Baju Adat Item ─────────────────────────────
class _BajuAdatItem extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final VoidCallback onTap;

  const _BajuAdatItem({
    required this.title,
    required this.description,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 25),
        padding: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.13),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                image,
                width: 100,
                height: 122,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100,
                  height: 122,
                  color: const Color(0xFF9B8B7E),
                  child: const Icon(Icons.home, color: Colors.white, size: 40),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Konten
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Color(0xFF583410),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            color: const Color(0xFF583410).withValues(alpha: 0.7),
                            fontSize: 13,
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF583410),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Mulai',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}