import 'package:get/get.dart';
import '../../auth/views/login_view.dart';
import '../../auth/views/signup_view.dart';

class LandingController extends GetxController {
  void goToRegister() {
    Get.to(() => const SignupView());
  }

  void goToLogin() {
    Get.to(() => const LoginView());
  }
}