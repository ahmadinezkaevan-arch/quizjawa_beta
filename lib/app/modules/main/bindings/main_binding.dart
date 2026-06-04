import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../leaderboard/controllers/leaderboard_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<LeaderboardController>(
      () => LeaderboardController(),
      fenix: true,
    );

    // Selalu buat ulang ProfileController
    // agar data akun lama tidak tersisa saat pindah akun
    if (Get.isRegistered<ProfileController>()) {
      Get.delete<ProfileController>(force: true);
    }
    Get.put<ProfileController>(ProfileController(), permanent: true);
  }
}