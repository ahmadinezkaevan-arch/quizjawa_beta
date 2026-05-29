import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/quiz_model.dart';

class AnswerReviewView extends StatelessWidget {
  const AnswerReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil data dari arguments yang dikirim ResultView
    final args                       = Get.arguments as Map<String, dynamic>;
    final List<QuestionModel> questions   = List<QuestionModel>.from(args['questions']);
    final List<String?>       userAnswers = List<String?>.from(args['userAnswers']);

    return Scaffold(
      backgroundColor: const Color(0xFF583410),
      appBar: AppBar(
        backgroundColor: const Color(0xFF583410),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Jawaban Anda',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final QuestionModel question = questions[index];
          final String?       userAnswer = userAnswers[index];
          final bool          isCorrect  = userAnswer == question.correctAnswer;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header soal ──────────────────────
                Text(
                  'Soal ${index + 1}',
                  style: const TextStyle(
                    color: Color(0xFF5D3A1A),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // ── Pertanyaan ────────────────────────
                Text(
                  question.question,
                  style: TextStyle(
                    color: const Color(0xFF5D3A1A).withValues(alpha: 0.85),
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),

                // ── Opsi jawaban ──────────────────────
                ...question.options.asMap().entries.map((entry) {
                  final int    optionIndex     = entry.key;
                  final String option          = entry.value;
                  final String prefix          = String.fromCharCode(65 + optionIndex);
                  final bool   isUserAnswer    = userAnswer == option;
                  final bool   isCorrectAnswer = option == question.correctAnswer;

                  Color   borderColor  = const Color(0xFFE0E0E0);
                  Widget? trailingIcon;

                  if (isUserAnswer && isCorrect) {
                    borderColor  = const Color(0xFF4CAF50);
                    trailingIcon = _buildIcon(Icons.check, const Color(0xFF4CAF50));
                  } else if (isUserAnswer && !isCorrect) {
                    borderColor  = const Color(0xFFF44336);
                    trailingIcon = _buildIcon(Icons.close, const Color(0xFFF44336));
                  } else if (isCorrectAnswer && !isCorrect) {
                    borderColor  = const Color(0xFF4CAF50);
                    trailingIcon = _buildIcon(Icons.check, const Color(0xFF4CAF50));
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor, width: 2),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '$prefix. ',
                          style: const TextStyle(
                            color: Color(0xFF5D3A1A),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            option,
                            style: const TextStyle(
                              color: Color(0xFF5D3A1A),
                              fontSize: 16,
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
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildIcon(IconData icon, Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }
}