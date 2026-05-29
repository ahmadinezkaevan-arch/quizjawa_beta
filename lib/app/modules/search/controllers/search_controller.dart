import 'package:get/get.dart';
import '../../../data/models/quiz_model.dart';
import '../../../data/services/firestore_service.dart';

class QuizSearchController extends GetxController {
  final FirestoreService _service = FirestoreService();

  // State observable
  final RxList<QuizModel> searchResults = <QuizModel>[].obs;
  final RxBool isLoading                = false.obs;
  final RxBool hasSearched              = false.obs;
  final RxString keyword                = ''.obs;

  Future<void> search(String value) async {
    keyword.value = value.trim();

    if (keyword.value.isEmpty) {
      searchResults.clear();
      hasSearched.value = false;
      return;
    }

    try {
      isLoading.value   = true;
      hasSearched.value = true;
      final result      = await _service.searchQuizzes(keyword.value);
      searchResults.assignAll(result);
    } catch (e) {
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void clearSearch() {
    searchResults.clear();
    hasSearched.value = false;
    keyword.value     = '';
  }
}