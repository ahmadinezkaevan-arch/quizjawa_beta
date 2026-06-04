import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../data/models/quiz_model.dart';
import '../../../routes/app_pages.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 57),
            _buildHeaderBanner(),
            const SizedBox(height: 14),
            _buildKategoriSection(),
            const SizedBox(height: 22),
            _buildQuizTerkiniSection(controller),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ── Header Banner ──────────────────────────────────────
  Widget _buildHeaderBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/backgroundatas.jpeg'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Tes Wawasan Budaya Jawa',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Uji seberapa dalam pengetahuanmu tentang\nkebudayaan yang ada di Jawa',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Get.toNamed(Routes.LANDING),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6A3E12),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 6,
            ),
            child: const Text(
              'Mulai Sekarang',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Kategori Section ───────────────────────────────────
  Widget _buildKategoriSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kategori',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF583410),
                ),
              ),
              TextButton(
                onPressed: () => Get.toNamed(Routes.KATEGORI),
                child: const Text(
                  'lihat semua',
                  style: TextStyle(fontSize: 14, color: Color(0xFF583410)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildKategoriCard('Rumah Adat',   'assets/images/rumahjoglo.png')),
              const SizedBox(width: 12),
              Expanded(child: _buildKategoriCard('Tarian Adat',  'assets/images/tarian.png')),
              const SizedBox(width: 12),
              Expanded(child: _buildKategoriCard('Pakaian Adat', 'assets/images/pakaianadat.png')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKategoriCard(String title, String imagePath) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF583410).withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(imagePath, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF583410).withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Quiz Terkini — data dari Firestore ─────────────────
  Widget _buildQuizTerkiniSection(HomeController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quiz Terkini',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B4423),
            ),
          ),
          const SizedBox(height: 20),

          Obx(() {
            // ── Loading ──────────────────────────────
            if (controller.isLoading.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(
                    color: Color(0xFF583410),
                  ),
                ),
              );
            }

            // ── Error ────────────────────────────────
            if (controller.errorMessage.value.isNotEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Text(
                        controller.errorMessage.value,
                        style: const TextStyle(color: Color(0xFF583410)),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: controller.fetchQuizzes,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF583410),
                        ),
                        child: const Text(
                          'Coba Lagi',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // ── Kosong ───────────────────────────────
            if (controller.quizList.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Text(
                    'Belum ada quiz tersedia.',
                    style: TextStyle(color: Color(0xFF583410)),
                  ),
                ),
              );
            }

            // ── Data tersedia ────────────────────────
            return Column(
              children: controller.quizList
                  .map((quiz) => _buildQuizItem(quiz))
                  .toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuizItem(QuizModel quiz) {
    return GestureDetector(
      onTap: () => Get.toNamed(_getQuizRoute(quiz)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
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
                quiz.image,
                width: 100,
                height: 122,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100,
                  height: 122,
                  color: const Color(0xFF583410),
                  child: const Icon(Icons.home, color: Colors.white, size: 40),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Konten
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    quiz.title,
                    style: const TextStyle(
                      color: Color(0xFF583410),
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    quiz.description,
                    style: TextStyle(
                      color: const Color(0xFF583410).withValues(alpha: 0.7),
                      fontSize: 13,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
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

  String _getQuizRoute(QuizModel quiz) {
    final id    = quiz.id.toLowerCase();
    final title = quiz.title.toLowerCase();

    if (id == 'rumah_joglo' || title == 'rumah joglo') {
      return Routes.RUMAH_ADAT;
    }

    if (id == 'tarian_adat' || title == 'tarian adat') {
      return Routes.TARI_ADAT;
    }

    if (id == 'pakaian_adat' || title == 'pakaian adat') {
      return Routes.BAJU_ADAT;
    }

    return Routes.DETAIL;
  }
}