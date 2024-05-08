import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:task_manager/ui/screens/Auth/login.dart';
import '../../app.dart';
import '../models/auth_utils.dart';
import '../models/network_response.dart';

class NetworkCalling {
  Future<NetworkResponse> getRequest(String url) async {
    try {
      Response response = await get(Uri.parse(url),
          headers: {'token': AuthUtils.userInfo.token.toString()});

      log(response.statusCode.toString());
      log(response.body);

      if (response.statusCode == 200) {
        return NetworkResponse(response.statusCode, true,
            jsonDecode(response.body)); // return object
      } else if (response.statusCode == 401) {
        gotoLogin();
      } else {
        return NetworkResponse(
            response.statusCode, false, null); // return object
      }
    } catch (e) {
      log(e.toString());
    }
    return NetworkResponse(-1, false, null); // return object
  }

  Future<NetworkResponse> postRequest(String url, Map<String, dynamic> body,
      {bool isLogin = false}) async {
    try {
      Response response = await post(Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'token': AuthUtils.userInfo.token.toString()
          },
          body: jsonEncode(body));

      log(response.statusCode.toString());
      log(response.body);

      if (response.statusCode == 200) {
        return NetworkResponse(response.statusCode, true,
            jsonDecode(response.body)); // return object
      } else if (response.statusCode == 401) {
        if (!isLogin) {
          log('Go to method executed');
          gotoLogin();
        }
      } else {
        return NetworkResponse(
            response.statusCode, false, null); // return object
      }
    } catch (e) {
      log(e.toString());
    }
    return NetworkResponse(-1, false, null); // return object
  }
}

Future<void> gotoLogin() async {
  await AuthUtils.clearUserInfo();
  navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false);
}
