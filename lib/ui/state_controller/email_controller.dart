import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/services/network_calling.dart';
import '../../data/utils/urls.dart';

class EmailController extends GetxController{
  bool _isInProgress = false;
  bool get emailInProgress=> _isInProgress;
  Future<bool> emailVerification(String email) async {
    _isInProgress = true;
    update();
    NetworkResponse response = await NetworkCalling()
        .getRequest(Urls.emailVerification(email));
    _isInProgress = false;
    update();
    if (response.isSuccess) {
      return true;
    } else {
      return false;
    }
  }
}