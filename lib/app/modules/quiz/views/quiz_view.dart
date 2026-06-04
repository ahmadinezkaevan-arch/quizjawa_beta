import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/quiz_controller.dart';

class QuizView extends StatelessWidget {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context) {
    final QuizController controller = Get.find<QuizController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 130,
        backgroundColor: Colors.white,
        title: Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 90),
            Text(
              controller.quizTitle.value,
              style: const TextStyle(
                color: Color(0xFF583410),
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )),
        centerTitle: true,
      ),
      body: Obx(() {
        // ── Loading ────────────────────────────────
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF583410),
            ),
          );
        }

        // ── Error ──────────────────────────────────
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Color(0xFF583410)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: controller.fetchQuestions,
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
          );
        }

        // ── Soal kosong ────────────────────────────
        if (controller.questions.isEmpty) {
          return const Center(
            child: Text(
              'Soal belum tersedia.',
              style: TextStyle(color: Color(0xFF583410)),
            ),
          );
        }

        // ── Quiz ───────────────────────────────────
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            children: [
              // ── Card Soal ──────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF5D3A1A),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.13),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header + progress
                    const Text(
                      'Soal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      '${controller.currentIndex.value + 1}/${controller.totalQuestions}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 3,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: (controller.currentIndex.value + 1) /
                            controller.totalQuestions,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Pertanyaan
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        controller.currentQuestion.question,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF5D3A1A),
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Card Pilihan Jawaban ────────────────
              Container(
                margin: const EdgeInsets.only(top: 22),
                width: double.infinity,
                padding: const EdgeInsets.only(top: 22, left: 24, right: 24, bottom: 0),
                decoration: BoxDecoration(
                  color: const Color(0xFF5D3A1A),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.13),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ...controller.currentQuestion.options.asMap().entries.map((entry) {
                      final int    idx    = entry.key;
                      final String option = entry.value;
                      final String prefix = String.fromCharCode(65 + idx);

                      final String? selected      = controller.selectedAnswer.value;
                      final String  correctAnswer  = controller.currentQuestion.correctAnswer;
                      final bool    hasAnswered    = selected != null;

                      final bool isSelected       = selected == option;
                      final bool isCorrectOption  = option == correctAnswer;
                      final bool isWrongSelection = isSelected && selected != correctAnswer;
                      final bool isRightSelection = isSelected && selected == correctAnswer;

                      // ── Tentukan warna background & border ──
                      Color bgColor     = const Color(0xFFF2EDE8);   // default
                      Color borderColor = Colors.transparent;
                      Color textColor   = const Color(0xFF5D3A1A);
                      Widget? trailingIcon;

                      if (hasAnswered) {
                        if (isRightSelection) {
                          // Pilihan benar → hijau
                          bgColor     = const Color(0xFF4CAF50);
                          borderColor = const Color(0xFF388E3C);
                          textColor   = Colors.white;
                          trailingIcon = _buildFeedbackIcon(Icons.check_circle, Colors.white);
                        } else if (isWrongSelection) {
                          // Pilihan salah yang dipilih → merah
                          bgColor     = const Color(0xFFF44336);
                          borderColor = const Color(0xFFC62828);
                          textColor   = Colors.white;
                          trailingIcon = _buildFeedbackIcon(Icons.cancel, Colors.white);
                        } else if (isCorrectOption) {
                          // Tampilkan jawaban benar → hijau (saat user salah pilih)
                          bgColor     = const Color(0xFF4CAF50);
                          borderColor = const Color(0xFF388E3C);
                          textColor   = Colors.white;
                          trailingIcon = _buildFeedbackIcon(Icons.check_circle, Colors.white);
                        }
                        // opsi lain tetap abu/default
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 22),
                        child: InkWell(
                          onTap: hasAnswered
                              ? null // nonaktifkan tap setelah memilih
                              : () async {
                                  controller.selectAnswer(option);
                                  await Future.delayed(
                                    const Duration(milliseconds: 800),
                                  );
                                  controller.nextQuestion();
                                },
                          borderRadius: BorderRadius.circular(14),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 21,
                            ),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: borderColor,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '$prefix. $option',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: textColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                if (trailingIcon != null) ...[
                                  const SizedBox(width: 8),
                                  trailingIcon,
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildFeedbackIcon(IconData icon, Color color) {
    return Icon(icon, color: color, size: 22);
  }
}