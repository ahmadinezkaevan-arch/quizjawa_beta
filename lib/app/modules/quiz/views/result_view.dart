// lib/app/modules/quiz/views/result_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/quiz_controller.dart';
import '../../main/controllers/main_controller.dart';
import '../../../data/services/firestore_service.dart';
import '../../../data/services/rumah_adat_progress_service.dart';
import '../../../data/services/tarian_adat_progress_service.dart';
import '../../../routes/app_pages.dart';

class ResultView extends StatefulWidget {
  const ResultView({super.key});

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  final FirestoreService           _service        = FirestoreService();
  final RumahAdatProgressService   _rumahProgress  = RumahAdatProgressService();
  final TarianAdatProgressService  _tarianProgress = TarianAdatProgressService();

  bool _submitted = false;
  bool _newUnlock = false;

  static const Map<String, Map<String, dynamic>> _quizMeta = {
    'rumah_joglo':    {'cardIndex': 0, 'totalCards': 5, 'kategori': 'rumah_adat'},
    'rumah_limasan':  {'cardIndex': 1, 'totalCards': 5, 'kategori': 'rumah_adat'},
    'rumah_tajug':    {'cardIndex': 2, 'totalCards': 5, 'kategori': 'rumah_adat'},
    'rumah_baduy':    {'cardIndex': 3, 'totalCards': 5, 'kategori': 'rumah_adat'},
    'rumah_kebaya':   {'cardIndex': 4, 'totalCards': 5, 'kategori': 'rumah_adat'},
    'tarian_adat':    {'cardIndex': 0, 'totalCards': 5, 'kategori': 'tarian_adat'},
    'tarian_saman':   {'cardIndex': 1, 'totalCards': 5, 'kategori': 'tarian_adat'},
    'tarian_kecak':   {'cardIndex': 2, 'totalCards': 5, 'kategori': 'tarian_adat'},
    'tarian_pendet':  {'cardIndex': 3, 'totalCards': 5, 'kategori': 'tarian_adat'},
    'tarian_bedhaya': {'cardIndex': 4, 'totalCards': 5, 'kategori': 'tarian_adat'},
  };

  @override
  void initState() {
    super.initState();
    _submitAll();
  }

  Future<void> _submitAll() async {
    final args = Get.arguments as Map<String, dynamic>;

    final int correct = args['correctAnswers'];
    final int total   = args['totalQuestions'];
    final int score   = ((correct / total) * 100).round();

    // FIX: baca quizId langsung dari arguments, bukan dari controller
    // Controller bisa di-recreate oleh QuizBinding saat masuk RESULT
    final String quizId    = (args['quizId']    as String? ?? '').trim();
    final String quizTitle = (args['quizTitle'] as String? ?? '').trim();
    final String quizImage = (args['quizImage'] as String? ?? '').trim();
    final String quizDesc  = (args['quizDescription'] as String? ?? '').trim();

    print('[ResultView] quizId="$quizId"');
    print('[ResultView] score=$score');
    print('[ResultView] meta=${_quizMeta[quizId]}');

    if (quizId.isEmpty) {
      print('[ResultView] WARNING: quizId kosong!');
    }

    await Future.wait([
      _service.submitScore(score),
      _service.saveQuizHistory(
        quizId:          quizId,
        quizTitle:       quizTitle,
        quizImage:       quizImage,
        quizDescription: quizDesc,
        score:           score,
      ),
    ]);

    bool unlocked = false;
    final meta = _quizMeta[quizId];

    if (meta != null) {
      final int    cardIndex  = meta['cardIndex']  as int;
      final int    totalCards = meta['totalCards'] as int;
      final String kategori   = meta['kategori']   as String;

      print('[ResultView] Mencoba unlock: kategori=$kategori, cardIndex=$cardIndex, score=$score');

      if (kategori == 'rumah_adat') {
        unlocked = await _rumahProgress.tryUnlockNext(
          currentCardIndex: cardIndex,
          score:            score,
          totalCards:       totalCards,
        );
      } else if (kategori == 'tarian_adat') {
        unlocked = await _tarianProgress.tryUnlockNext(
          currentCardIndex: cardIndex,
          score:            score,
          totalCards:       totalCards,
        );
      }
    } else {
      print('[ResultView] WARNING: quizId="$quizId" tidak ada di _quizMeta');
    }

    if (mounted) {
      setState(() {
        _submitted = true;
        _newUnlock = unlocked;
      });
    }
  }

  void _goToHome() {
    if (Get.isRegistered<MainController>()) {
      Get.find<MainController>().changeTab(0);
    }
    Get.offAllNamed(Routes.MAIN);
  }

  @override
  Widget build(BuildContext context) {
    final args        = Get.arguments as Map<String, dynamic>;
    final int correct = args['correctAnswers'];
    final int total   = args['totalQuestions'];
    final List questions = args['questions'];
    final List answers   = args['userAnswers'];
    final int wrong      = total - correct;
    final int percentage = ((correct / total) * 100).round();

    final String quizId    = (args['quizId']    as String? ?? '').trim();
    final String quizTitle = (args['quizTitle'] as String? ?? '').trim();
    final String quizImage = (args['quizImage'] as String? ?? '').trim();
    final String quizDesc  = (args['quizDescription'] as String? ?? '').trim();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF583410)),
          onPressed: _goToHome,
        ),
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
              'Kamu berhasil menyelesaikan quiz!\nBerikut adalah hasilmu',
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
                  if (!_submitted)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 6),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle,
                              color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            'Skor tersimpan',
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

            // ── Banner unlock card baru ───────────────
            if (_newUnlock) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F0E8),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: const Color(0xFFD4A045), width: 1.5),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lock_open,
                        color: Color(0xFFD4A045), size: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Quiz berikutnya telah terbuka!',
                        style: TextStyle(
                          color: Color(0xFF583410),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // ── Info jika skor kurang dari 60 ─────────
            if (_submitted && percentage < 60) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFFFF9800).withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        color: Color(0xFFFF9800), size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Raih skor 60% atau lebih untuk membuka quiz berikutnya.',
                        style: TextStyle(
                          color: const Color(0xFF583410).withValues(alpha: 0.8),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // ── Benar & Salah ────────────────────────
            Row(
              children: [
                Expanded(
                    child: _StatCard(label: 'Benar', value: '$correct')),
                const SizedBox(width: 16),
                Expanded(
                    child: _StatCard(label: 'Salah', value: '$wrong')),
              ],
            ),
            const SizedBox(height: 40),

            // ── Tombol Main Lagi ─────────────────────
            _ActionButton(
              label: 'Main Lagi',
              color: const Color(0xFF5D3A1A),
              onTap: () {
                final meta     = _quizMeta[quizId];
                final kategori = meta?['kategori'] as String? ?? '';
                if (kategori == 'tarian_adat') {
                  Get.offNamed(Routes.DETAIL_TARI, arguments: {
                    'quizId':    quizId,
                    'quizTitle': quizTitle,
                    'quizImage': quizImage,
                    'quizDesc':  quizDesc,
                  });
                } else {
                  Get.offNamed(Routes.DETAIL, arguments: {
                    'quizId':    quizId,
                    'quizTitle': quizTitle,
                    'quizImage': quizImage,
                    'quizDesc':  quizDesc,
                  });
                }
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
              label: 'Lihat Papan Peringkat',
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

class _ActionButton extends StatelessWidget {
  final String label;
  final Color  color;
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