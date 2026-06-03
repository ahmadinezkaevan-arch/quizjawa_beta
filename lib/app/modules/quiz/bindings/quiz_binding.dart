import 'package:get/get.dart';
import '../controllers/quiz_controller.dart';

class QuizBinding extends Bindings {
  @override
  void dependencies() {
    // FIX: hapus fenix:true dan gunakan Get.put agar controller
    // selalu dibuat ulang setiap kali masuk ke halaman quiz.
    // fenix:true menyebabkan controller lama di-reuse tanpa onInit
    // dipanggil ulang, sehingga quizId dari sesi sebelumnya terpakai.
    if (Get.isRegistered<QuizController>()) {
      Get.delete<QuizController>(force: true);
    }
    Get.put<QuizController>(QuizController());
  }
}