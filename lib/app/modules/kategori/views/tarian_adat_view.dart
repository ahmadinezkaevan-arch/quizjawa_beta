import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class TarianAdatView extends StatelessWidget {
  const TarianAdatView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> tarianList = [
      {
        'id':          'tarian_adat',
        'title':       'Tari Topeng Cirebon',
        'description': 'Jelajahi keunikan Tarian Topeng yang merupakan bagian dari warisan budaya Jawa.',
        'image':       'assets/images/taritopengcirebon.png',
      },
      {
        'id':          'tarian_saman',
        'title':       'Tarian Saman',
        'description': 'Kenali ciri khas Tarian Saman dan maknanya dalam konteks budaya Aceh.',
        'image':       'assets/images/tarisaman.png',
      },
      {
        'id':          'tarian_kecak',
        'title':       'Tarian Kecak',
        'description': 'Jelajahi keunikan Tarian Kecak yang merupakan bagian dari warisan budaya Bali.',
        'image':       'assets/images/tarikecak.png',
      },
      {
        'id':          'tarian_pendet',
        'title':       'Tarian Pendet',
        'description': 'Kenali ciri khas Tarian Pendet dan maknanya dalam konteks budaya Bali.',
        'image':       'assets/images/taripendet.png',
      },
      {
        'id':          'tarian_bedhaya',
        'title':       'Tarian Bedhaya',
        'description': 'Jelajahi keunikan Tarian Bedhaya yang menjadi ciri khas masyarakat Betawi.',
        'image':       'assets/images/taribedhaya.png',
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
          'Tarian Adat',
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
        itemCount: tarianList.length,
        itemBuilder: (context, index) {
          final item = tarianList[index];

          // Hanya tari_topeng yang sudah punya quiz di Firestore
          // Tambah id lain di sini setelah quiz diinput ke Firestore
          final bool hasQuiz = item['id'] == 'tarian_adat';

          return _TarianAdatItem(
            title:       item['title']!,
            description: item['description']!,
            image:       item['image']!,
            onTap: hasQuiz
                ? () => Get.toNamed(
                    Routes.DETAIL_TARI,
                    arguments: {
                      'quizId':    item['id'],
                      'quizTitle': item['title'],
                      'quizImage': item['image'],
                    },
                  )
                : () {},
          );
        },
      ),
    );
  }
}

// ── Widget Tarian Adat Item ────────────────────────────
class _TarianAdatItem extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final VoidCallback onTap;

  const _TarianAdatItem({
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
