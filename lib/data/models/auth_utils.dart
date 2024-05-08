import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_model.dart';

class AuthUtils{
  AuthUtils._();
  static LoginModel userInfo = LoginModel();

  static Future<void>saveUserInfo(LoginModel model) async{
  SharedPreferences _sharedPrefs = await SharedPreferences.getInstance();
  await _sharedPrefs.setString('user-data',jsonEncode(model.toJson()));
  userInfo = model;
  }

  static Future<void>updateUserInfo(Data? updateData) async{
    SharedPreferences _sharedPrefs = await SharedPreferences.getInstance();
    userInfo.data = updateData;
    log("UpdateData is : ${updateData?.firstName}");
    log("First name is : ${userInfo.data?.firstName}");
    log("Total info : ${userInfo.data}");
    await _sharedPrefs.setString('user-data',jsonEncode(userInfo.toJson()));
    // await _sharedPrefs.reload();
  }

  static Future<void>getUserInfo() async{
  SharedPreferences _sharedPrefs = await SharedPreferences.getInstance();
  String value = _sharedPrefs.getString('user-data')!;
  userInfo = LoginModel.fromJson(jsonDecode(value));
  }

  static Future<void>clearUserInfo() async{
    SharedPreferences _sharedPrefs = await SharedPreferences.getInstance();
    await _sharedPrefs.clear();
  }

  static Future<bool> checkIsUserLoggedIn() async{
    SharedPreferences _sharedPrefs = await SharedPreferences.getInstance();
    bool isLoggedIn = _sharedPrefs.containsKey('user-data');
    if(isLoggedIn){
      await getUserInfo();
    }
    return isLoggedIn;
  }

}