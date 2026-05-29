import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/quiz_controller.dart';
import '../../../routes/app_pages.dart';

class ResultView extends StatelessWidget {
  const ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil data hasil dari arguments yang dikirim QuizController
    final args           = Get.arguments as Map<String, dynamic>;
    final int correct    = args['correctAnswers'];
    final int total      = args['totalQuestions'];
    final List questions = args['questions'];
    final List answers   = args['userAnswers'];
    final int wrong      = total - correct;
    final int percentage = ((correct / total) * 100).round();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text(
          'Hasil Quiz',
          style: TextStyle(
            color: Color(0xFF583410),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // ── Foto Profil ──────────────────────────
              Container(
                width: 110,
                height: 110,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/profil.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // ── Selamat ──────────────────────────────
              const Text(
                'Selamat!',
                style: TextStyle(
                  color: Color(0xFF5D3A1A),
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                'Anda berhasil menyelesaikan Kuis Rumah Adat!\nBerikut adalah hasil Anda',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF5D3A1A).withValues(alpha: 0.8),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 15),

              // ── Skor Akhir ───────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF5D3A1A).withValues(alpha: 0.77),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.13),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Skor Akhir',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '$percentage%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Benar & Salah ────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _StatCard(label: 'Benar', value: '$correct'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _StatCard(label: 'Salah', value: '$wrong'),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // ── Tombol Main Lagi ─────────────────────
              _ActionButton(
                label: 'Main Lagi',
                color: const Color(0xFF5D3A1A),
                onTap: () {
                  // Reset controller lalu ke halaman detail
                  Get.find<QuizController>().resetQuiz();
                  Get.offNamed(Routes.DETAIL);
                },
              ),
              const SizedBox(height: 12),

              // ── Tombol Lihat Jawaban ─────────────────
              _ActionButton(
                label: 'Lihat Jawaban Anda',
                color: const Color(0xFF5D3A1A).withValues(alpha: 0.77),
                onTap: () => Get.toNamed(
                  Routes.ANSWER_REVIEW,
                  arguments: {
                    'questions':   questions,
                    'userAnswers': answers,
                  },
                ),
              ),
              const SizedBox(height: 12),

              // ── Tombol Leaderboard ───────────────────
              _ActionButton(
                label: 'Kamu Peringkat 3 di Leaderboard!',
                color: const Color(0xFF5D3A1A).withValues(alpha: 0.5),
                onTap: () => Get.toNamed(Routes.LEADERBOARD),
              ),

              const SizedBox(height: 24),
            ],
          ),
      ),
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
      padding: const EdgeInsets.symmetric(vertical: 5),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF5D3A1A).withValues(alpha: 0.75),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF5D3A1A),
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widget Action Button ───────────────────────────────
class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 3,
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}