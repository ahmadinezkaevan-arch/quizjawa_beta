import 'dart:async';
import 'package:get/get.dart';
import '../../../data/services/firestore_service.dart';

class LeaderboardController extends GetxController {
  final FirestoreService _service = FirestoreService();

  final RxList<Map<String, dynamic>> entries  = <Map<String, dynamic>>[].obs;
  final RxBool                       isLoading = true.obs;
  final RxString                     currentUid = ''.obs;

  StreamSubscription<List<Map<String, dynamic>>>? _sub;

  @override
  void onInit() {
    super.onInit();
    currentUid.value = _service.currentUid ?? '';
    _listenLeaderboard();
  }

  void _listenLeaderboard() {
    _sub = _service.leaderboardStream().listen(
      (data) {
        entries.assignAll(data);
        isLoading.value = false;
      },
      onError: (e) {
        print('Leaderboard stream error: $e');
        isLoading.value = false;
      },
    );
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}