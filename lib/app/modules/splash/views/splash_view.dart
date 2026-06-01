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
          final double currentOffsetY =
              controller.phase1OffsetY.value + controller.phase2OffsetY.value;
          final double currentScale = controller.phase2Scale.value;

          // Phase 3: logo bergeser kiri dari tengah layar
          // nilai -0.22 * lebar = pergeseran absolut logo ke kiri
          // Teks mulai di posisi tengah (sama dg logo) lalu geser kanan
          final double logoShiftX = controller.phase3LogoOffsetX.value;
          final double textShiftX = controller.phase3TextOffsetX.value;
          final double textOpacity = controller.phase3TextOpacity.value;

          return Stack(
            children: [
              // ────────────────────────────────────────────────────────
              // Phase 1 & 2 — logo naik dan mengecil
              // Hanya aktif saat phase3 belum mulai (logoShiftX == 0)
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
              // Phase 3 — logo + teks dalam satu Row, keduanya sejajar
              // Logo geser kiri, teks fade-in dari tengah geser kanan
              // ────────────────────────────────────────────────────────
              if (logoShiftX < 0.0 || textOpacity > 0.0)
                Positioned.fill(
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Logo — geser ke kiri relatif dari posisi tengah Row
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
                        // Teks — fade-in dari tengah, geser ke kanan
                        Transform.translate(
                          offset: Offset(
                            // mulai dari kiri (posisi logo), geser ke posisi aslinya
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