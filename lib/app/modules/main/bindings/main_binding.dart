import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../search/controllers/search_controller.dart';
import '../../favorite/controllers/favorite_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<QuizSearchController>(
      () => QuizSearchController(),
      fenix: true,
    );
    if (!Get.isRegistered<FavoriteController>()) {
      Get.lazyPut<FavoriteController>(() => FavoriteController(), fenix: true);
    }
  }
}
