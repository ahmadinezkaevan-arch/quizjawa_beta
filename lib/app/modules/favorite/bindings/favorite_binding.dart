import 'package:get/get.dart';
import '../controllers/favorite_controller.dart';

class FavoriteBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<FavoriteController>()) {
      Get.lazyPut<FavoriteController>(() => FavoriteController(), fenix: true);
    }
  }
}
