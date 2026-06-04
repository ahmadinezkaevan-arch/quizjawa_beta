import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../routes/app_pages.dart';
import '../../../data/services/firestore_service.dart';

class ProfileController extends GetxController {
  final FirebaseAuth     _auth    = FirebaseAuth.instance;
  final FirestoreService _service = FirestoreService();
  final ImagePicker      _picker  = ImagePicker();

  // State observable
  final isPasswordHidden      = true.obs;
  final RxString username     = ''.obs;
  final RxString email        = ''.obs;
  final RxString photoUrl     = ''.obs;
  final RxBool   isLoadingProfile   = true.obs;
  final RxBool   isUploadingPhoto   = false.obs;

  // Stats
  final RxInt totalQuizzes  = 0.obs;
  final RxInt averageScore  = 0.obs;

  // History
  final RxList<Map<String, dynamic>> historyList = <Map<String, dynamic>>[].obs;
  final RxBool isLoadingHistory = true.obs;

  // Form controllers
  final usernameController = TextEditingController();
  final emailController    = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
    loadStatsAndHistory();
  }

  // ── Load profil ────────────────────────────────────
  Future<void> loadProfile() async {
    try {
      isLoadingProfile.value = true;
      email.value            = _auth.currentUser?.email ?? '';
      emailController.text   = email.value;

      final data              = await _service.getUserProfile();
      username.value          = data?['username'] ?? '';
      photoUrl.value          = data?['photoUrl']  ?? '';
      usernameController.text = username.value;
    } catch (e) {
      print('Error loadProfile: $e');
    } finally {
      isLoadingProfile.value = false;
    }
  }

  // ── Load stats & history ───────────────────────────
  Future<void> loadStatsAndHistory() async {
    try {
      isLoadingHistory.value = true;

      final results = await Future.wait([
        _service.getUserStats(),
        _service.getQuizHistory(),
      ]);

      final stats   = results[0] as Map<String, dynamic>;
      final history = results[1] as List<Map<String, dynamic>>;

      totalQuizzes.value = stats['totalQuizzes'] as int;
      averageScore.value = stats['averageScore'] as int;
      historyList.assignAll(history);
    } catch (e) {
      print('Error loadStatsAndHistory: $e');
    } finally {
      isLoadingHistory.value = false;
    }
  }

  // ── BARU: Tampilkan dialog konfirmasi & hapus history ──
  void showDeleteHistoryDialog(String docId, String quizTitle) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.delete_outline, color: Color(0xFFC62828), size: 22),
            SizedBox(width: 8),
            Text(
              'Hapus Histori',
              style: TextStyle(
                color: Color(0xFF583410),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(
              color: Color(0xFF583410),
              fontSize: 14,
              height: 1.5,
            ),
            children: [
              const TextSpan(text: 'Hapus histori quiz '),
              TextSpan(
                text: '"$quizTitle"',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: '?\n\nData ini tidak dapat dikembalikan.'),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          // Tombol Batal
          OutlinedButton(
            onPressed: () => Get.back(),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF583410)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text(
              'Batal',
              style: TextStyle(color: Color(0xFF583410)),
            ),
          ),
          // Tombol Hapus
          ElevatedButton(
            onPressed: () async {
              Get.back(); // tutup dialog dulu
              await _deleteHistory(docId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC62828),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  // ── Eksekusi hapus dari Firestore & update list lokal ──
  Future<void> _deleteHistory(String docId) async {
    try {
      await _service.deleteQuizHistory(docId);

      // Hapus dari list lokal tanpa perlu reload seluruh halaman
      historyList.removeWhere((item) => item['docId'] == docId);

      // Hitung ulang stats dari data lokal yang tersisa
      _recalculateStats();

      Get.snackbar(
        'Berhasil',
        'Histori quiz berhasil dihapus',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF583410),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      );
    } catch (e) {
      print('Error _deleteHistory: $e');
      Get.snackbar(
        'Gagal',
        'Gagal menghapus histori. Coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      );
    }
  }

  // ── Hitung ulang stats dari historyList lokal ─────────
  void _recalculateStats() {
    final total = historyList.length;
    totalQuizzes.value = total;

    if (total == 0) {
      averageScore.value = 0;
      return;
    }

    final scores = historyList
        .map((item) => (item['score'] as num?)?.toInt() ?? 0)
        .toList();
    averageScore.value = (scores.reduce((a, b) => a + b) / total).round();
  }

  // ── Pilih & upload foto profil ──────────────────────
  Future<void> pickAndUploadPhoto() async {
    final source = await _showImageSourceDialog();
    if (source == null) return;

    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        maxWidth:  800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (picked == null) return;

      isUploadingPhoto.value = true;

      final File imageFile = File(picked.path);
      final String? url    = await _service.uploadProfilePhoto(imageFile);

      if (url != null) {
        photoUrl.value = url;
        Get.snackbar(
          'Berhasil',
          'Foto profil berhasil diperbarui',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF583410),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Gagal',
          'Gagal mengunggah foto. Coba lagi.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error pickAndUploadPhoto: $e');
      Get.snackbar(
        'Gagal',
        'Terjadi kesalahan. Coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploadingPhoto.value = false;
    }
  }

  // ── Dialog pilih sumber gambar ─────────────────────
  Future<ImageSource?> _showImageSourceDialog() async {
    return await Get.dialog<ImageSource>(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Pilih Sumber Foto',
          style: TextStyle(
            color: Color(0xFF583410),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF583410)),
              title: const Text(
                'Galeri',
                style: TextStyle(color: Color(0xFF583410)),
              ),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF583410)),
              title: const Text(
                'Kamera',
                style: TextStyle(color: Color(0xFF583410)),
              ),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
          ],
        ),
      ),
    );
  }

  // ── Actions ────────────────────────────────────────
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> saveProfile() async {
    try {
      final newUsername = usernameController.text.trim();
      await _service.updateUsername(newUsername);
      username.value = newUsername;

      Get.snackbar(
        'Berhasil',
        'Profil berhasil diperbarui',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF583410),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal menyimpan profil. Coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void showLogoutDialog() {
    Get.defaultDialog(
      title: 'Konfirmasi',
      titleStyle: const TextStyle(
        color: Color(0xFF583410),
        fontWeight: FontWeight.bold,
      ),
      middleText: 'Apakah kamu yakin ingin keluar dari akun?',
      middleTextStyle: const TextStyle(color: Color(0xFF583410)),
      backgroundColor: Colors.white,
      radius: 16,
      textCancel: 'Batal',
      textConfirm: 'Keluar',
      confirmTextColor: Colors.white,
      cancelTextColor: const Color(0xFF583410),
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        await _auth.signOut();
        Get.offAllNamed(Routes.LANDING);
      },
    );
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}