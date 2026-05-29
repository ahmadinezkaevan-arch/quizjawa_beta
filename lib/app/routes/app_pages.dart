import 'package:get/get.dart';

import '../modules/landing/bindings/landing_binding.dart';
import '../modules/landing/views/landing_view.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/signup_view.dart';

import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';

//import '../modules/home/bindings/home_binding.dart';
//import '../modules/home/views/home_view.dart';

import '../modules/detail/bindings/detail_binding.dart';
import '../modules/detail/views/detail_view.dart';
import '../modules/detail/views/detail_tari_view.dart';

import '../modules/kategori/bindings/kategori_binding.dart';
import '../modules/kategori/views/kategori_view.dart';
import '../modules/kategori/views/rumah_adat_view.dart';
import '../modules/kategori/views/tarian_adat_view.dart';
import '../modules/kategori/views/baju_adat_view.dart';

import '../modules/quiz/bindings/quiz_binding.dart';
import '../modules/quiz/views/quiz_view.dart';
import '../modules/quiz/views/result_view.dart';
import '../modules/quiz/views/answer_review_view.dart';

import '../modules/leaderboard/bindings/leaderboard_binding.dart';
import '../modules/leaderboard/views/leaderboard_view.dart';

import '../modules/favorite/bindings/favorite_binding.dart';
import '../modules/favorite/views/favorite_view.dart';

import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile/views/edit_profile_view.dart';

import '../modules/search/bindings/search_binding.dart';
import '../modules/search/views/search_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LANDING;

  static final routes = [
    // ── Landing ───────────────────────────────────────────
    GetPage(
      name: _Paths.LANDING,
      page: () => const LandingView(),
      binding: LandingBinding(),
    ),

    // ── Auth ──────────────────────────────────────────────
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: AuthBinding(),
    ),

    // ── Main Shell ────────────────────────────────────────
    GetPage(
      name: _Paths.MAIN,
      page: () => const MainView(),
      binding: MainBinding(),
    ),

    // ── Home ──────────────────────────────────────────────
    GetPage(
      name: _Paths.DETAIL,
      page: () => const DetailView(),
      binding: DetailBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_TARI,
      page: () => const DetailTariView(),
      binding: DetailBinding(),
    ),

    // ── Kategori ──────────────────────────────────────────
    GetPage(
      name: _Paths.KATEGORI,
      page: () => const KategoriView(),
      binding: KategoriBinding(),
    ),
    GetPage(
      name: _Paths.RUMAH_ADAT,
      page: () => const RumahAdatView(),
      binding: KategoriBinding(),
    ),
    GetPage(
      name: _Paths.TARI_ADAT,
      page: () => const TarianAdatView(),
      binding: KategoriBinding(),
    ),
    GetPage(
      name: _Paths.BAJU_ADAT,
      page: () => const BajuAdatView(),
      binding: KategoriBinding(),
    ),

    // ── Quiz Flow ─────────────────────────────────────────
    GetPage(
      name: _Paths.QUIZ,
      page: () => const QuizView(),
      binding: QuizBinding(),
    ),
    GetPage(
      name: _Paths.RESULT,
      page: () => const ResultView(),
      binding: QuizBinding(),
    ),
    GetPage(
      name: _Paths.ANSWER_REVIEW,
      page: () => const AnswerReviewView(),
    ),

    // ── Leaderboard ───────────────────────────────────────
    GetPage(
      name: _Paths.LEADERBOARD,
      page: () => const LeaderboardView(),
      binding: LeaderboardBinding(),
    ),

    // ── Favorite ──────────────────────────────────────────
    GetPage(
      name: _Paths.FAVORITE,
      page: () => const FavoriteView(),
      binding: FavoriteBinding(),
    ),

    // ── Profile ───────────────────────────────────────────
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: ProfileBinding(),
    ),

    // ── Search ────────────────────────────────────────────
    GetPage(
      name: _Paths.SEARCH,
      page: () => const SearchView(),
      binding: SearchBinding(),
    ),
  ];
}
