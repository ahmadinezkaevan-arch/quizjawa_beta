import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../routes/app_pages.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Color(0xFF583410),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingProfile.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF583410)),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // ── Foto Profil + Tombol Edit ──────────
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  // Avatar — tampilkan dari URL kalau ada, fallback ke asset
                  Obx(() {
                    final url = controller.photoUrl.value;
                    return Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: ClipOval(
                        child: url.isNotEmpty
                            ? Image.network(
                                url,
                                fit: BoxFit.cover,
                                width: 120,
                                height: 120,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return Container(
                                    color: const Color(0xFF583410)
                                        .withValues(alpha: 0.1),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF583410),
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stack) =>
                                    Image.asset(
                                  'assets/images/profilekosong.png',
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.asset(
                                'assets/images/profilekosong.png',
                                fit: BoxFit.cover,
                                width: 120,
                                height: 120,
                              ),
                      ),
                    );
                  }),

                  // Tombol edit foto
                  GestureDetector(
                    onTap: () => Get.toNamed(Routes.EDIT_PROFILE),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF583410),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ── Nama ──────────────────────────────
              Obx(() => Text(
                controller.username.value.isNotEmpty
                    ? controller.username.value
                    : 'Belum ada nama',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A3728),
                ),
              )),

              const SizedBox(height: 4),

              // ── Email ──────────────────────────────
              Obx(() => Text(
                controller.email.value,
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF4A3728).withValues(alpha: 0.7),
                ),
              )),

              const SizedBox(height: 24),

              // ── Statistik ──────────────────────────
              Obx(() => Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Quiz Terselesaikan',
                      value: '${controller.totalQuizzes.value}',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _StatCard(
                      label: 'Skor Rata-rata',
                      value: controller.totalQuizzes.value > 0
                          ? '${controller.averageScore.value}%'
                          : '-',
                    ),
                  ),
                ],
              )),

              const SizedBox(height: 32),

              // ── Histori Quiz ───────────────────────
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Histori Quiz',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A3728),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Obx(() {
                if (controller.isLoadingHistory.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(
                        color: Color(0xFF583410),
                      ),
                    ),
                  );
                }

                if (controller.historyList.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    decoration: BoxDecoration(
                      color: const Color(0xFF583410).withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.quiz_outlined,
                          size: 52,
                          color: const Color(0xFF583410).withValues(alpha: 0.4),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Kamu belum mengerjakan quiz.\nYuk mulai quiz pertamamu!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF583410).withValues(alpha: 0.6),
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: controller.historyList
                      .map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _HistoryCard(
                              docId:       item['docId']           ?? '',
                              title:       item['quizTitle']       ?? '',
                              description: item['quizDescription'] ?? '',
                              image:       item['quizImage']       ?? '',
                              score:       item['score']           ?? 0,
                              onDelete: () =>
                                  controller.showDeleteHistoryDialog(
                                item['docId'] ?? '',
                                item['quizTitle'] ?? '',
                              ),
                            ),
                          ))
                      .toList(),
                );
              }),

              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }
}

// ── Widget Stat Card ───────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF583410).withValues(alpha: 0.17),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF583410),
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF583410),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widget History Card ────────────────────────────────
class _HistoryCard extends StatelessWidget {
  final String docId;
  final String title;
  final String description;
  final String image;
  final int    score;
  final VoidCallback onDelete;

  const _HistoryCard({
    required this.docId,
    required this.title,
    required this.description,
    required this.image,
    required this.score,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Gambar ──────────────────────────────
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft:    Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            child: Image.asset(
              image,
              width: 100,
              height: 110,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 100,
                height: 110,
                decoration: const BoxDecoration(
                  color: Color(0xFF583410),
                  borderRadius: BorderRadius.only(
                    topLeft:    Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: const Icon(Icons.quiz, color: Colors.white, size: 40),
              ),
            ),
          ),

          // ── Konten ──────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 8, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Baris judul + tombol hapus
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Color(0xFF583410),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                      ),
                      // ── Tombol Hapus ────────────
                      GestureDetector(
                        onTap: onDelete,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.delete_outline,
                            color: const Color(0xFF583410).withValues(alpha: 0.5),
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Deskripsi
                  Text(
                    description,
                    style: TextStyle(
                      color: const Color(0xFF583410).withValues(alpha: 0.7),
                      fontSize: 12,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Badge skor
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _scoreColor(score).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _scoreColor(score).withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      'Skor: $score%',
                      style: TextStyle(
                        color: _scoreColor(score),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Color _scoreColor(int score) {
    if (score >= 80) return const Color(0xFF2E7D32);
    if (score >= 60) return const Color(0xFFF57F17);
    return const Color(0xFFC62828);
  }
}