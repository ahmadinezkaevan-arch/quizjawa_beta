
import 'package:get/get.dart';
import '../../../data/models/quiz_model.dart';
import '../../../data/services/firestore_service.dart';

class HomeController extends GetxController {
  final FirestoreService _service = FirestoreService();

  // State observable
  final RxList<QuizModel> quizList   = <QuizModel>[].obs;
  final RxBool isLoading             = true.obs;
  final RxString errorMessage        = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchQuizzes();
  }

  // Ambil semua quiz dari Firestore
  Future<void> fetchQuizzes() async {
    try {
      isLoading.value    = true;
      errorMessage.value = '';
      final result       = await _service.getAllQuizzes();
      quizList.assignAll(result);
    } catch (e) {
      errorMessage.value = 'Gagal memuat data. Coba lagi.';
    } finally {
      isLoading.value = false;
    }
  }
}