import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/search_controller.dart';
import '../../../data/models/quiz_model.dart';
import '../../../routes/app_pages.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final QuizSearchController controller = Get.find<QuizSearchController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Pencarian',
          style: TextStyle(
            color: Color(0xFF583410),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Search Box ───────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) => controller.search(value),
                decoration: InputDecoration(
                  icon: const Icon(Icons.search, color: Color(0xFF6B3E11)),
                  hintText: 'Cari budaya...',
                  hintStyle: TextStyle(
                    color: const Color(0xFF6B3E11).withValues(alpha: 0.5),
                  ),
                  border: InputBorder.none,
                  suffixIcon: Obx(() => controller.keyword.value.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Color(0xFF6B3E11),
                          ),
                          onPressed: controller.clearSearch,
                        )
                      : const SizedBox.shrink()),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Konten dinamis ────────────────────────
            Expanded(
              child: Obx(() {
                // Loading
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF583410),
                    ),
                  );
                }

                // Belum search — tampilkan pencarian terkini
                if (!controller.hasSearched.value) {
                  return _buildRecentSearches(controller);
                }

                // Hasil kosong
                if (controller.searchResults.isEmpty) {
                  return _buildEmpty(controller.keyword.value);
                }

                // Ada hasil
                return _buildResults(controller.searchResults);
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ── Pencarian Terkini ──────────────────────────────────
  Widget _buildRecentSearches(QuizSearchController controller) {
    final List<String> recentSearches = [
      'Bahasa Daerah',
      'Pakaian Adat',
      'Tari',
      'Rumah Joglo',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pencarian terkini',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6B3E11),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: recentSearches
              .map((label) => GestureDetector(
                    onTap: () => controller.search(label),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF6B3E11).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        label,
                        style: const TextStyle(
                          color: Color(0xFF6B3E11),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  // ── Hasil Kosong ───────────────────────────────────────
  Widget _buildEmpty(String keyword) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 80,
            color: Color(0xFF583410),
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada hasil untuk\n"$keyword"',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF583410),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // ── Hasil Pencarian ────────────────────────────────────
  Widget _buildResults(List<QuizModel> results) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final quiz = results[index];
        return GestureDetector(
          onTap: () => Get.toNamed(
            Routes.DETAIL,
            arguments: {
              'quizId':    quiz.id,
              'quizTitle': quiz.title,
              'quizDesc':  quiz.description,
              'quizImage': quiz.image,
            },
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
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
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 100,
                      height: 100,
                      color: const Color(0xFF583410),
                      child: const Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Konten
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quiz.title,
                        style: const TextStyle(
                          color: Color(0xFF583410),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        quiz.category,
                        style: TextStyle(
                          color: const Color(0xFF583410).withValues(alpha: 0.6),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        quiz.description,
                        style: TextStyle(
                          color: const Color(0xFF583410).withValues(alpha: 0.7),
                          fontSize: 12,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}