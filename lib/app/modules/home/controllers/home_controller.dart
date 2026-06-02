
import 'package:get/get.dart';
import '../../../data/models/quiz_model.dart';
import '../../../data/services/firestore_service.dart';

class HomeController extends GetxController {
  final FirestoreService _service = FirestoreService();
  static const Set<String> _homeQuizKeys = {
    'rumah joglo',
    'rumah_joglo',
    'tarian adat',
    'tarian_adat',
  };

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
      quizList.assignAll(result.where(_isHomeQuiz));
    } catch (e) {
      errorMessage.value = 'Gagal memuat data. Coba lagi.';
    } finally {
      isLoading.value = false;
    }
  }

  bool _isHomeQuiz(QuizModel quiz) {
    final id    = quiz.id.toLowerCase();
    final title = quiz.title.toLowerCase();
    return _homeQuizKeys.contains(id) || _homeQuizKeys.contains(title);
  }
}
