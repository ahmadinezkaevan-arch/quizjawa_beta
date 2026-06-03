// lib/app/data/services/tarian_adat_progress_service.dart
//
// Menyimpan progress unlock tarian adat per user ke Firestore.
// Struktur: users/{uid}/progress/tarian_adat → { unlockedCount: N }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TarianAdatProgressService {
  static final TarianAdatProgressService _instance =
      TarianAdatProgressService._internal();
  factory TarianAdatProgressService() => _instance;
  TarianAdatProgressService._internal();

  final FirebaseFirestore _db   = FirebaseFirestore.instance;
  final FirebaseAuth      _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  DocumentReference? get _progressRef {
    if (_uid == null) return null;
    return _db
        .collection('users')
        .doc(_uid)
        .collection('progress')
        .doc('tarian_adat');
  }

  // ── Ambil jumlah card yang sudah terbuka ──────────────
  Future<int> getUnlockedCount() async {
    if (_progressRef == null) return 1;
    try {
      final doc = await _progressRef!.get();
      if (!doc.exists) return 1;
      final data  = doc.data() as Map<String, dynamic>?;
      final count = (data?['unlockedCount'] as num?)?.toInt() ?? 1;
      return count < 1 ? 1 : count;
    } catch (e) {
      print('Error getUnlockedCount (tarian): $e');
      return 1;
    }
  }

  // ── Coba unlock card berikutnya setelah skor >= 60 ───
  Future<bool> tryUnlockNext({
    required int currentCardIndex,
    required int score,
    required int totalCards,
  }) async {
    if (_progressRef == null) return false;
    if (score < 60) return false;

    try {
      final currentUnlocked = await getUnlockedCount();
      final nextIndex = currentCardIndex + 1;
      if (nextIndex >= totalCards) return false;
      if (nextIndex < currentUnlocked) return false;

      await _progressRef!.set(
        {'unlockedCount': nextIndex + 1},
        SetOptions(merge: true),
      );
      return true;
    } catch (e) {
      print('Error tryUnlockNext (tarian): $e');
      return false;
    }
  }
}