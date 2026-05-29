import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz_model.dart';

class FirestoreService {
  // Singleton — pakai instance yang sama di seluruh app
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Ambil semua quiz ─────────────────────────────────
  Future<List<QuizModel>> getAllQuizzes() async {
    try {
      final snapshot = await _db.collection('quizzes').get();
      return snapshot.docs
          .map((doc) => QuizModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error getAllQuizzes: $e');
      return [];
    }
  }

  // ── Cari quiz berdasarkan judul ──────────────────────
  Future<List<QuizModel>> searchQuizzes(String keyword) async {
    try {
      final snapshot = await _db.collection('quizzes').get();
      final all = snapshot.docs
          .map((doc) => QuizModel.fromFirestore(doc.data(), doc.id))
          .toList();

      // Tambah print ini untuk debug
      print('Total quiz dari Firestore: ${all.length}');
      print('Keyword: $keyword');
      for (var q in all) {
        print('Quiz title: ${q.title}');
      }

      return all
          .where((quiz) =>
              quiz.title.toLowerCase().contains(keyword.toLowerCase()) ||
              quiz.category.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    } catch (e) {
      print('Error searchQuizzes: $e');
      return [];
    }
  }

  // ── Ambil soal dari quiz tertentu ────────────────────
  Future<List<QuestionModel>> getQuestions(String quizId) async {
    try {
      final snapshot = await _db
          .collection('quizzes')
          .doc(quizId)
          .collection('questions')
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => QuestionModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error getQuestions: $e');
      return [];
    }
  }
}