import 'package:get/get.dart';
import '../../../data/models/quiz_model.dart';
import '../../../data/services/firestore_service.dart';
import '../../../routes/app_pages.dart';

class QuizController extends GetxController {
  final FirestoreService _service = FirestoreService();

  // ── State observable ───────────────────────────────
  final RxList<QuestionModel> questions = <QuestionModel>[].obs;
  final RxBool isLoading               = true.obs;
  final RxString errorMessage          = ''.obs;
  final RxString quizTitle             = ''.obs;

  final currentIndex   = 0.obs;
  final correctAnswers = 0.obs;
  final selectedAnswer = Rxn<String>();

  late List<String?> userAnswers;
  late String quizId;

  @override
  void onInit() {
    super.onInit();
    // Ambil quizId dari arguments yang dikirim DetailView
    final args = Get.arguments as Map<String, dynamic>?;
    quizId         = args?['quizId']    ?? '';
    quizTitle.value = args?['quizTitle'] ?? 'Quiz';
    fetchQuestions();
  }

  // ── Fetch soal dari Firestore ──────────────────────
  Future<void> fetchQuestions() async {
    try {
      isLoading.value    = true;
      errorMessage.value = '';
      final result       = await _service.getQuestions(quizId);
      questions.assignAll(result);
      userAnswers = List.filled(questions.length, null);
    } catch (e) {
      errorMessage.value = 'Gagal memuat soal. Coba lagi.';
    } finally {
      isLoading.value = false;
    }
  }

  // ── Getter helper ──────────────────────────────────
  QuestionModel get currentQuestion => questions[currentIndex.value];
  int           get totalQuestions  => questions.length;
  bool          get isLastQuestion  => currentIndex.value == totalQuestions - 1;
  bool          get canProceed      => selectedAnswer.value != null;

  // ── Actions ────────────────────────────────────────
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
      Get.offNamed(
        Routes.RESULT,
        arguments: {
          'correctAnswers': correctAnswers.value,
          'totalQuestions': totalQuestions,
          'questions':      questions.toList(),
          'userAnswers':    userAnswers,
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