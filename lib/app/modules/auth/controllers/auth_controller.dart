import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../data/services/firestore_service.dart';

class AuthController extends GetxController {
  final FirebaseAuth    _auth    = FirebaseAuth.instance;
  final FirestoreService _service = FirestoreService();

  // State observable
  final RxBool   isLoading      = false.obs;
  final RxString errorMessage   = ''.obs;

  // ── Login ──────────────────────────────────────────
  Future<void> login(String email, String password) async {
    if (!_validateInputs(email, password)) return;

    try {
      isLoading.value    = true;
      errorMessage.value = '';

      await _auth.signInWithEmailAndPassword(
        email:    email.trim(),
        password: password.trim(),
      );

      // Berhasil → ke halaman utama
      Get.offAllNamed(Routes.MAIN);
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _handleAuthError(e.code);
    } finally {
      isLoading.value = false;
    }
  }

  // ── Register ───────────────────────────────────────
  Future<void> register(String email, String password) async {
    if (!_validateInputs(email, password)) return;

    try {
      isLoading.value    = true;
      errorMessage.value = '';

      final credential = await _auth.createUserWithEmailAndPassword(
        email:    email.trim(),
        password: password.trim(),
      );

      // Buat dokumen user di Firestore
      if (credential.user != null) {
        await _service.createUserIfNotExists(
          credential.user!.uid,
          email.trim(),
        );
      }

      // Berhasil → ke halaman utama
      Get.offAllNamed(Routes.MAIN);
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _handleAuthError(e.code);
    } finally {
      isLoading.value = false;
    }
  }

  // ── Logout ─────────────────────────────────────────
  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed(Routes.LANDING);
  }

  // ── Cek apakah user sudah login ────────────────────
  bool get isLoggedIn => _auth.currentUser != null;

  // ── Validasi input ─────────────────────────────────
  bool _validateInputs(String email, String password) {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      errorMessage.value = 'Email dan password tidak boleh kosong.';
      return false;
    }
    if (!GetUtils.isEmail(email.trim())) {
      errorMessage.value = 'Format email tidak valid.';
      return false;
    }
    if (password.trim().length < 6) {
      errorMessage.value = 'Password minimal 6 karakter.';
      return false;
    }
    return true;
  }

  // ── Terjemahkan kode error Firebase ke bahasa Indo ─
  String _handleAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Akun tidak ditemukan.';
      case 'wrong-password':
        return 'Password salah.';
      case 'email-already-in-use':
        return 'Email sudah digunakan.';
      case 'weak-password':
        return 'Password terlalu lemah, minimal 6 karakter.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'user-disabled':
        return 'Akun ini telah dinonaktifkan.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti.';
      case 'invalid-credential':
        return 'Email atau password salah.';
      default:
        return 'Terjadi kesalahan. Coba lagi.';
    }
  }
}