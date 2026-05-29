// lib/app/data/models/quiz_model.dart
//
// Model untuk data quiz dari Firestore

class QuizModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String image;

  QuizModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.image,
  });

  // Konversi dari Firestore document ke QuizModel
  factory QuizModel.fromFirestore(Map<String, dynamic> data, String id) {
    return QuizModel(
      id:          id,
      title:       data['title']       ?? '',
      description: data['description'] ?? '',
      category:    data['category']    ?? '',
      image:       data['image']       ?? '',
    );
  }
}

// ── Model untuk soal quiz ──────────────────────────────
class QuestionModel {
  final String id;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final int order;

  QuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.order,
  });

  // Konversi dari Firestore document ke QuestionModel
  factory QuestionModel.fromFirestore(Map<String, dynamic> data, String id) {
    return QuestionModel(
      id:            id,
      question:      data['question']      ?? '',
      options:       List<String>.from(data['options'] ?? []),
      correctAnswer: data['correctAnswer'] ?? '',
      order:         data['order']         ?? 0,
    );
  }
}