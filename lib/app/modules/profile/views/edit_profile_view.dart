import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();
    const Color primaryColor = Color(0xFF583410);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF583410)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Edit Profil',
          style: TextStyle(
            color: Color(0xFF583410),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ── Foto Profil ──────────────────────────
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: primaryColor.withValues(alpha: 0.1),
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: primaryColor,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ── Form Username ─────────────────────────
            _buildField(
              label:        'Username',
              controller:   controller.usernameController,
              icon:         Icons.person_outline,
              primaryColor: primaryColor,
              readOnly:     false,
            ),

            // ── Email (read-only, dari Firebase Auth) ─
            _buildField(
              label:        'Email',
              controller:   controller.emailController,
              icon:         Icons.email_outlined,
              primaryColor: primaryColor,
              readOnly:     true,   // email tidak bisa diubah di sini
            ),

            // ── Form Password ─────────────────────────
            Obx(() => _buildField(
              label:            'Password Baru',
              controller:       controller.passwordController,
              icon:             Icons.lock_outline,
              primaryColor:     primaryColor,
              isPassword:       true,
              isPasswordHidden: controller.isPasswordHidden.value,
              onTogglePassword: controller.togglePasswordVisibility,
            )),

            const SizedBox(height: 25),

            // ── Tombol Simpan ─────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  'Simpan Perubahan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ── Tombol Keluar ─────────────────────────
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: controller.showLogoutDialog,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Keluar dari Akun',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required Color primaryColor,
    bool readOnly             = false,
    bool isPassword           = false,
    bool isPasswordHidden     = true,
    VoidCallback? onTogglePassword,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: readOnly
            ? const Color(0xFF583410).withValues(alpha: 0.05)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF583410).withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller:  controller,
        obscureText: isPassword ? isPasswordHidden : false,
        readOnly:    readOnly,
        style: TextStyle(
          color: readOnly
              ? primaryColor.withValues(alpha: 0.5)
              : primaryColor,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: primaryColor),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordHidden
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: primaryColor,
                  ),
                  onPressed: onTogglePassword,
                )
              : (readOnly
                  ? Icon(Icons.lock, size: 18,
                      color: primaryColor.withValues(alpha: 0.4))
                  : null),
          labelText:  label,
          labelStyle: TextStyle(
            color: readOnly
                ? primaryColor.withValues(alpha: 0.5)
                : primaryColor,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}