import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteController extends GetxController {
  static const _storageKey = 'favorite_quizzes';

  final RxList<Map<String, String>> favoriteList = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
  }

  bool isFavorite(String title) {
    return favoriteList.any((item) => item['title'] == title);
  }

  void toggleFavorite(Map<String, String> quiz) {
    final index = favoriteList.indexWhere(
      (item) => item['title'] == quiz['title'],
    );

    if (index == -1) {
      favoriteList.add(quiz);
    } else {
      favoriteList.removeAt(index);
    }

    _saveFavorites();
  }

  void addFavorite(Map<String, String> quiz) {
    if (!isFavorite(quiz['title'] ?? '')) {
      favoriteList.add(quiz);
      _saveFavorites();
    }
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final savedFavorites = prefs.getString(_storageKey);
    if (savedFavorites == null) return;

    final decoded = jsonDecode(savedFavorites);
    if (decoded is! List) return;

    favoriteList.assignAll(
      decoded
          .whereType<Map>()
          .map(
            (item) => item.map(
              (key, value) => MapEntry(key.toString(), value.toString()),
            ),
          )
          .toList(),
    );
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(favoriteList));
  }
}
