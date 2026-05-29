import 'package:get/get.dart';
import '../controllers/quiz_controller.dart';

class QuizBinding extends Bindings {
  @override
  void dependencies() {
    // fenix: true agar controller tidak dihapus
    // saat berpindah dari QuizView ke ResultView
    Get.lazyPut<QuizController>(() => QuizController(), fenix: true);
  }
}