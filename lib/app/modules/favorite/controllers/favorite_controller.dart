import 'package:get/get.dart';
import '../../../data/services/firestore_service.dart';

class FavoriteController extends GetxController {
  final FirestoreService _service = FirestoreService();

  final RxList<Map<String, String>> favoriteList = <Map<String, String>>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  // Cek favorit berdasarkan id (atau title sebagai fallback)
  bool isFavorite(String titleOrId) {
    return favoriteList.any(
      (item) => item['id'] == titleOrId || item['title'] == titleOrId,
    );
  }

  // Load dari Firestore
  Future<void> loadFavorites() async {
    try {
      isLoading.value = true;
      final result = await _service.getFavorites();
      favoriteList.assignAll(result);
    } catch (e) {
      print('Error loadFavorites: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle favorit
  Future<void> toggleFavorite(Map<String, String> quiz) async {
    final id = quiz['id'] ?? quiz['title'] ?? '';

    final existingIndex = favoriteList.indexWhere(
      (item) => item['id'] == id || item['title'] == quiz['title'],
    );

    if (existingIndex == -1) {
      // Tambah secara optimistis ke list lokal dulu
      favoriteList.add({...quiz, 'id': id});
      await _service.addFavorite(quiz);
    } else {
      // Hapus secara optimistis dari list lokal dulu
      favoriteList.removeAt(existingIndex);
      await _service.removeFavorite(id);
    }
  }

  // Dipakai saat pindah akun — reset list lokal lalu reload
  Future<void> refreshForCurrentUser() async {
    favoriteList.clear();
    await loadFavorites();
  }
}