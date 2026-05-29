import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller    = Get.find<AuthController>();
    final TextEditingController email    = TextEditingController();
    final TextEditingController password = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 110),

              // ── Judul ────────────────────────────────
              Text(
                'Masuk',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF583410),
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.13),
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 120),

              // ── Email ─────────────────────────────────
              const Text(
                'Email',
                style: TextStyle(
                  color: Color(0xFF583410),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _buildInputField(
                controller:   email,
                hint:         'Masukkan email',
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 24),

              // ── Password ──────────────────────────────
              const Text(
                'Sandi',
                style: TextStyle(
                  color: Color(0xFF583410),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _buildInputField(
                controller:  password,
                hint:        'Masukkan sandi',
                obscureText: true,
              ),

              const SizedBox(height: 12),

              // ── Pesan Error ───────────────────────────
              Obx(() => controller.errorMessage.value.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        controller.errorMessage.value,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : const SizedBox.shrink()),

              const SizedBox(height: 12),

              // ── Tombol Masuk ──────────────────────────
              Obx(() => Container(
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.login(email.text, password.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5A3511),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Masuk',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              )),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller:   controller,
        keyboardType: keyboardType,
        obscureText:  obscureText,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: const Color(0xFF583410).withValues(alpha: 0.28),
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}