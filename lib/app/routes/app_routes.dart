part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const LANDING       = _Paths.LANDING;
  static const LOGIN         = _Paths.LOGIN;
  static const SIGNUP        = _Paths.SIGNUP;
  static const MAIN          = _Paths.MAIN;
  static const DETAIL        = _Paths.DETAIL;
  static const DETAIL_TARI   = _Paths.DETAIL_TARI;
  static const KATEGORI      = _Paths.KATEGORI;
  static const RUMAH_ADAT    = _Paths.RUMAH_ADAT;
  static const TARI_ADAT     = _Paths.TARI_ADAT;
  static const BAJU_ADAT     = _Paths.BAJU_ADAT;
  static const QUIZ          = _Paths.QUIZ;
  static const RESULT        = _Paths.RESULT;
  static const ANSWER_REVIEW = _Paths.ANSWER_REVIEW;
  static const LEADERBOARD   = _Paths.LEADERBOARD;
  static const FAVORITE      = _Paths.FAVORITE;
  static const PROFILE       = _Paths.PROFILE;
  static const EDIT_PROFILE  = _Paths.EDIT_PROFILE;
  static const SEARCH        = _Paths.SEARCH;
}

abstract class _Paths {
  _Paths._();

  static const LANDING       = '/';
  static const LOGIN         = '/login';
  static const SIGNUP        = '/signup';
  static const MAIN          = '/main';
  static const DETAIL        = '/detail';
  static const DETAIL_TARI   = '/detail-tari';
  static const KATEGORI      = '/kategori';
  static const RUMAH_ADAT    = '/rumah-adat';
  static const BAJU_ADAT     = '/baju-adat';
  static const TARI_ADAT     = '/tari-adat';
  static const QUIZ          = '/quiz';
  static const RESULT        = '/result';
  static const ANSWER_REVIEW = '/answer-review';
  static const LEADERBOARD   = '/leaderboard';
  static const FAVORITE      = '/favorite';
  static const PROFILE       = '/profile';
  static const EDIT_PROFILE  = '/edit-profile';
  static const SEARCH        = '/search';
}
