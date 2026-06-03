import 'package:get/get.dart';
import '../../../data/models/quiz_model.dart';
import '../../../data/services/firestore_service.dart';
import '../../../routes/app_pages.dart';

class QuizController extends GetxController {
  final FirestoreService _service = FirestoreService();

  final RxList<QuestionModel> questions = <QuestionModel>[].obs;
  final RxBool   isLoading    = true.obs;
  final RxString errorMessage = ''.obs;
  final RxString quizTitle    = ''.obs;

  final currentIndex   = 0.obs;
  final correctAnswers = 0.obs;
  final selectedAnswer = Rxn<String>();

  late List<String?> userAnswers;
  late String quizId;

  String _quizImage       = '';
  String _quizDescription = '';

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>?;

    quizId               = (args?['quizId'] as String? ?? '').trim();
    quizTitle.value      = (args?['quizTitle'] as String? ?? 'Quiz').trim();
    _quizImage           = (args?['quizImage'] as String? ?? '').trim();
    _quizDescription     = (args?['quizDescription'] as String? ?? '').trim();

    print('[QuizController] onInit: quizId="$quizId"');
    print('[QuizController] onInit: quizTitle="${quizTitle.value}"');

    if (quizId.isEmpty) {
      print('[QuizController] WARNING: quizId kosong!');
      errorMessage.value = 'Quiz tidak ditemukan. Kembali dan coba lagi.';
      isLoading.value    = false;
      return;
    }

    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      isLoading.value    = true;
      errorMessage.value = '';
      final result       = await _service.getQuestions(quizId);
      questions.assignAll(result);
      userAnswers = List.filled(questions.length, null);
    } catch (e) {
      print('[QuizController] Error fetchQuestions: $e');
      errorMessage.value = 'Gagal memuat soal. Coba lagi.';
    } finally {
      isLoading.value = false;
    }
  }

  QuestionModel get currentQuestion => questions[currentIndex.value];
  int           get totalQuestions  => questions.length;
  bool          get isLastQuestion  => currentIndex.value == totalQuestions - 1;
  bool          get canProceed      => selectedAnswer.value != null;

  void selectAnswer(String answer) {
    selectedAnswer.value = answer;
  }

  void nextQuestion() {
    if (!canProceed) return;

    userAnswers[currentIndex.value] = selectedAnswer.value;

    if (selectedAnswer.value == currentQuestion.correctAnswer) {
      correctAnswers.value++;
    }

    if (!isLastQuestion) {
      currentIndex.value++;
      selectedAnswer.value = null;
    } else {
      // FIX: sertakan quizId & quizTitle langsung di arguments result
      // agar ResultView tidak perlu membaca dari controller yang mungkin
      // sudah di-recreate saat binding RESULT dijalankan
      Get.offNamed(
        Routes.RESULT,
        arguments: {
          'correctAnswers':  correctAnswers.value,
          'totalQuestions':  totalQuestions,
          'questions':       questions.toList(),
          'userAnswers':     userAnswers,
          'quizId':          quizId,           // ← FIX: tambahkan ini
          'quizTitle':       quizTitle.value,  // ← FIX: tambahkan ini
          'quizImage':       _quizImage,
          'quizDescription': _quizDescription,
        },
      );
    }
  }

  void resetQuiz() {
    currentIndex.value   = 0;
    correctAnswers.value = 0;
    selectedAnswer.value = null;
    userAnswers = List.filled(questions.length, null);
  }
}