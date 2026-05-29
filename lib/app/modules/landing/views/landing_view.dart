import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/routes/app_pages.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // ── Logo ────────────────────────────────────
              Image.asset(
                'assets/images/logo.png',
                width: 231,
                height: 217,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: const Color(0xFF583410).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.image,
                      size: 80,
                      color: Color(0xFF583410),
                    ),
                  );
                },
              ),
              const SizedBox(height: 200),

              const Spacer(flex: 2),

              // ── Selamat Datang ───────────────────────────
              const Text(
                'Selamat Datang!',
                style: TextStyle(
                  color: Color(0xFF583410),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              // ── Tombol Daftar ────────────────────────────
              Container(
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.13),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => Get.toNamed(Routes.SIGNUP),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF583410),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Daftar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Tombol Masuk ─────────────────────────────
              Container(
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.13),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => Get.toNamed(Routes.LOGIN),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4A045).withValues(alpha: 0.71),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Masuk',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Teks Bawah ───────────────────────────────
              const Text(
                'Pelajari budaya Jawa mulai dari quiz',
                style: TextStyle(
                  color: Color(0xFF583410),
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}