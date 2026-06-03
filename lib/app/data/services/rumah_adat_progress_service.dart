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
    if (_progressRef == null) {
      print('[RumahAdat] getUnlockedCount: _progressRef null (uid=$_uid)');
      return 1;
    }
    try {
      final doc  = await _progressRef!.get();
      if (!doc.exists) {
        print('[RumahAdat] getUnlockedCount: dokumen belum ada → return 1');
        return 1;
      }
      final data  = doc.data() as Map<String, dynamic>?;
      final count = (data?['unlockedCount'] as num?)?.toInt() ?? 1;
      final result = count < 1 ? 1 : count;
      print('[RumahAdat] getUnlockedCount: $result');
      return result;
    } catch (e) {
      print('[RumahAdat] Error getUnlockedCount: $e');
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
    print('[RumahAdat] tryUnlockNext: cardIndex=$currentCardIndex, score=$score, total=$totalCards');

    if (_progressRef == null) {
      print('[RumahAdat] tryUnlockNext: GAGAL — _progressRef null, uid=$_uid');
      return false;
    }

    if (score < 60) {
      print('[RumahAdat] tryUnlockNext: GAGAL — skor $score < 60');
      return false;
    }

    try {
      final currentUnlocked = await getUnlockedCount();
      final nextIndex       = currentCardIndex + 1;

      print('[RumahAdat] tryUnlockNext: currentUnlocked=$currentUnlocked, nextIndex=$nextIndex');

      if (nextIndex >= totalCards) {
        print('[RumahAdat] tryUnlockNext: BATAL — nextIndex=$nextIndex >= totalCards=$totalCards (semua sudah terbuka)');
        return false;
      }

      if (nextIndex < currentUnlocked) {
        print('[RumahAdat] tryUnlockNext: BATAL — nextIndex=$nextIndex sudah terbuka sebelumnya (currentUnlocked=$currentUnlocked)');
        return false;
      }

      await _progressRef!.set(
        {'unlockedCount': nextIndex + 1},
        SetOptions(merge: true),
      );

      print('[RumahAdat] tryUnlockNext: BERHASIL — unlockedCount di-set ke ${nextIndex + 1}');
      return true;
    } catch (e) {
      print('[RumahAdat] Error tryUnlockNext: $e');
      return false;
    }
  }

  // ── Reset progress (untuk testing) ───────────────────
  Future<void> resetProgress() async {
    if (_progressRef == null) return;
    try {
      await _progressRef!.set({'unlockedCount': 1});
      print('[RumahAdat] resetProgress: unlockedCount di-reset ke 1');
    } catch (e) {
      print('[RumahAdat] Error resetProgress: $e');
    }
  }
}