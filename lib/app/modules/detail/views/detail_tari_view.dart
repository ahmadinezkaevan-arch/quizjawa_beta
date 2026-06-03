// lib/app/modules/detail/views/detail_tari_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/detail_controller.dart';
import '../../../routes/app_pages.dart';

class DetailTariView extends StatefulWidget {
  const DetailTariView({super.key});

  @override
  State<DetailTariView> createState() => _DetailTariViewState();
}

class _DetailTariViewState extends State<DetailTariView> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String _longDescription = '';
  bool   _isLoadingDesc   = true;

  // Ambil dari arguments
  late final String quizId;
  late final String quizTitle;
  late final String quizImage;
  late final String quizDesc; // deskripsi pendek (dari list)

  @override
  void initState() {
    super.initState();
    final args  = Get.arguments as Map<String, dynamic>?;
    quizId      = args?['quizId']    ?? '';
    quizTitle   = args?['quizTitle'] ?? '';
    quizImage   = args?['quizImage'] ?? '';
    quizDesc    = args?['quizDesc']  ?? '';

    _fetchLongDescription();
  }

  Future<void> _fetchLongDescription() async {
    if (quizId.isEmpty) {
      setState(() {
        _longDescription = quizDesc; // fallback ke deskripsi pendek
        _isLoadingDesc   = false;
      });
      return;
    }

    try {
      final doc = await _db.collection('quizzes').doc(quizId).get();
      final data = doc.data();
      final long = data?['longDescription'] as String?;

      setState(() {
        // Jika longDescription ada di Firestore, pakai itu
        // Jika tidak, fallback ke deskripsi pendek dari arguments
        _longDescription = (long != null && long.trim().isNotEmpty)
            ? long.trim()
            : quizDesc;
        _isLoadingDesc   = false;
      });
    } catch (e) {
      print('Error fetchLongDescription: $e');
      setState(() {
        _longDescription = quizDesc;
        _isLoadingDesc   = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final DetailController controller = Get.find<DetailController>();

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
          // ── Header gambar ──────────────────────────
          Stack(
            children: [
              SizedBox(
                height: 280,
                width: double.infinity,
                child: Image.asset(
                  quizImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: const Color(0xFF583410)),
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
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF583410),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ── Konten ────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 24, right: 24, bottom: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Judul + stats + bookmark ──────
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
                            const Icon(
                              Icons.play_circle_outline,
                              color: Color(0xFF583410),
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '123',
                              style: TextStyle(
                                color: const Color(0xFF583410)
                                    .withValues(alpha: 0.7),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Obx(() => GestureDetector(
                          onTap: controller.toggleFavorite,
                          child: Row(
                            children: [
                              Icon(
                                controller.isFavorite.value
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                color: Colors.yellow,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '789',
                                style: TextStyle(
                                  color: const Color(0xFF583410)
                                      .withValues(alpha: 0.7),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // ── Label Deskripsi ───────────────
                    const Text(
                      'Deskripsi',
                      style: TextStyle(
                        color: Color(0xFF583410),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),

                    // ── Isi deskripsi / loading ───────
                    _isLoadingDesc
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF583410),
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : Text(
                            _longDescription,
                            style: TextStyle(
                              color: const Color(0xFF583410)
                                  .withValues(alpha: 0.8),
                              fontSize: 15,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.justify,
                          ),

                    const SizedBox(height: 32),

                    // ── Tombol aksi bawah ─────────────
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.toNamed(Routes.LEADERBOARD),
                          child: Container(
                            width: 56, height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.share_outlined,
                              color: Color(0xFF583410),
                              size: 35,
                            ),
                          ),
                        ),
                        Obx(() => GestureDetector(
                          onTap: controller.toggleFavorite,
                          child: Container(
                            width: 56, height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              controller.isFavorite.value
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: Colors.yellow,
                              size: 40,
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
                                  'quizImage':       quizImage,
                                  'quizDescription': quizDesc,
                                },
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF583410),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Mainkan',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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