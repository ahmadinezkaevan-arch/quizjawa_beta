// lib/app/data/services/rumah_adat_progress_service.dart
//
// Menyimpan progress unlock rumah adat per user ke Firestore.
// Struktur: users/{uid}/progress/rumah_adat → { unlockedCount: N }
// unlockedCount = berapa card yang sudah terbuka (minimal 1, card pertama selalu terbuka)

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RumahAdatProgressService {
  static final RumahAdatProgressService _instance =
      RumahAdatProgressService._internal();
  factory RumahAdatProgressService() => _instance;
  RumahAdatProgressService._internal();

  final FirebaseFirestore _db   = FirebaseFirestore.instance;
  final FirebaseAuth      _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  DocumentReference? get _progressRef {
    if (_uid == null) return null;
    return _db
        .collection('users')
        .doc(_uid)
        .collection('progress')
        .doc('rumah_adat');
  }

  // ── Ambil jumlah card yang sudah terbuka ──────────────
  // Selalu minimal 1 (card pertama selalu unlocked)
  Future<int> getUnlockedCount() async {
    if (_progressRef == null) return 1;
    try {
      final doc = await _progressRef!.get();
      if (!doc.exists) return 1;
      final data = doc.data() as Map<String, dynamic>?;
      final count = (data?['unlockedCount'] as num?)?.toInt() ?? 1;
      return count < 1 ? 1 : count;
    } catch (e) {
      print('Error getUnlockedCount: $e');
      return 1;
    }
  }

  // ── Coba unlock card berikutnya setelah skor >= 60 ───
  // [currentCardIndex] = index card yang baru saja diselesaikan (0-based)
  // [score] = skor dalam persen (0–100)
  // Return: true jika berhasil unlock card baru
  Future<bool> tryUnlockNext({
    required int currentCardIndex,
    required int score,
    required int totalCards,
  }) async {
    if (_progressRef == null) return false;
    if (score < 60) return false; // syarat minimum

    try {
      final currentUnlocked = await getUnlockedCount();
      // Hanya unlock card berikutnya jika card ini adalah yang terakhir terbuka
      final nextIndex = currentCardIndex + 1;
      if (nextIndex >= totalCards) return false; // sudah semua terbuka
      if (nextIndex < currentUnlocked) return false; // sudah terbuka sebelumnya

      await _progressRef!.set(
        {'unlockedCount': nextIndex + 1},
        SetOptions(merge: true),
      );
      return true;
    } catch (e) {
      print('Error tryUnlockNext: $e');
      return false;
    }
  }
}