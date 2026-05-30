import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../data/services/firestore_service.dart';

class ProfileController extends GetxController {
  final FirebaseAuth     _auth    = FirebaseAuth.instance;
  final FirestoreService _service = FirestoreService();

  // State observable
  final isPasswordHidden = true.obs;
  final RxString username = ''.obs;
  final RxString email    = ''.obs;
  final RxBool   isLoadingProfile = true.obs;

  // Form controllers — nilainya diisi setelah data dimuat
  final usernameController = TextEditingController();
  final emailController    = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  // ── Load profil dari Firebase Auth + Firestore ─────
  Future<void> loadProfile() async {
    try {
      isLoadingProfile.value = true;

      // Email langsung dari Auth
      email.value = _auth.currentUser?.email ?? '';
      emailController.text = email.value;

      // Username dari Firestore
      final data = await _service.getUserProfile();
      username.value = data?['username'] ?? '';
      usernameController.text = username.value;
    } catch (e) {
      print('Error loadProfile: $e');
    } finally {
      isLoadingProfile.value = false;
    }
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