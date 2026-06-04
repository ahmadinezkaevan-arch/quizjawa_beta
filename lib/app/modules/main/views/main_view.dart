import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../../home/views/home_view.dart';
import '../../leaderboard/views/leaderboard_view.dart';
import '../../leaderboard/bindings/leaderboard_binding.dart';
import '../../profile/views/profile_view.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.find<MainController>();

    const Color brownColor = Color(0xFF583410);

    // Pastikan LeaderboardController tersedia saat tab Papan Skor dibuka
    LeaderboardBinding().dependencies();

    final List<Widget> pages = const [
      HomeView(),
      LeaderboardView(),
      ProfileView(),
    ];

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
      ),

      // ── Bottom Navigation Bar ────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(36, 6, 36, 36),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: brownColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _navItem(controller, Icons.home,         0, brownColor),
                _navItem(controller, Icons.leaderboard,  1, brownColor),
                _navItem(controller, Icons.person,       2, brownColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    MainController controller,
    IconData icon,
    int index,
    Color brownColor,
  ) {
    final bool isActive = controller.currentIndex.value == index;

    return GestureDetector(
      onTap: () => controller.changeTab(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 28,
          color: isActive ? brownColor : Colors.white,
        ),
      ),
    );
  }
}