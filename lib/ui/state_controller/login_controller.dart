import 'package:get/get.dart';
import '../../data/models/auth_utils.dart';
import '../../data/models/login_model.dart';
import '../../data/models/network_response.dart';
import '../../data/services/network_calling.dart';
import '../../data/utils/urls.dart';

class LoginController extends GetxController {
  bool _isInProgress = false;
  bool get loginInProgress=> _isInProgress;

  Future<bool> userLogIn(String email, String password) async {
    _isInProgress = true;
    update();
    final NetworkResponse response = await NetworkCalling().postRequest(
        Urls.login,
        <String, dynamic>{"email": email.trim(), "password": password},
        isLogin: true);
    _isInProgress = false;
    update();
    if (response.isSuccess) {
      LoginModel model = LoginModel.fromJson(response.body!);
      await AuthUtils.saveUserInfo(model);
      update();
      return true;
    } else {
      return false;
    }
  }
}
