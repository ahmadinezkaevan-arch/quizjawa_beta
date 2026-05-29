import 'package:get/get.dart';
import '../controllers/detail_controller.dart';
import '../../favorite/controllers/favorite_controller.dart';

class DetailBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<FavoriteController>()) {
      Get.lazyPut<FavoriteController>(() => FavoriteController(), fenix: true);
    }
    Get.lazyPut<DetailController>(() => DetailController());
  }
}
