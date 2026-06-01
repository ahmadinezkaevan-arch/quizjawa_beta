import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;

  // Phase 1: logo muncul dari bawah ke atas
  late Animation<double> phase1OffsetY;
  late Animation<double> phase1Opacity;

  // Phase 2: logo mengecil dan turun ke tengah
  late Animation<double> phase2OffsetY;
  late Animation<double> phase2Scale;

  // Phase 3: logo geser kiri + teks muncul dari tengah ke kanan
  late Animation<double> phase3LogoOffsetX;
  late Animation<double> phase3TextOffsetX;
  late Animation<double> phase3TextOpacity;

  @override
  void onInit() {
    super.onInit();
    _setupAnimations();
    _startAnimation();
  }

  void _setupAnimations() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    // ── Phase 1 ──────────────────────────────────────────
    phase1Opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.00, 0.15, curve: Curves.easeIn),
      ),
    );

    phase1OffsetY = Tween<double>(begin: 0.6, end: -0.28).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.00, 0.32, curve: Curves.easeOutCubic),
      ),
    );

    // ── Phase 2 ──────────────────────────────────────────
    phase2OffsetY = Tween<double>(begin: -0.28, end: 0.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.39, 0.61, curve: Curves.easeInOutCubic),
      ),
    );

    phase2Scale = Tween<double>(begin: 1.4, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.39, 0.61, curve: Curves.easeInOutCubic),
      ),
    );

    // ── Phase 3 ──────────────────────────────────────────
    phase3LogoOffsetX = Tween<double>(begin: 0.0, end: -0.22).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.68, 0.88, curve: Curves.easeOutCubic),
      ),
    );

    phase3TextOffsetX = Tween<double>(begin: 0.0, end: 0.18).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.72, 0.96, curve: Curves.easeOutCubic),
      ),
    );

    phase3TextOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.68, 0.82, curve: Curves.easeIn),
      ),
    );
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await animationController.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    // Selalu ke MAIN — home bisa diakses tanpa login
    // AuthGuard hanya aktif saat user menekan fitur yang butuh login (quiz)
    Get.offAllNamed(Routes.MAIN);
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}