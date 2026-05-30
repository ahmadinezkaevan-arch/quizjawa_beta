import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../search/controllers/search_controller.dart';
import '../../favorite/controllers/favorite_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<QuizSearchController>(
      () => QuizSearchController(),
      fenix: true,
    );

    // Selalu buat ulang FavoriteController & ProfileController
    // agar data akun lama tidak tersisa saat pindah akun
    if (Get.isRegistered<FavoriteController>()) {
      Get.delete<FavoriteController>(force: true);
    }
    Get.put<FavoriteController>(FavoriteController(), permanent: true);

    if (Get.isRegistered<ProfileController>()) {
      Get.delete<ProfileController>(force: true);
    }
    Get.put<ProfileController>(ProfileController(), permanent: true);
  }
}