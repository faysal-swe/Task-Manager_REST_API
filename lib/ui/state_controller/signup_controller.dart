import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/services/network_calling.dart';
import '../../data/utils/urls.dart';

class SignupController extends GetxController{
  bool _isInProgress = false;
  bool get signupInProgress=> _isInProgress;

  Future<bool> userSignUp(String email, String firstName, String lastName, String mobile, String password) async {
    _isInProgress = true;
    update();
    final NetworkResponse response =
    await NetworkCalling().postRequest(Urls.registration, <String, dynamic>{
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "password": password,
      "photo": ""
    });
    _isInProgress = false;
    update();
    if (response.isSuccess) {
      // _emailTextEditingController.clear();
      // _firstNameTextEditingController.clear();
      // _lastNameTextEditingController.clear();
      // _mobileNumberTextEditingController.clear();
      // _passwordTextEditingController.clear();
      // if(mounted) {
      //   ScaffoldMessenger.of(context)
      //       .showSnackBar(
      //       const SnackBar(content: Text('Registration success!')));
      // }
      return true;
    }else {
      return false;
    }
  }
}