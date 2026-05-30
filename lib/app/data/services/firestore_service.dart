import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/quiz_model.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _db   = FirebaseFirestore.instance;
  final FirebaseAuth      _auth = FirebaseAuth.instance;

  String? get _uid       => _auth.currentUser?.uid;
  String? get currentUid => _auth.currentUser?.uid; // public untuk controller

  // ════════════════════════════════════════════════════
  // QUIZ
  // ════════════════════════════════════════════════════

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

  Future<List<QuizModel>> searchQuizzes(String keyword) async {
    try {
      final snapshot = await _db.collection('quizzes').get();
      final all = snapshot.docs
          .map((doc) => QuizModel.fromFirestore(doc.data(), doc.id))
          .toList();
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

  // ════════════════════════════════════════════════════
  // USER PROFILE
  // ════════════════════════════════════════════════════

  Future<void> createUserIfNotExists(String uid, String email) async {
    try {
      final ref = _db.collection('users').doc(uid);
      final doc = await ref.get();
      if (!doc.exists) {
        await ref.set({
          'email':     email,
          'username':  '',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error createUserIfNotExists: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    if (_uid == null) return null;
    try {
      final doc = await _db.collection('users').doc(_uid).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      print('Error getUserProfile: $e');
      return null;
    }
  }

  // set+merge: aman meski dokumen users/{uid} belum ada (akun lama)
  Future<void> updateUsername(String username) async {
    if (_uid == null) return;
    try {
      await _db.collection('users').doc(_uid).set(
        {
          'username': username,
          'email':    _auth.currentUser?.email ?? '',
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      print('Error updateUsername: $e');
      rethrow;
    }
  }

  // ════════════════════════════════════════════════════
  // FAVORIT
  // ════════════════════════════════════════════════════

  Future<List<Map<String, String>>> getFavorites() async {
    if (_uid == null) return [];
    try {
      final snapshot = await _db
          .collection('users')
          .doc(_uid)
          .collection('favorites')
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id':          doc.id,
          'title':       data['title']       as String? ?? '',
          'description': data['description'] as String? ?? '',
          'image':       data['image']       as String? ?? '',
        };
      }).toList();
    } catch (e) {
      print('Error getFavorites: $e');
      return [];
    }
  }

  Future<void> addFavorite(Map<String, String> quiz) async {
    if (_uid == null) return;
    try {
      final id = quiz['id'] ?? quiz['title'] ?? '';
      await _db
          .collection('users')
          .doc(_uid)
          .collection('favorites')
          .doc(id)
          .set({
        'title':       quiz['title']       ?? '',
        'description': quiz['description'] ?? '',
        'image':       quiz['image']       ?? '',
        'addedAt':     FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error addFavorite: $e');
    }
  }

  Future<void> removeFavorite(String quizId) async {
    if (_uid == null) return;
    try {
      await _db
          .collection('users')
          .doc(_uid)
          .collection('favorites')
          .doc(quizId)
          .delete();
    } catch (e) {
      print('Error removeFavorite: $e');
    }
  }

  // ════════════════════════════════════════════════════
  // LEADERBOARD  (koleksi: leaderboard/{uid})
  // ════════════════════════════════════════════════════

  // Submit skor — hanya simpan jika skor baru lebih tinggi dari sebelumnya
  Future<void> submitScore(int score) async {
    if (_uid == null) return;
    try {
      // Ambil username terbaru dari Firestore
      final profileDoc = await _db.collection('users').doc(_uid).get();
      final usernameRaw = profileDoc.data()?['username'] as String?;
      final username = (usernameRaw != null && usernameRaw.trim().isNotEmpty)
          ? usernameRaw.trim()
          : _auth.currentUser?.email ?? 'Anonim';

      final ref      = _db.collection('leaderboard').doc(_uid);
      final existing = await ref.get();

      if (!existing.exists) {
        // Belum pernah masuk leaderboard — langsung simpan
        await ref.set({
          'uid':       _uid,
          'username':  username,
          'score':     score,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        final currentScore =
            (existing.data()?['score'] as num?)?.toInt() ?? 0;
        if (score > currentScore) {
          // Skor baru lebih tinggi — update skor & username
          await ref.update({
            'username':  username,
            'score':     score,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        } else {
          // Skor tidak lebih tinggi — tetap update username kalau berubah
          await ref.update({'username': username});
        }
      }
    } catch (e) {
      print('Error submitScore: $e');
    }
  }

  // Ambil leaderboard — realtime stream diurutkan skor tertinggi
  Stream<List<Map<String, dynamic>>> leaderboardStream() {
    return _db
        .collection('leaderboard')
        .orderBy('score', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {
                  'uid':      doc.id,
                  'username': doc.data()['username'] ?? 'Anonim',
                  'score':    (doc.data()['score'] as num?)?.toInt() ?? 0,
                })
            .toList());
  }
}