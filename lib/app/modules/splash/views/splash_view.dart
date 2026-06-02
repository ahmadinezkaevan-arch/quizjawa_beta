import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: controller.animationController,
        builder: (context, child) {
          // ── Fix: gunakan phase yang sedang aktif, bukan dijumlah ──
          // Phase 1 aktif  : 0.00 – 0.32  (logo naik dari bawah ke -0.18)
          // Phase 2 aktif  : 0.39 – 0.61  (logo turun dari -0.18 ke 0.0)
          // Di antara 0.32–0.39 animasi sedang "hold", phase1 sudah selesai
          // di -0.18 dan phase2 belum mulai → gunakan phase1 (sudah clamp di -0.18)
          final double progress = controller.animationController.value;
          final double currentOffsetY = progress < 0.39
              ? controller.phase1OffsetY.value   // phase 1 masih aktif / hold
              : controller.phase2OffsetY.value;  // phase 2 ambil alih (absolut ke 0.0)

          final double currentScale = controller.phase2Scale.value;

          // Phase 3 values
          final double logoShiftX   = controller.phase3LogoOffsetX.value;
          final double textShiftX   = controller.phase3TextOffsetX.value;
          final double textOpacity  = controller.phase3TextOpacity.value;

          return Stack(
            children: [
              // ────────────────────────────────────────────────────────
              // Phase 1 & 2 — logo naik lalu turun ke tengah layar
              // ────────────────────────────────────────────────────────
              if (logoShiftX == 0.0)
                Positioned.fill(
                  child: Opacity(
                    opacity: controller.phase1Opacity.value,
                    child: Transform.translate(
                      offset: Offset(0, currentOffsetY * screenHeight),
                      child: Transform.scale(
                        scale: currentScale,
                        child: Center(
                          child: Image.asset(
                            'assets/images/llogo.png',
                            width: 64,
                            height: 64,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // ────────────────────────────────────────────────────────
              // Phase 3 — logo geser kiri + teks fade-in geser kanan
              // Keduanya dimulai dari posisi tengah layar (0.0) sehingga
              // sambungan dari phase 2 selalu sejajar
              // ────────────────────────────────────────────────────────
              if (logoShiftX < 0.0 || textOpacity > 0.0)
                Positioned.fill(
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Logo — bergeser ke kiri dari pusat Row
                        Transform.translate(
                          offset: Offset(logoShiftX * 80, 0),
                          child: Image.asset(
                            'assets/images/llogo.png',
                            width: 64,
                            height: 64,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Teks — fade-in dari posisi logo, geser ke kanan
                        Transform.translate(
                          offset: Offset(
                            (1.0 - textShiftX / 0.18) * -80,
                            0,
                          ),
                          child: Opacity(
                            opacity: textOpacity,
                            child: Image.asset(
                              'assets/images/teksquiz.png',
                              height: 36,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}