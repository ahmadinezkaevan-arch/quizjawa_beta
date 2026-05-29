import 'package:get/get.dart';
import '../../favorite/controllers/favorite_controller.dart';

class DetailController extends GetxController {
  final Map<String, String> quiz = {
    'id': 'rumah_joglo',
    'title': 'Rumah Joglo',
    'description':
        'Telusuri keunikan Rumah Joglo yang mencerminkan filosofi dan budaya Jawa.',
    'image': 'assets/images/rumahjoglo.png',
  };

  late final FavoriteController _favoriteController;
  final isFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();
    _favoriteController = Get.find<FavoriteController>();
    isFavorite.value = _favoriteController.isFavorite(quiz['title'] ?? '');
  }

  void setQuiz(Map<String, String> selectedQuiz) {
    quiz
      ..clear()
      ..addAll(selectedQuiz);
    isFavorite.value = _favoriteController.isFavorite(quiz['title'] ?? '');
  }

  void toggleFavorite() {
    _favoriteController.toggleFavorite(quiz);
    isFavorite.value = _favoriteController.isFavorite(quiz['title'] ?? '');
  }
}
