import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // State observable
  final isPasswordHidden = true.obs;

  // Form controllers
  final usernameController = TextEditingController(text: 'Darlene Robertson');
  final emailController    = TextEditingController(text: 'darlene@gmail.com');
  final passwordController = TextEditingController();

  // ── Actions ────────────────────────────────────────
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void saveProfile() {
    Get.snackbar(
      'Berhasil',
      'Profil berhasil diperbarui',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF583410),
      colorText: Colors.white,
    );
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