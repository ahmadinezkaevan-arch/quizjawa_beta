import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/detail_controller.dart';
import '../../../routes/app_pages.dart';

class DetailView extends StatelessWidget {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final DetailController controller = Get.find<DetailController>();

    final args           = Get.arguments as Map<String, dynamic>?;
    final String quizId    = args?['quizId']    ?? 'rumah_joglo';
    final String quizTitle = args?['quizTitle'] ?? 'Rumah Joglo';
    final String quizDesc  = args?['quizDesc']  ??
        'Rumah Joglo adalah rumah adat khas masyarakat Jawa yang identik '
        'dengan bentuk atap bertingkat dan keberadaan saka guru (empat tiang '
        'utama) sebagai penopang bangunan. Rumah ini melambangkan status sosial, '
        'kewibawaan, dan nilai filosofi kehidupan masyarakat Jawa.\n\n'
        'Struktur Rumah Joglo umumnya terdiri dari beberapa bagian, seperti '
        'pendopo (ruang terbuka untuk menerima tamu), pringgitan, dan dalem '
        'sebagai ruang utama keluarga.\n\n'
        'Material bangunan Rumah Joglo biasanya terbuat dari kayu jati dengan '
        'ukiran khas Jawa yang sarat makna simbolis.';
    final String quizImage = args?['quizImage'] ?? 'assets/images/rumahjoglo.png';

    controller.setQuiz({
      'id':          quizId,
      'title':       quizTitle,
      'description': quizDesc,
      'image':       quizImage,
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: 280,
                width: double.infinity,
                child: Image.asset(
                  quizImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFF583410),
                  ),
                ),
              ),
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft:  Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 40, height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Color(0xFF583410)),
                    ),
                  ),
                ),
              ),
            ],
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            quizTitle,
                            style: const TextStyle(
                              color: Color(0xFF583410),
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.play_circle_outline, color: Color(0xFF583410), size: 20),
                            const SizedBox(width: 4),
                            Text('123', style: TextStyle(color: const Color(0xFF583410).withValues(alpha: 0.7), fontSize: 16)),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Obx(() => GestureDetector(
                          onTap: controller.toggleFavorite,
                          child: Row(
                            children: [
                              Icon(
                                controller.isFavorite.value ? Icons.bookmark : Icons.bookmark_border,
                                color: Colors.yellow, size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text('789', style: TextStyle(color: const Color(0xFF583410).withValues(alpha: 0.7), fontSize: 16)),
                            ],
                          ),
                        )),
                      ],
                    ),

                    const SizedBox(height: 15),
                    const Text('Deskripsi', style: TextStyle(color: Color(0xFF583410), fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(quizDesc, style: TextStyle(color: const Color(0xFF583410).withValues(alpha: 0.8), fontSize: 15), textAlign: TextAlign.justify),
                    const SizedBox(height: 32),

                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.toNamed(Routes.LEADERBOARD),
                          child: Container(
                            width: 56, height: 56,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.share_outlined, color: Color(0xFF583410), size: 35),
                          ),
                        ),
                        Obx(() => GestureDetector(
                          onTap: controller.toggleFavorite,
                          child: Container(
                            width: 56, height: 56,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                            child: Icon(
                              controller.isFavorite.value ? Icons.bookmark : Icons.bookmark_border,
                              color: Colors.yellow, size: 40,
                            ),
                          ),
                        )),
                        const SizedBox(width: 120),
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () => Get.toNamed(
                                Routes.QUIZ,
                                arguments: {
                                  'quizId':          quizId,
                                  'quizTitle':       quizTitle,
                                  'quizImage':       quizImage,       // ← untuk history
                                  'quizDescription': quizDesc,        // ← untuk history
                                },
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF583410),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                              child: const Text('Mainkan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}